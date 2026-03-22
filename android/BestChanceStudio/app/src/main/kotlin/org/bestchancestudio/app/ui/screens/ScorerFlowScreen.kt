package org.bestchancestudio.app.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.onFocusChanged
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import org.bestchancestudio.app.ui.components.DimensionCard
import org.bestchancestudio.app.ui.theme.BcsOrange
import org.bestchancestudio.app.ui.theme.BcsRed
import org.bestchancestudio.app.viewmodels.ScorerViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ScorerFlowScreen(
    modifier: Modifier = Modifier,
    viewModel: ScorerViewModel = hiltViewModel()
) {
    val state by viewModel.uiState.collectAsState()
    val focusManager = LocalFocusManager.current

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("BCS Scorer") },
                actions = {
                    if (state.showResults) {
                        TextButton(onClick = { viewModel.reset() }) {
                            Text("New Score", color = BcsOrange)
                        }
                    }
                }
            )
        },
        modifier = modifier
    ) { padding ->
        if (state.showResults) {
            val (grade, label) = viewModel.gradeResult()
            ResultsScreen(
                dogName = state.dogName,
                scores = state.scores,
                totalScore = state.totalScore,
                grade = grade,
                gradeLabel = label,
                config = viewModel.config,
                modifier = Modifier.padding(padding),
                onSaveSession = { viewModel.saveSession() }
            )
        } else {
            ScoringView(
                viewModel = viewModel,
                modifier = Modifier.padding(padding)
            )
        }
    }
}

@Composable
private fun ScoringView(
    viewModel: ScorerViewModel,
    modifier: Modifier = Modifier
) {
    val state by viewModel.uiState.collectAsState()
    val config = viewModel.config
    val listState = rememberLazyListState()
    val focusManager = LocalFocusManager.current

    LaunchedEffect(state.expandedDimensionId) {
        val expandedId = state.expandedDimensionId ?: return@LaunchedEffect
        val idx = config.dimensions.indexOfFirst { it.id == expandedId }
        if (idx >= 0) {
            listState.animateScrollToItem(idx + 1) // +1 for name header
        }
    }

    LazyColumn(
        state = listState,
        modifier = modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background)
    ) {
        // Dog name input
        item {
            Column(modifier = Modifier.padding(horizontal = 16.dp, vertical = 12.dp)) {
                Text(
                    text = "Dog's Name",
                    style = MaterialTheme.typography.labelLarge,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
                Spacer(modifier = Modifier.height(6.dp))
                OutlinedTextField(
                    value = state.dogName,
                    onValueChange = { viewModel.updateDogName(it) },
                    placeholder = { Text("Enter dog's name") },
                    singleLine = true,
                    keyboardOptions = KeyboardOptions(imeAction = ImeAction.Done),
                    keyboardActions = KeyboardActions(onDone = {
                        focusManager.clearFocus()
                        viewModel.submitName()
                    }),
                    modifier = Modifier
                        .fillMaxWidth()
                        .onFocusChanged { viewModel.setNameFieldFocused(it.isFocused) }
                )

                if (viewModel.allDimensionsScored && !state.nameFieldFocused) {
                    if (!state.hasValidName) {
                        Text(
                            text = "Enter the dog's name to see results",
                            style = MaterialTheme.typography.bodySmall,
                            color = BcsRed,
                            modifier = Modifier.padding(top = 4.dp)
                        )
                    } else if (!state.showResults) {
                        Button(
                            onClick = { viewModel.submitName() },
                            colors = ButtonDefaults.buttonColors(containerColor = BcsOrange),
                            shape = RoundedCornerShape(8.dp),
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(top = 8.dp)
                        ) {
                            Text("See Results")
                        }
                    }
                }
            }
        }

        // Progress
        item {
            val scored = state.scores.size
            val total = config.dimensions.size
            if (total > 0) {
                Row(modifier = Modifier.padding(horizontal = 16.dp, vertical = 4.dp)) {
                    Text(
                        text = "$scored/$total dimensions scored",
                        style = MaterialTheme.typography.bodyMedium,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }
        }

        // Dimension cards
        itemsIndexed(config.dimensions, key = { _, dim -> dim.id }) { index, dimension ->
            DimensionCard(
                dimension = dimension,
                index = index,
                currentScore = state.scores[dimension.id],
                isExpanded = state.expandedDimensionId == dimension.id,
                onScoreSelected = { score -> viewModel.setScore(score, dimension.id) },
                onToggle = { viewModel.toggleDimension(dimension.id) },
                modifier = Modifier.padding(horizontal = 16.dp, vertical = 4.dp)
            )
        }

        item { Spacer(modifier = Modifier.height(32.dp)) }
    }
}
