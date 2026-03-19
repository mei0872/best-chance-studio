import SwiftUI

struct RubricReferenceView: View {
    @Environment(\.rubricConfig) private var config

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Grade threshold bar
                    GradeThresholdBarView(thresholds: config.gradeThresholds)
                        .padding(.horizontal)
                        .padding(.top)

                    // Version info
                    Text("Rubric v\(config.version) · 9 dimensions · max \(config.maxScore)")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    // Dimension cards
                    ForEach(Array(config.dimensions.enumerated()), id: \.element.id) { index, dimension in
                        RubricDimensionCardView(dimension: dimension, index: index)
                            .padding(.horizontal)
                    }
                }
                .padding(.bottom, 32)
            }
            .background(Color.bcsCream)
            .navigationTitle("Rubric Reference")
        }
    }
}

#Preview {
    RubricReferenceView()
        .environment(RubricLoader.load())
}
