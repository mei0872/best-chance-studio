import Foundation

struct GradeCalculator {
    static let gradeOrder = ["A+", "A", "B", "C", "D"]

    static func grade(for totalScore: Int, using thresholds: [String: GradeThreshold]) -> (grade: String, label: String) {
        for g in gradeOrder {
            if let t = thresholds[g], totalScore >= t.min, totalScore <= t.max {
                return (g, t.label)
            }
        }
        return ("D", thresholds["D"]?.label ?? "Needs significant improvement.")
    }

    static func gradeColor(for grade: String) -> GradeColorInfo {
        switch grade {
        case "A+", "A":
            return GradeColorInfo(foreground: .white, background: .bcsGreen)
        case "B":
            return GradeColorInfo(foreground: .white, background: .bcsGold)
        case "C":
            return GradeColorInfo(foreground: .white, background: .bcsOrange)
        default:
            return GradeColorInfo(foreground: .white, background: .bcsRed)
        }
    }
}

struct GradeColorInfo {
    let foreground: SwiftUI.Color
    let background: SwiftUI.Color
}

import SwiftUI
