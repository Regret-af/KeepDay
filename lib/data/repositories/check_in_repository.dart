import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/utils/date_utils.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';
import 'statistics_writer.dart';

class CheckInRepository {
  CheckInRepository(this._database);

  final AppDatabase _database;

  CheckInDao get _checkInDao => _database.checkInDao;

  Stream<List<CheckInRecord>> watchTodayRecords() {
    return _checkInDao.watchRecordsForDate(todayDateKey());
  }

  Stream<List<CheckInRecord>> watchRecords() {
    return _checkInDao.watchRecords();
  }

  Future<List<CheckInRecord>> getRecordsByHabitId(String habitId) {
    return _checkInDao.getRecordsByHabitId(habitId);
  }

  Future<CheckInRecord?> getRecordByHabitAndDate(String habitId, String date) {
    return _checkInDao.getRecordByHabitAndDate(habitId, date);
  }

  Future<void> checkInToday(String habitId) {
    return checkInDate(habitId, todayDateKey());
  }

  Future<void> cancelTodayCheckIn(String habitId) {
    return cancelCheckIn(habitId, todayDateKey());
  }

  Future<void> checkInDate(String habitId, String date) {
    return _database.transaction(() async {
      final habit = await _database.habitDao.getHabitById(habitId);
      if (habit == null || habit.deletedAt != null) {
        throw StateError('习惯不存在');
      }
      final targetDate = parseLocalDateKey(date);
      final createdDate = localDateOnly(habit.createdAt);
      final today = localDateOnly(DateTime.now());
      if (targetDate.isBefore(createdDate)) {
        throw ArgumentError('不能补创建日期之前的打卡');
      }
      if (targetDate.isAfter(today)) {
        throw ArgumentError('不能补未来日期的打卡');
      }

      await _checkInDao.insertRecord(
        CheckInRecordsCompanion.insert(
          id: _newId(),
          habitId: habitId,
          checkInDate: date,
          source: localDateKey(targetDate) == todayDateKey()
              ? 'today'
              : 'makeup',
          createdAt: DateTime.now(),
        ),
      );
      await recalculateHabitStats(_database, habitId);
    });
  }

  Future<void> cancelCheckIn(String habitId, String date) {
    return _database.transaction(() async {
      await _checkInDao.deleteRecord(habitId, date);
      await recalculateHabitStats(_database, habitId);
    });
  }

  String _newId() => DateTime.now().microsecondsSinceEpoch.toString();
}

final checkInRepositoryProvider = Provider<CheckInRepository>((ref) {
  return CheckInRepository(ref.watch(appDatabaseProvider));
});
