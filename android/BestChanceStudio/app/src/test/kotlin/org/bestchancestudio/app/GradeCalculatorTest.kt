package org.bestchancestudio.app

import org.bestchancestudio.app.models.GradeThreshold
import org.bestchancestudio.app.ui.theme.BcsGold
import org.bestchancestudio.app.ui.theme.BcsGreen
import org.bestchancestudio.app.ui.theme.BcsOrange
import org.bestchancestudio.app.ui.theme.BcsRed
import org.bestchancestudio.app.utils.GradeCalculator
import org.junit.Assert.assertEquals
import org.junit.Before
import org.junit.Test

class GradeCalculatorTest {

    private lateinit var thresholds: Map<String, GradeThreshold>

    @Before
    fun setUp() {
        thresholds = mapOf(
            "A+" to GradeThreshold(min = 16, max = 18, label = "Outstanding. This dog is ready."),
            "A" to GradeThreshold(min = 12, max = 15, label = "Strong. Minor gaps to close."),
            "B" to GradeThreshold(min = 8, max = 11, label = "Good foundation. Key gaps remain."),
            "C" to GradeThreshold(min = 5, max = 7, label = "Significant gaps. Needs coaching."),
            "D" to GradeThreshold(min = 0, max = 4, label = "Start over. This dog is invisible.")
        )
    }

    // Grade boundaries
    @Test fun testGradeAPlusAtMaxScore() = assertEquals("A+", GradeCalculator.grade(18, thresholds).grade)
    @Test fun testGradeAPlusAtMinBoundary() = assertEquals("A+", GradeCalculator.grade(16, thresholds).grade)
    @Test fun testGradeAAtMaxBoundary() = assertEquals("A", GradeCalculator.grade(15, thresholds).grade)
    @Test fun testGradeAAtMinBoundary() = assertEquals("A", GradeCalculator.grade(12, thresholds).grade)
    @Test fun testGradeBAtMaxBoundary() = assertEquals("B", GradeCalculator.grade(11, thresholds).grade)
    @Test fun testGradeBAtMinBoundary() = assertEquals("B", GradeCalculator.grade(8, thresholds).grade)
    @Test fun testGradeCAtMaxBoundary() = assertEquals("C", GradeCalculator.grade(7, thresholds).grade)
    @Test fun testGradeCAtMinBoundary() = assertEquals("C", GradeCalculator.grade(5, thresholds).grade)
    @Test fun testGradeDAtMaxBoundary() = assertEquals("D", GradeCalculator.grade(4, thresholds).grade)
    @Test fun testGradeDAtZero() = assertEquals("D", GradeCalculator.grade(0, thresholds).grade)

    // Labels
    @Test
    fun testGradeLabelReturned() {
        assertEquals("Start over. This dog is invisible.", GradeCalculator.grade(3, thresholds).label)
    }

    @Test
    fun testGradeAPlusLabel() {
        assertEquals("Outstanding. This dog is ready.", GradeCalculator.grade(17, thresholds).label)
    }

    // Known examples (from bcs-example.md)
    @Test fun testMooseBeforeScore() = assertEquals("D", GradeCalculator.grade(3, thresholds).grade)
    @Test fun testMooseAfterScore() = assertEquals("A", GradeCalculator.grade(14, thresholds).grade)

    // Colors
    @Test fun testAPlusColorIsGreen() = assertEquals(BcsGreen, GradeCalculator.gradeColor("A+").background)
    @Test fun testAColorIsGreen() = assertEquals(BcsGreen, GradeCalculator.gradeColor("A").background)
    @Test fun testBColorIsGold() = assertEquals(BcsGold, GradeCalculator.gradeColor("B").background)
    @Test fun testCColorIsOrange() = assertEquals(BcsOrange, GradeCalculator.gradeColor("C").background)
    @Test fun testDColorIsRed() = assertEquals(BcsRed, GradeCalculator.gradeColor("D").background)

    // Edge cases
    @Test fun testEmptyThresholdsDefaultsToD() = assertEquals("D", GradeCalculator.grade(18, emptyMap()).grade)
    @Test fun testGradeOrderIsConsistent() = assertEquals(listOf("A+", "A", "B", "C", "D"), GradeCalculator.gradeOrder)
}
