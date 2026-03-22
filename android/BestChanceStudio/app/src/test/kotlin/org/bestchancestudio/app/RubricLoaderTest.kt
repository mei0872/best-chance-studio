package org.bestchancestudio.app

import kotlinx.serialization.json.Json
import org.bestchancestudio.app.models.RubricConfig
import org.junit.Assert.assertEquals
import org.junit.Assert.assertThrows
import org.junit.Test

class RubricLoaderTest {

    private val json = Json { ignoreUnknownKeys = true }

    @Test
    fun testLoadFromValidJSON() {
        val jsonString = """
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
                    "scores": {"2": "Perfect", "1": "Okay", "0": "Missing"},
                    "coaching_actions": {"score_0": ["Action for zero"], "score_1": ["Action for one"], "score_2": []}
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
        """.trimIndent()

        val config = json.decodeFromString<RubricConfig>(jsonString)

        assertEquals("1.0.0", config.version)
        assertEquals(18, config.maxScore)
        assertEquals(1, config.dimensions.size)
        assertEquals("test_dim", config.dimensions.first().id)
        assertEquals("Test Dimension", config.dimensions.first().label)
        assertEquals(2, config.dimensions.first().max)
        assertEquals("Perfect", config.dimensions.first().scores["2"])
        assertEquals(1, config.dimensions.first().coachingActions["score_0"]?.size)
        assertEquals(5, config.gradeThresholds.size)
    }

    @Test
    fun testLoadFailsOnInvalidJSON() {
        assertThrows(Exception::class.java) {
            json.decodeFromString<RubricConfig>("not json")
        }
    }

    @Test
    fun testLoadFailsOnMissingFields() {
        assertThrows(Exception::class.java) {
            json.decodeFromString<RubricConfig>("""{"version": "1.0.0"}""")
        }
    }

    @Test
    fun testSnakeCaseMapping() {
        val jsonString = """
        {
            "version": "1.0.0",
            "max_score": 18,
            "dimensions": [{
                "id": "test", "label": "Test", "description": "Desc",
                "max": 2, "weight": 1.0,
                "scores": {"2": "Good", "1": "OK", "0": "Bad"},
                "coaching_actions": {"score_0": ["Fix it"]}
            }],
            "grade_thresholds": {"A+": {"min": 16, "max": 18, "label": "Great"}}
        }
        """.trimIndent()

        val config = json.decodeFromString<RubricConfig>(jsonString)
        assertEquals(18, config.maxScore)
        assertEquals("Fix it", config.dimensions.first().coachingActions["score_0"]?.first())
    }
}
