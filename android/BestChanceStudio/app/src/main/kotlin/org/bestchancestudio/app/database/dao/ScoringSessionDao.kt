package org.bestchancestudio.app.database.dao

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.Query
import androidx.room.Transaction
import org.bestchancestudio.app.models.ScoringSession
import org.bestchancestudio.app.models.SessionWithScores

@Dao
interface ScoringSessionDao {
    @Insert
    suspend fun insert(session: ScoringSession): Long

    @Transaction
    @Query("SELECT * FROM scoring_sessions WHERE id = :sessionId")
    suspend fun getSessionWithScores(sessionId: Long): SessionWithScores?

    @Transaction
    @Query("SELECT * FROM scoring_sessions WHERE dogId = :dogId ORDER BY scoredAt DESC LIMIT 1")
    suspend fun getLatestSessionForDog(dogId: Long): SessionWithScores?
}
