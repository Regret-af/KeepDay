import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/utils/date_utils.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';

class CheckInRepository {
  CheckInRepository(this._database);

  final AppDatabase _database;

  HabitDao get _habitDao => _database.habitDao;
  CheckInDao get _checkInDao => _database.checkInDao;

  Stream<List<CheckInRecord>> watchTodayRecords() {
    return _checkInDao.watchRecordsForDate(todayDateKey());
  }

  Future<List<CheckInRecord>> getRecordsByHabitId(String habitId) {
    return _checkInDao.getRecordsByHabitId(habitId);
  }

  Future<void> checkInToday(String habitId) {
    return _database.transaction(() async {
      await _checkInDao.insertRecord(
        CheckInRecordsCompanion.insert(
          id: _newId(),
          habitId: habitId,
          checkInDate: todayDateKey(),
          source: 'today',
          createdAt: DateTime.now(),
        ),
      );
      await _refreshTotalCount(habitId);
    });
  }

  Future<void> cancelTodayCheckIn(String habitId) {
    return _database.transaction(() async {
      await _checkInDao.deleteRecord(habitId, todayDateKey());
      await _refreshTotalCount(habitId);
    });
  }

  Future<void> _refreshTotalCount(String habitId) async {
    final count = await _checkInDao.countByHabitId(habitId);
    await _habitDao.updateTotalCheckInCount(habitId, count);
  }

  String _newId() => DateTime.now().microsecondsSinceEpoch.toString();
}

final checkInRepositoryProvider = Provider<CheckInRepository>((ref) {
  return CheckInRepository(ref.watch(appDatabaseProvider));
});
