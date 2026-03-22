package org.bestchancestudio.app.database

import androidx.room.Database
import androidx.room.RoomDatabase
import org.bestchancestudio.app.database.dao.DimensionScoreDao
import org.bestchancestudio.app.database.dao.DogDao
import org.bestchancestudio.app.database.dao.ScoringSessionDao
import org.bestchancestudio.app.models.DimensionScore
import org.bestchancestudio.app.models.Dog
import org.bestchancestudio.app.models.ScoringSession

@Database(
    entities = [Dog::class, ScoringSession::class, DimensionScore::class],
    version = 1,
    exportSchema = false
)
abstract class BcsDatabase : RoomDatabase() {
    abstract fun dogDao(): DogDao
    abstract fun scoringSessionDao(): ScoringSessionDao
    abstract fun dimensionScoreDao(): DimensionScoreDao
}
