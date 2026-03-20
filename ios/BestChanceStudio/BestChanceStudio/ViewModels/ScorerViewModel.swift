import SwiftUI
import SwiftData

@Observable
final class ScorerViewModel {
    var dogName: String = ""
    var scores: [String: Int] = [:]
    var expandedDimensionId: String?
    var showResults: Bool = false
    var sessionSaved: Bool = false

    var hasValidName: Bool {
        !dogName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var allDimensionsScored: Bool {
        guard let config = currentConfig else { return false }
        return scores.count == config.dimensions.count
    }

    var isComplete: Bool {
        hasValidName && allDimensionsScored
    }

    var totalScore: Int {
        scores.values.reduce(0, +)
    }

    private var currentConfig: RubricConfig?

    func configure(with rubricConfig: RubricConfig) {
        currentConfig = rubricConfig
        if expandedDimensionId == nil, let first = rubricConfig.dimensions.first {
            expandedDimensionId = first.id
        }
    }

    func setScore(_ score: Int, for dimensionId: String) {
        scores[dimensionId] = score

        guard let config = currentConfig else { return }

        if isComplete {
            withAnimation(.easeInOut(duration: 0.3)) {
                expandedDimensionId = nil
                showResults = true
            }
        } else {
            // Auto-advance to next unscored dimension
            if let currentIndex = config.dimensions.firstIndex(where: { $0.id == dimensionId }) {
                let remaining = config.dimensions[(currentIndex + 1)...]
                if let next = remaining.first(where: { scores[$0.id] == nil }) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        expandedDimensionId = next.id
                    }
                } else if let next = config.dimensions.first(where: { scores[$0.id] == nil }) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        expandedDimensionId = next.id
                    }
                }
            }
        }
    }

    func toggleDimension(_ dimensionId: String) {
        withAnimation(.easeInOut(duration: 0.2)) {
            if expandedDimensionId == dimensionId {
                expandedDimensionId = nil
            } else {
                expandedDimensionId = dimensionId
            }
        }
    }

    func grade(using thresholds: [String: GradeThreshold]) -> (grade: String, label: String) {
        GradeCalculator.grade(for: totalScore, using: thresholds)
    }

    func priorityGaps(using config: RubricConfig) -> [RubricDimension] {
        config.dimensions
            .filter { dim in (scores[dim.id] ?? 0) < dim.max }
            .sorted { (scores[$0.id] ?? 0) < (scores[$1.id] ?? 0) }
            .prefix(3)
            .map { $0 }
    }

    func saveSession(config: RubricConfig, modelContext: ModelContext) {
        guard isComplete, !sessionSaved else { return }

        let gradeResult = grade(using: config.gradeThresholds)

        let dog = Dog(name: dogName.isEmpty ? "Unknown" : dogName)
        modelContext.insert(dog)

        let session = ScoringSession(
            totalScore: totalScore,
            maxScore: config.maxScore,
            grade: gradeResult.grade,
            gradeLabel: gradeResult.label,
            rubricVersion: config.version
        )
        session.dog = dog
        modelContext.insert(session)

        for dimension in config.dimensions {
            let dimScore = DimensionScore(
                dimensionId: dimension.id,
                score: scores[dimension.id] ?? 0,
                maxScore: dimension.max
            )
            dimScore.session = session
            modelContext.insert(dimScore)
        }

        sessionSaved = true
    }

    func reset() {
        dogName = ""
        scores = [:]
        expandedDimensionId = nil
        showResults = false
        sessionSaved = false
    }
}
