package org.bestchancestudio.app.utils

import androidx.compose.ui.graphics.Color
import org.bestchancestudio.app.models.GradeThreshold
import org.bestchancestudio.app.ui.theme.BcsGold
import org.bestchancestudio.app.ui.theme.BcsGreen
import org.bestchancestudio.app.ui.theme.BcsOrange
import org.bestchancestudio.app.ui.theme.BcsRed

data class GradeResult(val grade: String, val label: String)

data class GradeColorInfo(val foreground: Color, val background: Color)

object GradeCalculator {
    val gradeOrder = listOf("A+", "A", "B", "C", "D")

    fun grade(totalScore: Int, thresholds: Map<String, GradeThreshold>): GradeResult {
        for (g in gradeOrder) {
            val t = thresholds[g] ?: continue
            if (totalScore >= t.min && totalScore <= t.max) {
                return GradeResult(g, t.label)
            }
        }
        return GradeResult("D", thresholds["D"]?.label ?: "Needs significant improvement.")
    }

    fun gradeColor(grade: String): GradeColorInfo = when (grade) {
        "A+", "A" -> GradeColorInfo(Color.White, BcsGreen)
        "B" -> GradeColorInfo(Color.White, BcsGold)
        "C" -> GradeColorInfo(Color.White, BcsOrange)
        else -> GradeColorInfo(Color.White, BcsRed)
    }
}

fun scoreColor(score: Int): Color = when (score) {
    2 -> BcsGreen
    1 -> BcsGold
    else -> BcsRed
}
