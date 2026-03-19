import SwiftUI

struct CoachingActionRow: View {
    let action: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "arrow.right.circle.fill")
                .foregroundStyle(Color.bcsOrange)
                .font(.caption)
                .padding(.top, 3)
            Text(action)
                .font(.subheadline)
                .foregroundStyle(Color.bcsText)
        }
    }
}

#Preview {
    CoachingActionRow(action: "Take a photo showing the dog's unique personality trait")
}
