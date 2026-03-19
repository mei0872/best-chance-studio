import XCTest
@testable import BestChanceStudio

final class ExportBuilderTests: XCTestCase {

    private var config: RubricConfig!

    override func setUp() {
        super.setUp()
        config = RubricConfig(
            version: "1.0.0-test",
            maxScore: 4,
            dimensions: [
                RubricDimension(
                    id: "dim_a", label: "Dimension A", description: "First",
                    max: 2, weight: 1.0,
                    scores: ["2": "Good", "1": "OK", "0": "Bad"],
                    coachingActions: ["score_0": ["Fix A"], "score_1": ["Improve A"], "score_2": []]
                ),
                RubricDimension(
                    id: "dim_b", label: "Dimension B", description: "Second",
                    max: 2, weight: 1.0,
                    scores: ["2": "Good", "1": "OK", "0": "Bad"],
                    coachingActions: ["score_0": ["Fix B"], "score_1": ["Improve B"], "score_2": []]
                )
            ],
            gradeThresholds: [
                "A+": GradeThreshold(min: 4, max: 4, label: "Perfect"),
                "D": GradeThreshold(min: 0, max: 1, label: "Needs work")
            ]
        )
    }

    override func tearDown() {
        config = nil
        super.tearDown()
    }

    // MARK: - JSON Export

    func testBuildJSONProducesValidData() {
        let scores = ["dim_a": 2, "dim_b": 1]
        let data = ExportViewModel.buildJSON(
            dogName: "Moose",
            scores: scores,
            totalScore: 3,
            grade: "B",
            gradeLabel: "Good",
            config: config
        )

        XCTAssertNotNil(data)

        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            XCTFail("Failed to parse JSON output")
            return
        }

        XCTAssertEqual(json["dog_name"] as? String, "Moose")
        XCTAssertEqual(json["total_score"] as? Int, 3)
        XCTAssertEqual(json["max_score"] as? Int, 4)
        XCTAssertEqual(json["grade"] as? String, "B")
        XCTAssertEqual(json["rubric_version"] as? String, "1.0.0-test")
        XCTAssertNotNil(json["scored_at"])

        guard let dimensions = json["dimensions"] as? [[String: Any]] else {
            XCTFail("Missing dimensions array")
            return
        }
        XCTAssertEqual(dimensions.count, 2)

        guard let gaps = json["priority_gaps"] as? [String] else {
            XCTFail("Missing priority_gaps array")
            return
        }
        XCTAssertTrue(gaps.contains("dim_b"))
    }

    func testBuildJSONUsesUnknownForEmptyName() {
        let data = ExportViewModel.buildJSON(
            dogName: "",
            scores: ["dim_a": 0, "dim_b": 0],
            totalScore: 0,
            grade: "D",
            gradeLabel: "Needs work",
            config: config
        )

        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            XCTFail("Failed to parse JSON output")
            return
        }
        XCTAssertEqual(json["dog_name"] as? String, "Unknown")
    }

    // MARK: - CSV Export

    func testBuildCSVContainsHeaderRow() {
        let csv = ExportViewModel.buildCSV(
            dogName: "Biscuit",
            scores: ["dim_a": 2, "dim_b": 1],
            totalScore: 3,
            grade: "B",
            config: config
        )

        let lines = csv.components(separatedBy: "\n")
        XCTAssertEqual(lines.first, "Dimension,Score,Max,Gap")
    }

    func testBuildCSVContainsDimensionRows() {
        let csv = ExportViewModel.buildCSV(
            dogName: "Biscuit",
            scores: ["dim_a": 2, "dim_b": 0],
            totalScore: 2,
            grade: "C",
            config: config
        )

        XCTAssertTrue(csv.contains("Dimension A,2,2,\"\""))
        XCTAssertTrue(csv.contains("Dimension B,0,2,"))
    }

    func testBuildCSVContainsSummary() {
        let csv = ExportViewModel.buildCSV(
            dogName: "Biscuit",
            scores: ["dim_a": 1, "dim_b": 1],
            totalScore: 2,
            grade: "C",
            config: config
        )

        XCTAssertTrue(csv.contains("Dog Name,Biscuit"))
        XCTAssertTrue(csv.contains("Total Score,2/4"))
        XCTAssertTrue(csv.contains("Grade,C"))
    }

    // MARK: - Temp File

    func testWriteTempFileCreatesFile() {
        let content = "test content"
        guard let url = ExportViewModel.writeTempFile(name: "test", extension: "txt", content: content) else {
            XCTFail("Failed to write temp file")
            return
        }

        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))

        // Cleanup
        try? FileManager.default.removeItem(at: url)
    }
}
