import SwiftUI

struct GradeBadgeView: View {
    let grade: String
    var size: BadgeSize = .regular

    enum BadgeSize {
        case small, regular, large

        var font: Font {
            switch self {
            case .small: return .caption.bold()
            case .regular: return .body.bold()
            case .large: return .title.bold()
            }
        }

        var padding: EdgeInsets {
            switch self {
            case .small: return EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6)
            case .regular: return EdgeInsets(top: 4, leading: 10, bottom: 4, trailing: 10)
            case .large: return EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
            }
        }
    }

    var body: some View {
        let colors = GradeCalculator.gradeColor(for: grade)
        Text(grade)
            .font(size.font)
            .foregroundStyle(colors.foreground)
            .padding(size.padding)
            .background(colors.background, in: Capsule())
    }
}

#Preview {
    HStack(spacing: 12) {
        GradeBadgeView(grade: "A+", size: .small)
        GradeBadgeView(grade: "A")
        GradeBadgeView(grade: "B")
        GradeBadgeView(grade: "C")
        GradeBadgeView(grade: "D", size: .large)
    }
}
