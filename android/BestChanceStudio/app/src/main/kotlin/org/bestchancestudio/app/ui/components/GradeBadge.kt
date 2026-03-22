package org.bestchancestudio.app.ui.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import org.bestchancestudio.app.utils.GradeCalculator

enum class BadgeSize { SMALL, REGULAR, LARGE }

@Composable
fun GradeBadge(grade: String, size: BadgeSize = BadgeSize.REGULAR) {
    val colors = GradeCalculator.gradeColor(grade)
    val (fontSize, hPad, vPad) = when (size) {
        BadgeSize.SMALL -> Triple(12.sp, 6.dp, 2.dp)
        BadgeSize.REGULAR -> Triple(14.sp, 10.dp, 4.dp)
        BadgeSize.LARGE -> Triple(20.sp, 16.dp, 8.dp)
    }

    Text(
        text = grade,
        color = colors.foreground,
        fontSize = fontSize,
        fontWeight = FontWeight.Bold,
        modifier = Modifier
            .clip(RoundedCornerShape(50))
            .background(colors.background)
            .padding(horizontal = hPad, vertical = vPad)
    )
}
