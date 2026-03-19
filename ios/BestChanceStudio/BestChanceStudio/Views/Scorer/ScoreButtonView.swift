import SwiftUI

struct ScoreButtonView: View {
    let score: Int
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("\(score)")
                        .font(.headline.bold())
                        .foregroundStyle(.white)
                        .frame(width: 28, height: 28)
                        .background(isSelected ? Color.scoreColor(for: score) : Color.gray.opacity(0.3), in: Circle())

                    Spacer()

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color.scoreColor(for: score))
                    }
                }

                Text(label)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color.scoreColor(for: score).opacity(0.1) : Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(isSelected ? Color.scoreColor(for: score) : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Score \(score): \(label)")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    VStack(spacing: 8) {
        ScoreButtonView(score: 2, label: "Specific, memorable, only-this-dog moment", isSelected: true) {}
        ScoreButtonView(score: 1, label: "Some personality shown but generic", isSelected: false) {}
        ScoreButtonView(score: 0, label: "No personality visible", isSelected: false) {}
    }
    .padding()
}
