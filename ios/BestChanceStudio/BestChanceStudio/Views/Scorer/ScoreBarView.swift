import SwiftUI

struct ScoreBarView: View {
    let label: String
    let score: Int
    let maxScore: Int

    var body: some View {
        HStack(spacing: 12) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(Color.bcsText)
                .frame(width: 140, alignment: .leading)
                .lineLimit(1)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray5))

                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.scoreColor(for: score))
                        .frame(width: maxScore > 0 ? geo.size.width * CGFloat(score) / CGFloat(maxScore) : 0)
                }
            }
            .frame(height: 8)

            Text("\(score)/\(maxScore)")
                .font(.subheadline.monospacedDigit())
                .foregroundStyle(Color.bcsText.opacity(0.6))
                .frame(width: 30, alignment: .trailing)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label): \(score) out of \(maxScore)")
    }
}

#Preview {
    VStack(spacing: 8) {
        ScoreBarView(label: "Personality Hook", score: 2, maxScore: 2)
        ScoreBarView(label: "Visual Impact", score: 1, maxScore: 2)
        ScoreBarView(label: "Video Presence", score: 0, maxScore: 2)
    }
    .padding()
}
