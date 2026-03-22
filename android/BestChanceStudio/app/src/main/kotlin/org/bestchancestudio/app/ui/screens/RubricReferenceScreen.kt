package org.bestchancestudio.app.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import org.bestchancestudio.app.models.RubricConfig
import org.bestchancestudio.app.ui.components.GradeThresholdBar
import org.bestchancestudio.app.ui.components.RubricDimensionCard

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun RubricReferenceScreen(
    rubricConfig: RubricConfig,
    modifier: Modifier = Modifier
) {
    Scaffold(
        topBar = { TopAppBar(title = { Text("Rubric Reference") }) },
        modifier = modifier
    ) { padding ->
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .background(MaterialTheme.colorScheme.background),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            item {
                GradeThresholdBar(
                    thresholds = rubricConfig.gradeThresholds,
                    modifier = Modifier.padding(horizontal = 16.dp, vertical = 12.dp)
                )
            }

            item {
                Text(
                    text = "Rubric v${rubricConfig.version} · 9 dimensions · max ${rubricConfig.maxScore}",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    modifier = Modifier.padding(bottom = 8.dp)
                )
            }

            itemsIndexed(rubricConfig.dimensions, key = { _, dim -> dim.id }) { index, dimension ->
                RubricDimensionCard(
                    dimension = dimension,
                    index = index,
                    modifier = Modifier.padding(horizontal = 16.dp, vertical = 4.dp)
                )
            }

            item { Spacer(modifier = Modifier.height(32.dp)) }
        }
    }
}
