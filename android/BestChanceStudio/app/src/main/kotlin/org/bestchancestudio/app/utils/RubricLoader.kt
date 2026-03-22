package org.bestchancestudio.app.utils

import android.content.Context
import kotlinx.serialization.json.Json
import org.bestchancestudio.app.models.RubricConfig

class RubricLoader(private val context: Context) {
    private val json = Json { ignoreUnknownKeys = true }

    fun load(): RubricConfig {
        val inputStream = context.assets.open("rubric-config.json")
        val jsonString = inputStream.bufferedReader().use { it.readText() }
        return json.decodeFromString<RubricConfig>(jsonString)
    }

    fun loadFromString(jsonString: String): RubricConfig {
        return json.decodeFromString<RubricConfig>(jsonString)
    }
}
