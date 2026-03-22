package org.bestchancestudio.app.database.dao

import androidx.room.Dao
import androidx.room.Insert
import org.bestchancestudio.app.models.DimensionScore

@Dao
interface DimensionScoreDao {
    @Insert
    suspend fun insertAll(scores: List<DimensionScore>)
}
