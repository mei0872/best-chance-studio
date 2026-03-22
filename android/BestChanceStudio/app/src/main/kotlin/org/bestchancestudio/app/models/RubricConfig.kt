package org.bestchancestudio.app.models

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class RubricConfig(
    val version: String,
    @SerialName("max_score")
    val maxScore: Int,
    val dimensions: List<RubricDimension>,
    @SerialName("grade_thresholds")
    val gradeThresholds: Map<String, GradeThreshold>
)

@Serializable
data class RubricDimension(
    val id: String,
    val label: String,
    val description: String,
    val max: Int,
    val weight: Double,
    val scores: Map<String, String>,
    @SerialName("coaching_actions")
    val coachingActions: Map<String, List<String>>
)

@Serializable
data class GradeThreshold(
    val min: Int,
    val max: Int,
    val label: String
)
