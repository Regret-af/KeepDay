import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/utils/date_utils.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';
import 'statistics_writer.dart';

class HabitInput {
  const HabitInput({
    required this.name,
    required this.color,
    this.icon,
    this.gracePerWeek = 0,
    this.reminderEnabled = false,
    this.reminderTime,
  });

  final String name;
  final String color;
  final String? icon;
  final int gracePerWeek;
  final bool reminderEnabled;
  final String? reminderTime;
}

class HabitRepository {
  HabitRepository(this._database);

  final AppDatabase _database;

  HabitDao get _habitDao => _database.habitDao;
  PausePeriodDao get _pausePeriodDao => _database.pausePeriodDao;

  Stream<List<Habit>> watchActiveHabits() => _habitDao.watchActiveHabits();

  Stream<List<HabitPausePeriod>> watchPausePeriods() {
    return _pausePeriodDao.watchPausePeriods();
  }

  Future<List<Habit>> getActiveHabits() => _habitDao.getActiveHabits();

  Future<Habit?> getHabitById(String id) => _habitDao.getHabitById(id);

  Stream<Habit?> watchHabitById(String id) => _habitDao.watchHabitById(id);

  Future<List<HabitPausePeriod>> getPausePeriodsByHabitId(String habitId) {
    return _pausePeriodDao.getPausePeriodsByHabitId(habitId);
  }

  Future<bool> hasActiveHabitWithName(String name, {String? excludeId}) {
    return _habitDao.hasActiveHabitWithName(name, excludeId: excludeId);
  }

  Future<String> createHabit(HabitInput input) async {
    final id = _newId();
    final now = DateTime.now();
    final sortOrder = await _habitDao.getNextSortOrder();

    await _database.transaction(() async {
      await _habitDao.insertHabit(
        HabitsCompanion.insert(
          id: id,
          name: input.name,
          icon: Value(_nullableText(input.icon)),
          color: input.color,
          reminderEnabled: Value(input.reminderEnabled),
          reminderTime: Value(_nullableText(input.reminderTime)),
          gracePerWeek: Value(input.gracePerWeek),
          status: const Value('normal'),
          sortOrder: Value(sortOrder),
          totalCheckInCount: const Value(0),
          bestStreak: const Value(0),
          currentStreak: const Value(0),
          createdAt: now,
          updatedAt: now,
        ),
      );
    });

    return id;
  }

  Future<void> updateHabit(String id, HabitInput input) {
    final now = DateTime.now();
    return _database.transaction(() async {
      await _habitDao.updateHabit(
        id,
        HabitsCompanion(
          name: Value(input.name),
          icon: Value(_nullableText(input.icon)),
          color: Value(input.color),
          reminderEnabled: Value(input.reminderEnabled),
          reminderTime: Value(_nullableText(input.reminderTime)),
          gracePerWeek: Value(input.gracePerWeek),
          updatedAt: Value(now),
        ),
      );
      await recalculateHabitStats(_database, id);
    });
  }

  Future<void> softDeleteHabit(String id) {
    return _database.transaction(() {
      return _habitDao.softDeleteHabit(id, DateTime.now());
    });
  }

  Future<void> pauseHabit(String id) {
    return _database.transaction(() async {
      final activePeriod = await _pausePeriodDao.getActivePausePeriod(id);
      if (activePeriod != null) {
        return;
      }
      await _habitDao.updateStatus(id, 'paused');
      await _pausePeriodDao.insertPausePeriod(
        HabitPausePeriodsCompanion.insert(
          id: _newId(),
          habitId: id,
          startDate: todayDateKey(),
          createdAt: DateTime.now(),
        ),
      );
      await recalculateHabitStats(_database, id);
    });
  }

  Future<void> resumeHabit(String id) {
    return _database.transaction(() async {
      final activePeriod = await _pausePeriodDao.getActivePausePeriod(id);
      if (activePeriod == null) {
        await _habitDao.updateStatus(id, 'normal');
        await recalculateHabitStats(_database, id);
        return;
      }
      await _pausePeriodDao.closePausePeriod(activePeriod.id, todayDateKey());
      await _habitDao.updateStatus(id, 'normal');
      await recalculateHabitStats(_database, id);
    });
  }

  String _newId() => DateTime.now().microsecondsSinceEpoch.toString();

  String? _nullableText(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  return HabitRepository(ref.watch(appDatabaseProvider));
});
