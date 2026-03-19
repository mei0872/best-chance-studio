import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ScorerFlowView()
                .tabItem {
                    Label("Score", systemImage: "star.fill")
                }

            DogHistoryListView()
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }

            RubricReferenceView()
                .tabItem {
                    Label("Rubric", systemImage: "book.fill")
                }
        }
        .tint(.bcsOrange)
    }
}

#Preview {
    ContentView()
        .environment(RubricLoader.load())
        .modelContainer(for: [Dog.self, ScoringSession.self, DimensionScore.self], inMemory: true)
}
