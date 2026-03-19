import Foundation
import SwiftData

@Model
final class DimensionScore {
    var session: ScoringSession?
    var dimensionId: String
    var score: Int
    var maxScore: Int

    init(dimensionId: String, score: Int, maxScore: Int) {
        self.dimensionId = dimensionId
        self.score = score
        self.maxScore = maxScore
    }
}
