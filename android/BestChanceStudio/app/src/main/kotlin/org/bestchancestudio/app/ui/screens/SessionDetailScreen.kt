package org.bestchancestudio.app.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import org.bestchancestudio.app.models.RubricConfig
import org.bestchancestudio.app.models.SessionWithScores
import org.bestchancestudio.app.repositories.ExportRepository
import org.bestchancestudio.app.ui.components.BadgeSize
import org.bestchancestudio.app.ui.components.GapsList
import org.bestchancestudio.app.ui.components.GradeBadge
import org.bestchancestudio.app.ui.components.ScoreBar
import org.bestchancestudio.app.ui.theme.BcsOrange
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

@Composable
fun SessionDetailScreen(
    dogName: String,
    sessionWithScores: SessionWithScores,
    rubricConfig: RubricConfig,
    modifier: Modifier = Modifier
) {
    val session = sessionWithScores.session
    val scores = sessionWithScores.dimensionScores.associate { it.dimensionId to it.score }
    val context = LocalContext.current
    val exportRepository = ExportRepository(context)
    val dateFormat = SimpleDateFormat("MMM d, yyyy 'at' h:mm a", Locale.getDefault())

    val gaps = rubricConfig.dimensions
        .filter { (scores[it.id] ?: 0) < it.max }
        .sortedBy { scores[it.id] ?: 0 }
        .take(3)

    Column(
        modifier = modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .background(MaterialTheme.colorScheme.background)
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = dogName,
            style = MaterialTheme.typography.headlineMedium,
            color = MaterialTheme.colorScheme.onBackground
        )
        Spacer(modifier = Modifier.height(8.dp))

        Text(
            text = "${session.totalScore}/${session.maxScore}",
            fontSize = 48.sp,
            fontWeight = FontWeight.Bold,
            color = MaterialTheme.colorScheme.onBackground
        )

        GradeBadge(grade = session.grade, size = BadgeSize.LARGE)
        Spacer(modifier = Modifier.height(8.dp))

        Text(
            text = session.gradeLabel,
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            textAlign = TextAlign.Center
        )

        Text(
            text = "Scored ${dateFormat.format(Date(session.scoredAt))}",
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            modifier = Modifier.padding(top = 4.dp)
        )

        Text(
            text = "Rubric v${session.rubricVersion}",
            style = MaterialTheme.typography.labelSmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.6f),
            modifier = Modifier.padding(top = 2.dp)
        )

        Spacer(modifier = Modifier.height(24.dp))

        // Score bars
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .background(
                    MaterialTheme.colorScheme.surfaceContainerHigh,
                    RoundedCornerShape(12.dp)
                )
                .padding(16.dp)
        ) {
            Text(
                text = "Score Breakdown",
                style = MaterialTheme.typography.titleMedium,
                color = MaterialTheme.colorScheme.onSurface
            )
            Spacer(modifier = Modifier.height(12.dp))
            rubricConfig.dimensions.forEach { dim ->
                ScoreBar(
                    label = dim.label,
                    score = scores[dim.id] ?: 0,
                    maxScore = dim.max,
                    modifier = Modifier.padding(vertical = 2.dp)
                )
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Gaps
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .background(
                    MaterialTheme.colorScheme.surfaceContainerHigh,
                    RoundedCornerShape(12.dp)
                )
                .padding(16.dp)
        ) {
            GapsList(gaps = gaps, scores = scores)
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Export
        Row(
            horizontalArrangement = Arrangement.spacedBy(12.dp),
            modifier = Modifier.fillMaxWidth().padding(horizontal = 16.dp)
        ) {
            Button(
                onClick = {
                    shareExport(context, exportRepository, "json", dogName, scores, session.totalScore, session.grade, session.gradeLabel, rubricConfig)
                },
                colors = ButtonDefaults.buttonColors(containerColor = BcsOrange),
                shape = RoundedCornerShape(10.dp),
                modifier = Modifier.weight(1f)
            ) {
                Text("JSON")
            }
            Button(
                onClick = {
                    shareExport(context, exportRepository, "csv", dogName, scores, session.totalScore, session.grade, session.gradeLabel, rubricConfig)
                },
                colors = ButtonDefaults.buttonColors(containerColor = BcsOrange),
                shape = RoundedCornerShape(10.dp),
                modifier = Modifier.weight(1f)
            ) {
                Text("CSV")
            }
        }

        Spacer(modifier = Modifier.height(32.dp))
    }
}

private fun shareExport(
    context: android.content.Context,
    exportRepository: ExportRepository,
    format: String,
    dogName: String,
    scores: Map<String, Int>,
    totalScore: Int,
    grade: String,
    gradeLabel: String,
    config: RubricConfig
) {
    val fileName = dogName.lowercase().replace(" ", "-")
    val content = if (format == "json") {
        exportRepository.buildJSON(dogName, scores, totalScore, grade, gradeLabel, config)
    } else {
        exportRepository.buildCSV(dogName, scores, totalScore, grade, config)
    }

    val uri = exportRepository.writeTempFile(fileName, format, content) ?: return
    val mimeType = if (format == "json") "application/json" else "text/csv"

    val intent = android.content.Intent(android.content.Intent.ACTION_SEND).apply {
        type = mimeType
        putExtra(android.content.Intent.EXTRA_STREAM, uri)
        addFlags(android.content.Intent.FLAG_GRANT_READ_URI_PERMISSION)
    }
    context.startActivity(android.content.Intent.createChooser(intent, "Export $format"))
}
