import XCTest
@testable import BestChanceStudio

final class RubricLoaderTests: XCTestCase {

    private var testConfig: RubricConfig?

    override func setUp() {
        super.setUp()
        // Load from the bundled rubric-config.json using the safe throwing method
        guard let url = Bundle(for: type(of: self)).url(forResource: "rubric-config", withExtension: "json")
                ?? Bundle.main.url(forResource: "rubric-config", withExtension: "json") else {
            return
        }
        guard let data = try? Data(contentsOf: url) else { return }
        testConfig = try? RubricLoader.load(from: data)
    }

    func testLoadFromValidJSON() throws {
        let json = """
        {
            "version": "1.0.0",
            "max_score": 18,
            "dimensions": [
                {
                    "id": "test_dim",
                    "label": "Test Dimension",
                    "description": "A test dimension",
                    "max": 2,
                    "weight": 1.0,
                    "scores": {
                        "2": "Perfect",
                        "1": "Okay",
                        "0": "Missing"
                    },
                    "coaching_actions": {
                        "score_0": ["Action for zero"],
                        "score_1": ["Action for one"],
                        "score_2": []
                    }
                }
            ],
            "grade_thresholds": {
                "A+": {"min": 16, "max": 18, "label": "Outstanding"},
                "A": {"min": 12, "max": 15, "label": "Strong"},
                "B": {"min": 8, "max": 11, "label": "Good"},
                "C": {"min": 5, "max": 7, "label": "Fair"},
                "D": {"min": 0, "max": 4, "label": "Needs work"}
            }
        }
        """.data(using: .utf8)!

        let config = try RubricLoader.load(from: json)

        XCTAssertEqual(config.version, "1.0.0")
        XCTAssertEqual(config.maxScore, 18)
        XCTAssertEqual(config.dimensions.count, 1)
        XCTAssertEqual(config.dimensions.first?.id, "test_dim")
        XCTAssertEqual(config.dimensions.first?.label, "Test Dimension")
        XCTAssertEqual(config.dimensions.first?.max, 2)
        XCTAssertEqual(config.dimensions.first?.scores["2"], "Perfect")
        XCTAssertEqual(config.dimensions.first?.coachingActions["score_0"]?.count, 1)
        XCTAssertEqual(config.gradeThresholds.count, 5)
    }

    func testLoadFailsOnInvalidJSON() {
        let invalidJSON = "not json".data(using: .utf8)!
        XCTAssertThrowsError(try RubricLoader.load(from: invalidJSON))
    }

    func testLoadFailsOnMissingFields() {
        let incompleteJSON = """
        {
            "version": "1.0.0"
        }
        """.data(using: .utf8)!
        XCTAssertThrowsError(try RubricLoader.load(from: incompleteJSON))
    }

    func testCodingKeysMapSnakeCaseToCamelCase() throws {
        let json = """
        {
            "version": "1.0.0",
            "max_score": 18,
            "dimensions": [{
                "id": "test",
                "label": "Test",
                "description": "Desc",
                "max": 2,
                "weight": 1.0,
                "scores": {"2": "Good", "1": "OK", "0": "Bad"},
                "coaching_actions": {"score_0": ["Fix it"]}
            }],
            "grade_thresholds": {
                "A+": {"min": 16, "max": 18, "label": "Great"}
            }
        }
        """.data(using: .utf8)!

        let config = try RubricLoader.load(from: json)
        XCTAssertEqual(config.maxScore, 18, "max_score should decode to maxScore")
        XCTAssertEqual(config.dimensions.first?.coachingActions["score_0"]?.first, "Fix it",
                       "coaching_actions should decode to coachingActions")
    }
}
