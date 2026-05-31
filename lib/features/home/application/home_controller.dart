import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/app_database.dart';
import '../../../data/repositories/check_in_repository.dart';
import '../../../data/repositories/habit_repository.dart';

final activeHabitsProvider = StreamProvider<List<Habit>>((ref) {
  return ref.watch(habitRepositoryProvider).watchActiveHabits();
});

final todayCheckInsProvider = StreamProvider<List<CheckInRecord>>((ref) {
  return ref.watch(checkInRepositoryProvider).watchTodayRecords();
});

final checkInsProvider = StreamProvider<List<CheckInRecord>>((ref) {
  return ref.watch(checkInRepositoryProvider).watchRecords();
});

final pausePeriodsProvider = StreamProvider<List<HabitPausePeriod>>((ref) {
  return ref.watch(habitRepositoryProvider).watchPausePeriods();
});
