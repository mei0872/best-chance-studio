import Foundation
import SwiftData

@Model
final class ScoringSession {
    var dog: Dog?
    var scoredAt: Date
    var totalScore: Int
    var maxScore: Int
    var grade: String
    var gradeLabel: String
    var rubricVersion: String

    @Relationship(deleteRule: .cascade, inverse: \DimensionScore.session)
    var dimensionScores: [DimensionScore]

    init(totalScore: Int, maxScore: Int, grade: String, gradeLabel: String, rubricVersion: String) {
        self.scoredAt = Date()
        self.totalScore = totalScore
        self.maxScore = maxScore
        self.grade = grade
        self.gradeLabel = gradeLabel
        self.rubricVersion = rubricVersion
        self.dimensionScores = []
    }

    var sortedDimensionScores: [DimensionScore] {
        dimensionScores.sorted { $0.dimensionId < $1.dimensionId }
    }

    var priorityGaps: [DimensionScore] {
        dimensionScores
            .filter { $0.score < $0.maxScore }
            .sorted { $0.score < $1.score }
            .prefix(3)
            .map { $0 }
    }
}
