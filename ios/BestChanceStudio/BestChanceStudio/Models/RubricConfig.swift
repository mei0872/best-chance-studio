import SwiftUI

@Observable
final class RubricConfig: Codable {
    let version: String
    let maxScore: Int
    let dimensions: [RubricDimension]
    let gradeThresholds: [String: GradeThreshold]

    enum CodingKeys: String, CodingKey {
        case version
        case maxScore = "max_score"
        case dimensions
        case gradeThresholds = "grade_thresholds"
    }

    init(version: String, maxScore: Int, dimensions: [RubricDimension], gradeThresholds: [String: GradeThreshold]) {
        self.version = version
        self.maxScore = maxScore
        self.dimensions = dimensions
        self.gradeThresholds = gradeThresholds
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decode(String.self, forKey: .version)
        maxScore = try container.decode(Int.self, forKey: .maxScore)
        dimensions = try container.decode([RubricDimension].self, forKey: .dimensions)
        gradeThresholds = try container.decode([String: GradeThreshold].self, forKey: .gradeThresholds)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        try container.encode(maxScore, forKey: .maxScore)
        try container.encode(dimensions, forKey: .dimensions)
        try container.encode(gradeThresholds, forKey: .gradeThresholds)
    }
}

extension RubricConfig: @unchecked Sendable {}

struct RubricDimension: Codable, Identifiable {
    let id: String
    let label: String
    let description: String
    let max: Int
    let weight: Double
    let scores: [String: String]
    let coachingActions: [String: [String]]

    enum CodingKeys: String, CodingKey {
        case id, label, description, max, weight, scores
        case coachingActions = "coaching_actions"
    }
}

struct GradeThreshold: Codable {
    let min: Int
    let max: Int
    let label: String
}

extension EnvironmentValues {
    @Entry var rubricConfig: RubricConfig = RubricConfig(
        version: "0.0.0",
        maxScore: 18,
        dimensions: [],
        gradeThresholds: [:]
    )
}

extension View {
    func environment(_ rubricConfig: RubricConfig) -> some View {
        self.environment(\.rubricConfig, rubricConfig)
    }
}
