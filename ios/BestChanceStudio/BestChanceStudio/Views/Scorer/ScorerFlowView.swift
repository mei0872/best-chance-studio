import SwiftUI
import SwiftData

struct ScorerFlowView: View {
    @Environment(\.rubricConfig) private var config
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = ScorerViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.showResults {
                    resultsView
                } else {
                    scoringView
                }
            }
            .navigationTitle("BCS Scorer")
            .toolbar {
                if viewModel.showResults {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("New Score") {
                            viewModel.reset()
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.configure(with: config)
        }
    }

    private var scoringView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 16) {
                    // Dog name input
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Dog's Name")
                            .font(.subheadline.bold())
                            .foregroundStyle(.secondary)
                        TextField("Enter dog's name", text: $viewModel.dogName)
                            .textFieldStyle(.roundedBorder)
                            .font(.body)
                            .accessibilityLabel("Dog's name")
                    }
                    .padding(.horizontal)
                    .padding(.top)

                    // Progress
                    let scored = viewModel.scores.count
                    let total = config.dimensions.count
                    if total > 0 {
                        HStack {
                            Text("\(scored)/\(total) dimensions scored")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                            if scored > 0 && scored < total {
                                Button("Expand All") {
                                    // Toggle — if something is expanded, collapse; otherwise expand first unscored
                                    if viewModel.expandedDimensionId != nil {
                                        viewModel.expandedDimensionId = nil
                                    } else if let next = config.dimensions.first(where: { viewModel.scores[$0.id] == nil }) {
                                        viewModel.expandedDimensionId = next.id
                                    }
                                }
                                .font(.subheadline)
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Dimension cards
                    ForEach(Array(config.dimensions.enumerated()), id: \.element.id) { index, dimension in
                        DimensionCardView(
                            dimension: dimension,
                            index: index,
                            currentScore: viewModel.scores[dimension.id],
                            isExpanded: viewModel.expandedDimensionId == dimension.id,
                            onScoreSelected: { score in
                                viewModel.setScore(score, for: dimension.id)
                                // Scroll to next expanded card after a short delay
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    if let nextId = viewModel.expandedDimensionId {
                                        withAnimation {
                                            proxy.scrollTo(nextId, anchor: .top)
                                        }
                                    }
                                }
                            },
                            onToggle: {
                                viewModel.toggleDimension(dimension.id)
                            }
                        )
                        .id(dimension.id)
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 32)
            }
            .background(Color.bcsCream)
        }
    }

    private var resultsView: some View {
        let gradeResult = viewModel.grade(using: config.gradeThresholds)
        return ResultsView(
            dogName: viewModel.dogName,
            scores: viewModel.scores,
            totalScore: viewModel.totalScore,
            grade: gradeResult.grade,
            gradeLabel: gradeResult.label
        )
        .background(Color.bcsCream)
        .onAppear {
            viewModel.saveSession(config: config, modelContext: modelContext)
        }
    }
}

#Preview {
    ScorerFlowView()
        .environment(RubricLoader.load())
        .modelContainer(for: [Dog.self, ScoringSession.self, DimensionScore.self], inMemory: true)
}
