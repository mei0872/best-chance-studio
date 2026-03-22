package org.bestchancestudio.app

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import dagger.hilt.android.AndroidEntryPoint
import org.bestchancestudio.app.ui.screens.MainScreen
import org.bestchancestudio.app.ui.theme.BestChanceStudioTheme

@AndroidEntryPoint
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            BestChanceStudioTheme {
                MainScreen()
            }
        }
    }
}
