package org.bestchancestudio.app.viewmodels

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import org.bestchancestudio.app.models.Dog
import org.bestchancestudio.app.models.DogWithLatestSession
import org.bestchancestudio.app.models.RubricConfig
import org.bestchancestudio.app.models.SessionWithScores
import org.bestchancestudio.app.repositories.ScoringRepository
import javax.inject.Inject

@HiltViewModel
class HistoryViewModel @Inject constructor(
    private val scoringRepository: ScoringRepository,
    val rubricConfig: RubricConfig
) : ViewModel() {

    val dogs: StateFlow<List<DogWithLatestSession>> =
        scoringRepository.getAllDogsWithSessions()
            .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), emptyList())

    fun deleteDog(dog: Dog) {
        viewModelScope.launch {
            scoringRepository.deleteDog(dog)
        }
    }

    suspend fun getSessionWithScores(dogId: Long): SessionWithScores? =
        scoringRepository.getLatestSessionForDog(dogId)
}
