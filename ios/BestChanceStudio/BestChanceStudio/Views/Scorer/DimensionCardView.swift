import SwiftUI

struct DimensionCardView: View {
    let dimension: RubricDimension
    let index: Int
    let currentScore: Int?
    let isExpanded: Bool
    let onScoreSelected: (Int) -> Void
    let onToggle: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Header
            Button(action: onToggle) {
                HStack {
                    Text("\(index + 1)")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .frame(width: 24, height: 24)
                        .background(headerColor, in: Circle())

                    Text(dimension.label)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Spacer()

                    if let score = currentScore {
                        Text("\(score)/\(dimension.max)")
                            .font(.subheadline.bold())
                            .foregroundStyle(Color.scoreColor(for: score))
                    }

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
            }
            .buttonStyle(.plain)
            .accessibilityLabel("\(dimension.label), \(currentScore.map { "scored \($0) of \(dimension.max)" } ?? "not scored")")

            // Expanded content
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    Text(dimension.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)

                    // Score buttons (2, 1, 0 — highest first)
                    ForEach([2, 1, 0], id: \.self) { score in
                        ScoreButtonView(
                            score: score,
                            label: dimension.scores[String(score)] ?? "",
                            isSelected: currentScore == score,
                            action: { onScoreSelected(score) }
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }

    private var headerColor: Color {
        if let score = currentScore {
            return Color.scoreColor(for: score)
        }
        return .gray
    }
}
