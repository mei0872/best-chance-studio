import SwiftUI

extension Color {
    // Brand colors — used for accents, badges, buttons
    static let bcsOrange = Color(red: 0xF4 / 255, green: 0x62 / 255, blue: 0x2A / 255)
    static let bcsGold = Color(red: 0xF9 / 255, green: 0xA8 / 255, blue: 0x26 / 255)
    static let bcsDark = Color(red: 0x1E / 255, green: 0x1E / 255, blue: 0x2E / 255)
    static let bcsGreen = Color(red: 0x16 / 255, green: 0xA3 / 255, blue: 0x4A / 255)
    static let bcsRed = Color(red: 0xDC / 255, green: 0x26 / 255, blue: 0x26 / 255)

    // Semantic backgrounds — uses Apple's system palette for guaranteed readability
    static let bcsPageBackground = Color(.systemGroupedBackground)
    static let bcsCardBackground = Color(.secondarySystemGroupedBackground)

    static func scoreColor(for score: Int) -> Color {
        switch score {
        case 2: return .bcsGreen
        case 1: return .bcsGold
        default: return .bcsRed
        }
    }
}
