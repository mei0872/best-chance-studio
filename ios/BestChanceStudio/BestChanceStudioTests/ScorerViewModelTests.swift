import XCTest
@testable import BestChanceStudio

final class ScorerViewModelTests: XCTestCase {

    private var viewModel: ScorerViewModel!
    private var config: RubricConfig!

    override func setUp() {
        super.setUp()
        viewModel = ScorerViewModel()

        // Create a minimal test config with 3 dimensions
        config = RubricConfig(
            version: "1.0.0-test",
            maxScore: 6,
            dimensions: [
                RubricDimension(
                    id: "dim_1", label: "Dimension 1", description: "First",
                    max: 2, weight: 1.0,
                    scores: ["2": "Good", "1": "OK", "0": "Bad"],
                    coachingActions: ["score_0": ["Fix dim 1"], "score_1": ["Improve dim 1"], "score_2": []]
                ),
                RubricDimension(
                    id: "dim_2", label: "Dimension 2", description: "Second",
                    max: 2, weight: 1.0,
                    scores: ["2": "Good", "1": "OK", "0": "Bad"],
                    coachingActions: ["score_0": ["Fix dim 2"], "score_1": ["Improve dim 2"], "score_2": []]
                ),
                RubricDimension(
                    id: "dim_3", label: "Dimension 3", description: "Third",
                    max: 2, weight: 1.0,
                    scores: ["2": "Good", "1": "OK", "0": "Bad"],
                    coachingActions: ["score_0": ["Fix dim 3"], "score_1": ["Improve dim 3"], "score_2": []]
                )
            ],
            gradeThresholds: [
                "A+": GradeThreshold(min: 5, max: 6, label: "Outstanding"),
                "A": GradeThreshold(min: 4, max: 4, label: "Strong"),
                "B": GradeThreshold(min: 3, max: 3, label: "Good"),
                "C": GradeThreshold(min: 2, max: 2, label: "Fair"),
                "D": GradeThreshold(min: 0, max: 1, label: "Needs work")
            ]
        )
        viewModel.configure(with: config)
    }

    override func tearDown() {
        viewModel = nil
        config = nil
        super.tearDown()
    }

    // MARK: - Initial State

    func testInitialStateIsEmpty() {
        XCTAssertEqual(viewModel.dogName, "")
        XCTAssertTrue(viewModel.scores.isEmpty)
        XCTAssertFalse(viewModel.isComplete)
        XCTAssertFalse(viewModel.showResults)
        XCTAssertEqual(viewModel.totalScore, 0)
    }

    func testFirstDimensionExpandedOnConfigure() {
        XCTAssertEqual(viewModel.expandedDimensionId, "dim_1")
    }

    // MARK: - Scoring

    func testSetScoreRecordsValue() {
        viewModel.setScore(2, for: "dim_1")
        XCTAssertEqual(viewModel.scores["dim_1"], 2)
    }

    func testTotalScoreSumsAllDimensions() {
        viewModel.setScore(2, for: "dim_1")
        viewModel.setScore(1, for: "dim_2")
        viewModel.setScore(0, for: "dim_3")
        XCTAssertEqual(viewModel.totalScore, 3)
    }

    func testIsCompleteWhenAllDimensionsScored() {
        viewModel.setScore(1, for: "dim_1")
        viewModel.setScore(1, for: "dim_2")
        XCTAssertFalse(viewModel.isComplete)

        viewModel.setScore(1, for: "dim_3")
        XCTAssertTrue(viewModel.isComplete)
    }

    func testShowResultsWhenComplete() {
        viewModel.setScore(2, for: "dim_1")
        viewModel.setScore(2, for: "dim_2")
        viewModel.setScore(2, for: "dim_3")
        XCTAssertTrue(viewModel.showResults)
    }

    // MARK: - Auto-Advance

    func testAutoAdvancesToNextUnscoredDimension() {
        viewModel.setScore(2, for: "dim_1")
        XCTAssertEqual(viewModel.expandedDimensionId, "dim_2")
    }

    func testAutoAdvanceSkipsScoredDimensions() {
        viewModel.setScore(2, for: "dim_2") // Score dim_2 first (out of order)
        viewModel.setScore(1, for: "dim_1") // Score dim_1 — should skip dim_2, go to dim_3
        XCTAssertEqual(viewModel.expandedDimensionId, "dim_3")
    }

    // MARK: - Toggle

    func testToggleDimensionCollapsesExpanded() {
        viewModel.toggleDimension("dim_1")
        XCTAssertNil(viewModel.expandedDimensionId)
    }

    func testToggleDimensionExpandsNew() {
        viewModel.toggleDimension("dim_2")
        XCTAssertEqual(viewModel.expandedDimensionId, "dim_2")
    }

    // MARK: - Grade

    func testGradeCalculation() {
        viewModel.setScore(2, for: "dim_1")
        viewModel.setScore(2, for: "dim_2")
        viewModel.setScore(2, for: "dim_3")
        let result = viewModel.grade(using: config.gradeThresholds)
        XCTAssertEqual(result.grade, "A+")
    }

    func testGradeCalculationLowScore() {
        viewModel.setScore(0, for: "dim_1")
        viewModel.setScore(0, for: "dim_2")
        viewModel.setScore(1, for: "dim_3")
        let result = viewModel.grade(using: config.gradeThresholds)
        XCTAssertEqual(result.grade, "D")
    }

    // MARK: - Priority Gaps

    func testPriorityGapsReturnsLowestScored() {
        viewModel.setScore(2, for: "dim_1")
        viewModel.setScore(0, for: "dim_2")
        viewModel.setScore(1, for: "dim_3")

        let gaps = viewModel.priorityGaps(using: config)
        XCTAssertEqual(gaps.count, 2) // dim_2 (0) and dim_3 (1) are gaps
        XCTAssertEqual(gaps.first?.id, "dim_2") // lowest score first
    }

    func testPriorityGapsMaxThree() {
        // All scored at 0 — 3 gaps, all returned
        viewModel.setScore(0, for: "dim_1")
        viewModel.setScore(0, for: "dim_2")
        viewModel.setScore(0, for: "dim_3")
        let gaps = viewModel.priorityGaps(using: config)
        XCTAssertEqual(gaps.count, 3)
    }

    func testNoPriorityGapsWhenPerfect() {
        viewModel.setScore(2, for: "dim_1")
        viewModel.setScore(2, for: "dim_2")
        viewModel.setScore(2, for: "dim_3")
        let gaps = viewModel.priorityGaps(using: config)
        XCTAssertTrue(gaps.isEmpty)
    }

    // MARK: - Reset

    func testResetClearsAllState() {
        viewModel.dogName = "Moose"
        viewModel.setScore(2, for: "dim_1")
        viewModel.setScore(2, for: "dim_2")
        viewModel.setScore(2, for: "dim_3")

        viewModel.reset()

        XCTAssertEqual(viewModel.dogName, "")
        XCTAssertTrue(viewModel.scores.isEmpty)
        XCTAssertFalse(viewModel.showResults)
        XCTAssertFalse(viewModel.isComplete)
        XCTAssertEqual(viewModel.totalScore, 0)
    }
}
