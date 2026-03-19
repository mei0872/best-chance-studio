import Foundation
import SwiftData

@Model
final class Dog {
    var name: String
    var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \ScoringSession.dog)
    var sessions: [ScoringSession]

    init(name: String) {
        self.name = name
        self.createdAt = Date()
        self.sessions = []
    }

    var latestSession: ScoringSession? {
        sessions.sorted { $0.scoredAt > $1.scoredAt }.first
    }
}
