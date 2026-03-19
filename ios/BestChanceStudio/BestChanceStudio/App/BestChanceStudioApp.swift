import SwiftUI
import SwiftData

@main
struct BestChanceStudioApp: App {
    let rubricConfig: RubricConfig

    init() {
        rubricConfig = RubricLoader.load()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(rubricConfig)
        }
        .modelContainer(for: [Dog.self, ScoringSession.self, DimensionScore.self])
    }
}
