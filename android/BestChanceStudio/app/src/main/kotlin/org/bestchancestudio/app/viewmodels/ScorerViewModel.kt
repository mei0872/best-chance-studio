package org.bestchancestudio.app.viewmodels

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import org.bestchancestudio.app.models.RubricConfig
import org.bestchancestudio.app.models.RubricDimension
import org.bestchancestudio.app.repositories.ScoringRepository
import org.bestchancestudio.app.utils.GradeCalculator
import javax.inject.Inject

data class ScorerUiState(
    val dogName: String = "",
    val scores: Map<String, Int> = emptyMap(),
    val expandedDimensionId: String? = null,
    val showResults: Boolean = false,
    val sessionSaved: Boolean = false,
    val nameFieldFocused: Boolean = false
) {
    val hasValidName: Boolean get() = dogName.trim().isNotEmpty()
    val totalScore: Int get() = scores.values.sum()
}

@HiltViewModel
class ScorerViewModel @Inject constructor(
    private val rubricConfig: RubricConfig,
    private val scoringRepository: ScoringRepository
) : ViewModel() {

    private val _uiState = MutableStateFlow(ScorerUiState(
        expandedDimensionId = rubricConfig.dimensions.firstOrNull()?.id
    ))
    val uiState: StateFlow<ScorerUiState> = _uiState.asStateFlow()

    val config: RubricConfig get() = rubricConfig

    val allDimensionsScored: Boolean
        get() = _uiState.value.scores.size == rubricConfig.dimensions.size

    fun updateDogName(name: String) {
        _uiState.update { it.copy(dogName = name) }
    }

    fun setNameFieldFocused(focused: Boolean) {
        _uiState.update { it.copy(nameFieldFocused = focused) }
    }

    fun submitName() {
        _uiState.update { state ->
            if (state.hasValidName && allDimensionsScored && !state.showResults) {
                state.copy(showResults = true, nameFieldFocused = false)
            } else {
                state.copy(nameFieldFocused = false)
            }
        }
    }

    fun setScore(score: Int, dimensionId: String) {
        _uiState.update { state ->
            val newScores = state.scores + (dimensionId to score)
            val allScored = newScores.size == rubricConfig.dimensions.size

            if (allScored && state.hasValidName) {
                state.copy(
                    scores = newScores,
                    showResults = true,
                    expandedDimensionId = null
                )
            } else {
                val nextId = findNextUnscored(newScores, dimensionId)
                state.copy(scores = newScores, expandedDimensionId = nextId)
            }
        }
    }

    fun toggleDimension(dimensionId: String) {
        _uiState.update { state ->
            state.copy(
                expandedDimensionId = if (state.expandedDimensionId == dimensionId) null else dimensionId
            )
        }
    }

    fun gradeResult(): Pair<String, String> {
        val result = GradeCalculator.grade(_uiState.value.totalScore, rubricConfig.gradeThresholds)
        return result.grade to result.label
    }

    fun priorityGaps(): List<RubricDimension> {
        val scores = _uiState.value.scores
        return rubricConfig.dimensions
            .filter { (scores[it.id] ?: 0) < it.max }
            .sortedBy { scores[it.id] ?: 0 }
            .take(3)
    }

    fun saveSession() {
        val state = _uiState.value
        if (state.sessionSaved || !state.hasValidName || !allDimensionsScored) return

        val (grade, label) = gradeResult()
        viewModelScope.launch {
            scoringRepository.saveScoringSession(
                dogName = state.dogName,
                scores = state.scores,
                totalScore = state.totalScore,
                maxScore = rubricConfig.maxScore,
                grade = grade,
                gradeLabel = label,
                rubricVersion = rubricConfig.version
            )
            _uiState.update { it.copy(sessionSaved = true) }
        }
    }

    fun reset() {
        _uiState.value = ScorerUiState(
            expandedDimensionId = rubricConfig.dimensions.firstOrNull()?.id
        )
    }

    private fun findNextUnscored(scores: Map<String, Int>, currentId: String): String? {
        val dims = rubricConfig.dimensions
        val currentIdx = dims.indexOfFirst { it.id == currentId }
        if (currentIdx == -1) return null

        for (i in (currentIdx + 1) until dims.size) {
            if (scores[dims[i].id] == null) return dims[i].id
        }
        return dims.firstOrNull { scores[it.id] == null }?.id
    }
}
