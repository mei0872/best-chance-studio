import XCTest
@testable import BestChanceStudio

final class GradeCalculatorTests: XCTestCase {

    private let thresholds: [String: GradeThreshold] = [
        "A+": GradeThreshold(min: 16, max: 18, label: "Outstanding. This dog is ready."),
        "A": GradeThreshold(min: 12, max: 15, label: "Strong. Minor gaps to close."),
        "B": GradeThreshold(min: 8, max: 11, label: "Good foundation. Key gaps remain."),
        "C": GradeThreshold(min: 5, max: 7, label: "Significant gaps. Needs coaching."),
        "D": GradeThreshold(min: 0, max: 4, label: "Start over. This dog is invisible.")
    ]

    // MARK: - Grade Boundaries

    func testGradeAPlusAtMaxScore() {
        let result = GradeCalculator.grade(for: 18, using: thresholds)
        XCTAssertEqual(result.grade, "A+")
    }

    func testGradeAPlusAtMinBoundary() {
        let result = GradeCalculator.grade(for: 16, using: thresholds)
        XCTAssertEqual(result.grade, "A+")
    }

    func testGradeAAtMaxBoundary() {
        let result = GradeCalculator.grade(for: 15, using: thresholds)
        XCTAssertEqual(result.grade, "A")
    }

    func testGradeAAtMinBoundary() {
        let result = GradeCalculator.grade(for: 12, using: thresholds)
        XCTAssertEqual(result.grade, "A")
    }

    func testGradeBAtMaxBoundary() {
        let result = GradeCalculator.grade(for: 11, using: thresholds)
        XCTAssertEqual(result.grade, "B")
    }

    func testGradeBAtMinBoundary() {
        let result = GradeCalculator.grade(for: 8, using: thresholds)
        XCTAssertEqual(result.grade, "B")
    }

    func testGradeCAtMaxBoundary() {
        let result = GradeCalculator.grade(for: 7, using: thresholds)
        XCTAssertEqual(result.grade, "C")
    }

    func testGradeCAtMinBoundary() {
        let result = GradeCalculator.grade(for: 5, using: thresholds)
        XCTAssertEqual(result.grade, "C")
    }

    func testGradeDAtMaxBoundary() {
        let result = GradeCalculator.grade(for: 4, using: thresholds)
        XCTAssertEqual(result.grade, "D")
    }

    func testGradeDAtZero() {
        let result = GradeCalculator.grade(for: 0, using: thresholds)
        XCTAssertEqual(result.grade, "D")
    }

    // MARK: - Labels

    func testGradeLabelReturned() {
        let result = GradeCalculator.grade(for: 3, using: thresholds)
        XCTAssertEqual(result.label, "Start over. This dog is invisible.")
    }

    func testGradeAPlusLabel() {
        let result = GradeCalculator.grade(for: 17, using: thresholds)
        XCTAssertEqual(result.label, "Outstanding. This dog is ready.")
    }

    // MARK: - Known Score Examples (from bcs-example.md)

    func testMooseBeforeScore() {
        // Moose scored 3/18 = Grade D
        let result = GradeCalculator.grade(for: 3, using: thresholds)
        XCTAssertEqual(result.grade, "D")
    }

    func testMooseAfterScore() {
        // Moose improved to 14/18 = Grade A
        let result = GradeCalculator.grade(for: 14, using: thresholds)
        XCTAssertEqual(result.grade, "A")
    }

    // MARK: - Grade Colors

    func testAPlusColorIsGreen() {
        let colorInfo = GradeCalculator.gradeColor(for: "A+")
        XCTAssertEqual(colorInfo.background, .bcsGreen)
    }

    func testAColorIsGreen() {
        let colorInfo = GradeCalculator.gradeColor(for: "A")
        XCTAssertEqual(colorInfo.background, .bcsGreen)
    }

    func testBColorIsGold() {
        let colorInfo = GradeCalculator.gradeColor(for: "B")
        XCTAssertEqual(colorInfo.background, .bcsGold)
    }

    func testCColorIsOrange() {
        let colorInfo = GradeCalculator.gradeColor(for: "C")
        XCTAssertEqual(colorInfo.background, .bcsOrange)
    }

    func testDColorIsRed() {
        let colorInfo = GradeCalculator.gradeColor(for: "D")
        XCTAssertEqual(colorInfo.background, .bcsRed)
    }

    // MARK: - Edge Cases

    func testEmptyThresholdsDefaultsToD() {
        let result = GradeCalculator.grade(for: 18, using: [:])
        XCTAssertEqual(result.grade, "D")
    }

    func testGradeOrderIsConsistent() {
        XCTAssertEqual(GradeCalculator.gradeOrder, ["A+", "A", "B", "C", "D"])
    }
}
