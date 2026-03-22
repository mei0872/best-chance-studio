package org.bestchancestudio.app.repositories

import kotlinx.coroutines.flow.Flow
import org.bestchancestudio.app.database.dao.DimensionScoreDao
import org.bestchancestudio.app.database.dao.DogDao
import org.bestchancestudio.app.database.dao.ScoringSessionDao
import org.bestchancestudio.app.models.DimensionScore
import org.bestchancestudio.app.models.Dog
import org.bestchancestudio.app.models.DogWithLatestSession
import org.bestchancestudio.app.models.ScoringSession
import org.bestchancestudio.app.models.SessionWithScores
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class ScoringRepository @Inject constructor(
    private val dogDao: DogDao,
    private val sessionDao: ScoringSessionDao,
    private val dimensionScoreDao: DimensionScoreDao
) {
    fun getAllDogsWithSessions(): Flow<List<DogWithLatestSession>> =
        dogDao.getAllDogsWithSessions()

    suspend fun saveScoringSession(
        dogName: String,
        scores: Map<String, Int>,
        totalScore: Int,
        maxScore: Int,
        grade: String,
        gradeLabel: String,
        rubricVersion: String
    ) {
        val dogId = dogDao.insert(Dog(name = dogName))

        val sessionId = sessionDao.insert(
            ScoringSession(
                dogId = dogId,
                totalScore = totalScore,
                maxScore = maxScore,
                grade = grade,
                gradeLabel = gradeLabel,
                rubricVersion = rubricVersion
            )
        )

        val dimensionScores = scores.map { (dimensionId, score) ->
            DimensionScore(
                sessionId = sessionId,
                dimensionId = dimensionId,
                score = score,
                maxScore = 2
            )
        }
        dimensionScoreDao.insertAll(dimensionScores)
    }

    suspend fun getSessionWithScores(sessionId: Long): SessionWithScores? =
        sessionDao.getSessionWithScores(sessionId)

    suspend fun getLatestSessionForDog(dogId: Long): SessionWithScores? =
        sessionDao.getLatestSessionForDog(dogId)

    suspend fun deleteDog(dog: Dog) = dogDao.delete(dog)
}
