package org.bestchancestudio.app.repositories

import android.content.Context
import androidx.core.content.FileProvider
import android.net.Uri
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonArray
import kotlinx.serialization.json.JsonElement
import kotlinx.serialization.json.JsonNull
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.JsonPrimitive
import org.bestchancestudio.app.models.RubricConfig
import java.io.File
import java.time.Instant
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class ExportRepository @Inject constructor(
    private val context: Context?
) {
    fun buildJSON(
        dogName: String,
        scores: Map<String, Int>,
        totalScore: Int,
        grade: String,
        gradeLabel: String,
        config: RubricConfig
    ): String {
        val name = dogName.ifEmpty { "Unknown" }
        val priorityGapIds = config.dimensions
            .filter { (scores[it.id] ?: 0) < it.max }
            .sortedBy { scores[it.id] ?: 0 }
            .take(3)
            .map { it.id }

        val dimensions = config.dimensions.map { dim ->
            val score = scores[dim.id] ?: 0
            val scoreKey = "score_$score"
            val actions = dim.coachingActions[scoreKey] ?: emptyList()
            val gap = if (score < dim.max) dim.scores[score.toString()] else null

            JsonObject(buildMap {
                put("id", JsonPrimitive(dim.id))
                put("label", JsonPrimitive(dim.label))
                put("score", JsonPrimitive(score))
                put("max", JsonPrimitive(dim.max))
                put("gap", if (gap != null) JsonPrimitive(gap) else JsonNull)
                put("coaching_actions", JsonArray(actions.map { JsonPrimitive(it) }))
            })
        }

        val result = JsonObject(mapOf(
            "dog_name" to JsonPrimitive(name),
            "rubric_version" to JsonPrimitive(config.version),
            "scored_at" to JsonPrimitive(Instant.now().toString()),
            "total_score" to JsonPrimitive(totalScore),
            "max_score" to JsonPrimitive(config.maxScore),
            "grade" to JsonPrimitive(grade),
            "grade_label" to JsonPrimitive(gradeLabel),
            "dimensions" to JsonArray(dimensions),
            "priority_gaps" to JsonArray(priorityGapIds.map { JsonPrimitive(it) })
        ))

        return Json { prettyPrint = true }.encodeToString(JsonElement.serializer(), result)
    }

    fun buildCSV(
        dogName: String,
        scores: Map<String, Int>,
        totalScore: Int,
        grade: String,
        config: RubricConfig
    ): String {
        val name = dogName.ifEmpty { "Unknown" }
        val lines = mutableListOf("Dimension,Score,Max,Gap")

        for (dim in config.dimensions) {
            val score = scores[dim.id] ?: 0
            val gap = if (score < dim.max) {
                dim.scores[score.toString()]?.replace(",", ";") ?: ""
            } else ""
            lines.add("${dim.label},$score,${dim.max},\"$gap\"")
        }

        lines.add("")
        lines.add("Dog Name,$name")
        lines.add("Total Score,$totalScore/${config.maxScore}")
        lines.add("Grade,$grade")
        lines.add("Scored At,${Instant.now()}")
        lines.add("Rubric Version,${config.version}")

        return lines.joinToString("\n")
    }

    fun writeTempFile(fileName: String, extension: String, content: String): Uri? {
        val ctx = context ?: return null
        return try {
            val file = File(ctx.cacheDir, "$fileName.$extension")
            file.writeText(content)
            FileProvider.getUriForFile(
                ctx,
                "${ctx.packageName}.fileprovider",
                file
            )
        } catch (e: Exception) {
            null
        }
    }
}
