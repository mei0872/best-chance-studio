import SwiftUI

struct RubricDimensionCardView: View {
    let dimension: RubricDimension
    let index: Int
    @State private var isExpanded = false

    var body: some View {
        VStack(spacing: 0) {
            // Header
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Text("\(index + 1)")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .frame(width: 24, height: 24)
                        .background(Color.bcsOrange, in: Circle())

                    Text(dimension.label)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Spacer()

                    Text("0–\(dimension.max)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
            }
            .buttonStyle(.plain)

            // Expanded content
            if isExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    Text(dimension.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    // Score levels
                    ForEach([2, 1, 0], id: \.self) { score in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("\(score)")
                                    .font(.subheadline.bold())
                                    .foregroundStyle(.white)
                                    .frame(width: 22, height: 22)
                                    .background(Color.scoreColor(for: score), in: Circle())

                                Text(dimension.scores[String(score)] ?? "")
                                    .font(.subheadline)
                                    .foregroundStyle(.primary)
                            }

                            // Coaching actions for this score level
                            let scoreKey = "score_\(score)"
                            let actions = dimension.coachingActions[scoreKey] ?? []
                            if !actions.isEmpty {
                                VStack(alignment: .leading, spacing: 4) {
                                    ForEach(actions, id: \.self) { action in
                                        CoachingActionRow(action: action)
                                    }
                                }
                                .padding(.leading, 30)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color.bcsCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }
}
