package org.bestchancestudio.app.ui.theme

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color

private val LightColorScheme = lightColorScheme(
    primary = BcsOrange,
    onPrimary = Color.White,
    secondary = BcsGold,
    onSecondary = Color.White,
    background = Color(0xFFF2F2F7),
    onBackground = Color.Black,
    surface = Color.White,
    onSurface = Color.Black,
    surfaceContainer = Color.White,
    surfaceContainerHigh = Color(0xFFF2F2F7),
    error = BcsRed,
    onError = Color.White
)

@Composable
fun BestChanceStudioTheme(content: @Composable () -> Unit) {
    MaterialTheme(
        colorScheme = LightColorScheme,
        typography = Typography,
        content = content
    )
}
