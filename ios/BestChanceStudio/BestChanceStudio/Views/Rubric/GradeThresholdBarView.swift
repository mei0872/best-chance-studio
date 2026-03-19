import SwiftUI

struct GradeThresholdBarView: View {
    let thresholds: [String: GradeThreshold]

    private let gradeOrder = ["A+", "A", "B", "C", "D"]

    var body: some View {
        HStack(spacing: 6) {
            ForEach(gradeOrder, id: \.self) { grade in
                if let threshold = thresholds[grade] {
                    let colors = GradeCalculator.gradeColor(for: grade)
                    VStack(spacing: 2) {
                        Text(grade)
                            .font(.caption.bold())
                            .foregroundStyle(colors.foreground)
                        Text("\(threshold.min)–\(threshold.max)")
                            .font(.caption2)
                            .foregroundStyle(colors.foreground.opacity(0.8))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .background(colors.background, in: RoundedRectangle(cornerRadius: 6))
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Grade thresholds: A+ 16 to 18, A 12 to 15, B 8 to 11, C 5 to 7, D 0 to 4")
    }
}

#Preview {
    GradeThresholdBarView(thresholds: [
        "A+": GradeThreshold(min: 16, max: 18, label: ""),
        "A": GradeThreshold(min: 12, max: 15, label: ""),
        "B": GradeThreshold(min: 8, max: 11, label: ""),
        "C": GradeThreshold(min: 5, max: 7, label: ""),
        "D": GradeThreshold(min: 0, max: 4, label: "")
    ])
    .padding()
}
