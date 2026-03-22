package org.bestchancestudio.app.models

import androidx.room.Embedded
import androidx.room.Entity
import androidx.room.ForeignKey
import androidx.room.Index
import androidx.room.PrimaryKey
import androidx.room.Relation

@Entity(
    tableName = "scoring_sessions",
    foreignKeys = [
        ForeignKey(
            entity = Dog::class,
            parentColumns = ["id"],
            childColumns = ["dogId"],
            onDelete = ForeignKey.CASCADE
        )
    ],
    indices = [Index("dogId")]
)
data class ScoringSession(
    @PrimaryKey(autoGenerate = true)
    val id: Long = 0,
    val dogId: Long,
    val scoredAt: Long = System.currentTimeMillis(),
    val totalScore: Int,
    val maxScore: Int,
    val grade: String,
    val gradeLabel: String,
    val rubricVersion: String
)

data class SessionWithScores(
    @Embedded
    val session: ScoringSession,
    @Relation(parentColumn = "id", entityColumn = "sessionId")
    val dimensionScores: List<DimensionScore>
) {
    val priorityGaps: List<DimensionScore>
        get() = dimensionScores
            .filter { it.score < it.maxScore }
            .sortedBy { it.score }
            .take(3)
}

data class DogWithLatestSession(
    @Embedded
    val dog: Dog,
    @Relation(parentColumn = "id", entityColumn = "dogId")
    val sessions: List<ScoringSession>
) {
    val latestSession: ScoringSession?
        get() = sessions.maxByOrNull { it.scoredAt }
}
