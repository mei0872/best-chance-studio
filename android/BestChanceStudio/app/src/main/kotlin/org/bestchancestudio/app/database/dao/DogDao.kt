package org.bestchancestudio.app.database.dao

import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.Query
import androidx.room.Transaction
import kotlinx.coroutines.flow.Flow
import org.bestchancestudio.app.models.Dog
import org.bestchancestudio.app.models.DogWithLatestSession

@Dao
interface DogDao {
    @Insert
    suspend fun insert(dog: Dog): Long

    @Transaction
    @Query("SELECT * FROM dogs ORDER BY createdAt DESC")
    fun getAllDogsWithSessions(): Flow<List<DogWithLatestSession>>

    @Delete
    suspend fun delete(dog: Dog)
}
