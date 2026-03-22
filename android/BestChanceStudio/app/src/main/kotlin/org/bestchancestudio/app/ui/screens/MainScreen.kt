package org.bestchancestudio.app.ui.screens

import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Book
import androidx.compose.material.icons.filled.History
import androidx.compose.material.icons.filled.Star
import androidx.compose.material3.Icon
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.NavigationBarItemDefaults
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.hilt.navigation.compose.hiltViewModel
import kotlinx.coroutines.launch
import org.bestchancestudio.app.models.SessionWithScores
import org.bestchancestudio.app.ui.theme.BcsOrange
import org.bestchancestudio.app.viewmodels.HistoryViewModel

private data class TabItem(val label: String, val icon: ImageVector)

private val tabs = listOf(
    TabItem("Score", Icons.Filled.Star),
    TabItem("History", Icons.Filled.History),
    TabItem("Rubric", Icons.Filled.Book)
)

@Composable
fun MainScreen() {
    var selectedTab by remember { mutableIntStateOf(0) }
    var selectedSession by remember { mutableStateOf<Pair<String, SessionWithScores>?>(null) }
    val historyViewModel: HistoryViewModel = hiltViewModel()
    val scope = rememberCoroutineScope()

    // If viewing a session detail, show it
    selectedSession?.let { (dogName, session) ->
        SessionDetailScreen(
            dogName = dogName,
            sessionWithScores = session,
            rubricConfig = historyViewModel.rubricConfig,
            modifier = Modifier.fillMaxSize()
        )
        return
    }

    Scaffold(
        bottomBar = {
            NavigationBar(containerColor = Color.White) {
                tabs.forEachIndexed { index, tab ->
                    NavigationBarItem(
                        selected = selectedTab == index,
                        onClick = { selectedTab = index },
                        label = { Text(tab.label) },
                        icon = { Icon(tab.icon, contentDescription = tab.label) },
                        colors = NavigationBarItemDefaults.colors(
                            selectedIconColor = BcsOrange,
                            selectedTextColor = BcsOrange,
                            indicatorColor = BcsOrange.copy(alpha = 0.1f)
                        )
                    )
                }
            }
        }
    ) { padding ->
        when (selectedTab) {
            0 -> ScorerFlowScreen(modifier = Modifier.fillMaxSize())
            1 -> DogHistoryScreen(
                modifier = Modifier.fillMaxSize(),
                viewModel = historyViewModel,
                onDogSelected = { dogId, sessionId ->
                    scope.launch {
                        val session = historyViewModel.getSessionWithScores(dogId)
                        if (session != null) {
                            val dog = historyViewModel.dogs.value.find { it.dog.id == dogId }
                            selectedSession = (dog?.dog?.name ?: "Unknown") to session
                        }
                    }
                }
            )
            2 -> RubricReferenceScreen(
                rubricConfig = historyViewModel.rubricConfig,
                modifier = Modifier.fillMaxSize()
            )
        }
    }
}
