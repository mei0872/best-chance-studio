package org.bestchancestudio.app.ui.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import org.bestchancestudio.app.models.GradeThreshold
import org.bestchancestudio.app.utils.GradeCalculator

@Composable
fun GradeThresholdBar(
    thresholds: Map<String, GradeThreshold>,
    modifier: Modifier = Modifier
) {
    Row(
        modifier = modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.spacedBy(6.dp)
    ) {
        GradeCalculator.gradeOrder.forEach { grade ->
            val threshold = thresholds[grade] ?: return@forEach
            val colors = GradeCalculator.gradeColor(grade)

            Column(
                modifier = Modifier
                    .weight(1f)
                    .clip(RoundedCornerShape(6.dp))
                    .background(colors.background)
                    .padding(vertical = 6.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Text(
                    text = grade,
                    color = colors.foreground,
                    fontSize = 12.sp,
                    fontWeight = FontWeight.Bold
                )
                Text(
                    text = "${threshold.min}–${threshold.max}",
                    color = colors.foreground.copy(alpha = 0.8f),
                    fontSize = 10.sp
                )
            }
        }
    }
}
