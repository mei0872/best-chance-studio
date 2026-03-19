import SwiftUI

struct GapsListView: View {
    let gaps: [RubricDimension]
    let scores: [String: Int]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Priority Gaps")
                .font(.title3.bold())
                .foregroundStyle(.primary)

            if gaps.isEmpty {
                Text("No gaps — perfect score!")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(gaps) { dim in
                    let score = scores[dim.id] ?? 0
                    let scoreKey = "score_\(score)"
                    let actions = dim.coachingActions[scoreKey] ?? []

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(dim.label)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Spacer()
                            Text("\(score)/\(dim.max)")
                                .font(.subheadline.bold())
                                .foregroundStyle(Color.scoreColor(for: score))
                        }

                        if let desc = dim.scores[String(score)] {
                            Text(desc)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        ForEach(actions, id: \.self) { action in
                            CoachingActionRow(action: action)
                        }
                    }
                    .padding()
                    .background(Color.scoreColor(for: score).opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
    }
}
