package org.bestchancestudio.app

import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.contentOrNull
import kotlinx.serialization.json.int
import kotlinx.serialization.json.jsonArray
import kotlinx.serialization.json.jsonObject
import kotlinx.serialization.json.jsonPrimitive
import org.bestchancestudio.app.models.GradeThreshold
import org.bestchancestudio.app.models.RubricConfig
import org.bestchancestudio.app.models.RubricDimension
import org.bestchancestudio.app.repositories.ExportRepository
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test

class ExportRepositoryTest {

    private lateinit var config: RubricConfig
    private lateinit var exportRepository: ExportRepository

    @Before
    fun setUp() {
        config = RubricConfig(
            version = "1.0.0-test",
            maxScore = 4,
            dimensions = listOf(
                RubricDimension(
                    id = "dim_a", label = "Dimension A", description = "First",
                    max = 2, weight = 1.0,
                    scores = mapOf("2" to "Good", "1" to "OK", "0" to "Bad"),
                    coachingActions = mapOf("score_0" to listOf("Fix A"), "score_1" to listOf("Improve A"), "score_2" to emptyList())
                ),
                RubricDimension(
                    id = "dim_b", label = "Dimension B", description = "Second",
                    max = 2, weight = 1.0,
                    scores = mapOf("2" to "Good", "1" to "OK", "0" to "Bad"),
                    coachingActions = mapOf("score_0" to listOf("Fix B"), "score_1" to listOf("Improve B"), "score_2" to emptyList())
                )
            ),
            gradeThresholds = mapOf(
                "A+" to GradeThreshold(min = 4, max = 4, label = "Perfect"),
                "D" to GradeThreshold(min = 0, max = 1, label = "Needs work")
            )
        )
        // ExportRepository needs context for file writing, but we can test JSON/CSV building
        // by using the methods that don't need context
        exportRepository = ExportRepository(null as android.content.Context?)
    }

    @Test
    fun testBuildJSONProducesValidData() {
        val scores = mapOf("dim_a" to 2, "dim_b" to 1)
        val jsonStr = exportRepository.buildJSON("Moose", scores, 3, "B", "Good", config)

        val json = Json.parseToJsonElement(jsonStr).jsonObject

        assertEquals("Moose", json["dog_name"]?.jsonPrimitive?.contentOrNull)
        assertEquals(3, json["total_score"]?.jsonPrimitive?.int)
        assertEquals(4, json["max_score"]?.jsonPrimitive?.int)
        assertEquals("B", json["grade"]?.jsonPrimitive?.contentOrNull)
        assertEquals("1.0.0-test", json["rubric_version"]?.jsonPrimitive?.contentOrNull)
        assertNotNull(json["scored_at"])
        assertEquals(2, json["dimensions"]?.jsonArray?.size)

        val gaps = json["priority_gaps"]?.jsonArray
        assertNotNull(gaps)
        assertTrue(gaps!!.any { it.jsonPrimitive.contentOrNull == "dim_b" })
    }

    @Test
    fun testBuildJSONUsesUnknownForEmptyName() {
        val jsonStr = exportRepository.buildJSON("", mapOf("dim_a" to 0, "dim_b" to 0), 0, "D", "Needs work", config)
        val json = Json.parseToJsonElement(jsonStr).jsonObject
        assertEquals("Unknown", json["dog_name"]?.jsonPrimitive?.contentOrNull)
    }

    @Test
    fun testBuildCSVContainsHeaderRow() {
        val csv = exportRepository.buildCSV("Biscuit", mapOf("dim_a" to 2, "dim_b" to 1), 3, "B", config)
        val lines = csv.split("\n")
        assertEquals("Dimension,Score,Max,Gap", lines.first())
    }

    @Test
    fun testBuildCSVContainsSummary() {
        val csv = exportRepository.buildCSV("Biscuit", mapOf("dim_a" to 1, "dim_b" to 1), 2, "C", config)
        assertTrue(csv.contains("Dog Name,Biscuit"))
        assertTrue(csv.contains("Total Score,2/4"))
        assertTrue(csv.contains("Grade,C"))
    }
}
