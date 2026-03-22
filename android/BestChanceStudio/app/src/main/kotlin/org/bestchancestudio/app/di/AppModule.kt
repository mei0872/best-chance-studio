package org.bestchancestudio.app.di

import android.content.Context
import androidx.room.Room
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import org.bestchancestudio.app.database.BcsDatabase
import org.bestchancestudio.app.database.dao.DimensionScoreDao
import org.bestchancestudio.app.database.dao.DogDao
import org.bestchancestudio.app.database.dao.ScoringSessionDao
import org.bestchancestudio.app.models.RubricConfig
import org.bestchancestudio.app.repositories.ExportRepository
import org.bestchancestudio.app.utils.RubricLoader
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Provides
    @Singleton
    fun provideDatabase(@ApplicationContext context: Context): BcsDatabase =
        Room.databaseBuilder(context, BcsDatabase::class.java, "bcs_database")
            .build()

    @Provides
    fun provideDogDao(database: BcsDatabase): DogDao = database.dogDao()

    @Provides
    fun provideScoringSessionDao(database: BcsDatabase): ScoringSessionDao =
        database.scoringSessionDao()

    @Provides
    fun provideDimensionScoreDao(database: BcsDatabase): DimensionScoreDao =
        database.dimensionScoreDao()

    @Provides
    @Singleton
    fun provideRubricConfig(@ApplicationContext context: Context): RubricConfig =
        RubricLoader(context).load()

    @Provides
    @Singleton
    fun provideExportRepository(@ApplicationContext context: Context): ExportRepository =
        ExportRepository(context)
}
