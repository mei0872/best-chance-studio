import SwiftUI
import SwiftData

struct DogHistoryListView: View {
    @Query(sort: \Dog.createdAt, order: .reverse) private var dogs: [Dog]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.rubricConfig) private var config

    var body: some View {
        NavigationStack {
            Group {
                if dogs.isEmpty {
                    ContentUnavailableView(
                        "No Dogs Scored",
                        systemImage: "pawprint",
                        description: Text("Score a dog in the Score tab to see it here.")
                    )
                } else {
                    List {
                        ForEach(dogs) { dog in
                            NavigationLink {
                                if let session = dog.latestSession {
                                    SessionDetailView(dog: dog, session: session)
                                }
                            } label: {
                                dogRow(dog)
                            }
                        }
                        .onDelete(perform: deleteDogs)
                    }
                }
            }
            .navigationTitle("History")
        }
    }

    private func dogRow(_ dog: Dog) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(dog.name)
                    .font(.headline)
                if let session = dog.latestSession {
                    Text(session.scoredAt, style: .date)
                        .font(.caption)
                        .foregroundStyle(Color.bcsText.opacity(0.6))
                }
            }

            Spacer()

            if let session = dog.latestSession {
                HStack(spacing: 8) {
                    Text("\(session.totalScore)/\(session.maxScore)")
                        .font(.subheadline.monospacedDigit())
                        .foregroundStyle(Color.bcsText.opacity(0.6))
                    GradeBadgeView(grade: session.grade, size: .small)
                }
            }
        }
        .padding(.vertical, 4)
    }

    private func deleteDogs(at offsets: IndexSet) {
        for index in offsets {
            let dog = dogs[index]
            modelContext.delete(dog)
        }
    }
}

#Preview {
    DogHistoryListView()
        .environment(RubricLoader.load())
        .modelContainer(for: [Dog.self, ScoringSession.self, DimensionScore.self], inMemory: true)
}
