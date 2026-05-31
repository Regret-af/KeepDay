import '../../domain/services/streak_calculator.dart';
import '../database/app_database.dart';

Future<void> recalculateHabitStats(AppDatabase database, String habitId) async {
  final habit = await database.habitDao.getHabitById(habitId);
  if (habit == null) {
    return;
  }

  final records = await database.checkInDao.getRecordsByHabitId(habitId);
  final pausePeriods = await database.pausePeriodDao.getPausePeriodsByHabitId(
    habitId,
  );
  final result = const StreakCalculator().calculate(
    createdAt: habit.createdAt,
    gracePerWeek: habit.gracePerWeek,
    checkInDates: records.map((record) => record.checkInDate),
    pauseRanges: pausePeriods.map(
      (period) =>
          PauseRange(startDate: period.startDate, endDate: period.endDate),
    ),
  );

  await database.habitDao.updateStats(
    habitId,
    totalCheckInCount: result.stats.totalCheckInCount,
    bestStreak: result.stats.bestStreak,
    currentStreak: result.stats.currentStreak,
  );
}
