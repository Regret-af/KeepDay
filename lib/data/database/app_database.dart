import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../core/constants/app_constants.dart';

part 'app_database.g.dart';

class Habits extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get icon => text().nullable()();
  TextColumn get color => text()();
  BoolColumn get reminderEnabled =>
      boolean().withDefault(const Constant(false))();
  TextColumn get reminderTime => text().nullable()();
  IntColumn get gracePerWeek => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('normal'))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  IntColumn get totalCheckInCount =>
      integer().withDefault(const Constant(0))();
  IntColumn get bestStreak => integer().withDefault(const Constant(0))();
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class CheckInRecords extends Table {
  TextColumn get id => text()();
  TextColumn get habitId => text()();
  TextColumn get checkInDate => text()();
  TextColumn get source => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {habitId, checkInDate},
  ];
}

@DriftDatabase(tables: [Habits, CheckInRecords], daos: [HabitDao, CheckInDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
    : super(
        driftDatabase(
          name: AppConstants.databaseName,
          native: const DriftNativeOptions(),
        ),
      );

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;
}

@DriftAccessor(tables: [Habits])
class HabitDao extends DatabaseAccessor<AppDatabase> with _$HabitDaoMixin {
  HabitDao(super.db);

  Stream<List<Habit>> watchActiveHabits() {
    return (select(habits)
          ..where((habit) => habit.deletedAt.isNull())
          ..orderBy([
            (habit) => OrderingTerm.asc(habit.sortOrder),
            (habit) => OrderingTerm.asc(habit.createdAt),
          ]))
        .watch();
  }

  Future<List<Habit>> getActiveHabits() {
    return (select(habits)
          ..where((habit) => habit.deletedAt.isNull())
          ..orderBy([
            (habit) => OrderingTerm.asc(habit.sortOrder),
            (habit) => OrderingTerm.asc(habit.createdAt),
          ]))
        .get();
  }

  Future<Habit?> getHabitById(String id) {
    return (select(habits)..where((habit) => habit.id.equals(id)))
        .getSingleOrNull();
  }

  Stream<Habit?> watchHabitById(String id) {
    return (select(habits)..where((habit) => habit.id.equals(id)))
        .watchSingleOrNull();
  }

  Future<int> getNextSortOrder() async {
    final maxOrder = habits.sortOrder.max();
    final query = selectOnly(habits)..addColumns([maxOrder]);
    final row = await query.getSingleOrNull();
    return (row?.read(maxOrder) ?? -1) + 1;
  }

  Future<bool> hasActiveHabitWithName(String name, {String? excludeId}) async {
    final query = select(habits)
      ..where((habit) {
        final sameName = habit.name.equals(name);
        final active = habit.deletedAt.isNull();
        if (excludeId == null) {
          return sameName & active;
        }
        return sameName & active & habit.id.equals(excludeId).not();
      })
      ..limit(1);
    final result = await query.getSingleOrNull();
    return result != null;
  }

  Future<void> insertHabit(HabitsCompanion habit) {
    return into(habits).insert(habit);
  }

  Future<void> updateHabit(String id, HabitsCompanion habit) {
    return (update(habits)..where((table) => table.id.equals(id))).write(habit);
  }

  Future<void> softDeleteHabit(String id, DateTime deletedAt) {
    return (update(habits)..where((table) => table.id.equals(id))).write(
      HabitsCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }

  Future<void> updateTotalCheckInCount(String habitId, int count) {
    final now = DateTime.now();
    return (update(habits)..where((table) => table.id.equals(habitId))).write(
      HabitsCompanion(
        totalCheckInCount: Value(count),
        updatedAt: Value(now),
      ),
    );
  }
}

@DriftAccessor(tables: [CheckInRecords])
class CheckInDao extends DatabaseAccessor<AppDatabase>
    with _$CheckInDaoMixin {
  CheckInDao(super.db);

  Stream<List<CheckInRecord>> watchRecordsForDate(String date) {
    return (select(checkInRecords)
          ..where((record) => record.checkInDate.equals(date)))
        .watch();
  }

  Future<List<CheckInRecord>> getRecordsByHabitId(String habitId) {
    return (select(checkInRecords)
          ..where((record) => record.habitId.equals(habitId))
          ..orderBy([(record) => OrderingTerm.desc(record.checkInDate)]))
        .get();
  }

  Future<CheckInRecord?> getRecordByHabitAndDate(
    String habitId,
    String date,
  ) {
    return (select(checkInRecords)
          ..where(
            (record) =>
                record.habitId.equals(habitId) &
                record.checkInDate.equals(date),
          ))
        .getSingleOrNull();
  }

  Future<int> countByHabitId(String habitId) {
    final count = checkInRecords.id.count();
    final query = selectOnly(checkInRecords)
      ..addColumns([count])
      ..where(checkInRecords.habitId.equals(habitId));
    return query.map((row) => row.read(count) ?? 0).getSingle();
  }

  Future<void> insertRecord(CheckInRecordsCompanion record) {
    return into(checkInRecords).insert(
      record,
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<void> deleteRecord(String habitId, String date) {
    return (delete(checkInRecords)
          ..where(
            (record) =>
                record.habitId.equals(habitId) &
                record.checkInDate.equals(date),
          ))
        .go();
  }
}
