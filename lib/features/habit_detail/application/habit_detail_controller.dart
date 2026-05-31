import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/app_database.dart';
import '../../../data/repositories/check_in_repository.dart';
import '../../../data/repositories/habit_repository.dart';

final habitDetailProvider = StreamProvider.family<Habit?, String>((
  ref,
  habitId,
) {
  return ref.watch(habitRepositoryProvider).watchHabitById(habitId);
});

final habitRecordsProvider = FutureProvider.family<List<CheckInRecord>, String>(
  (ref, habitId) {
    return ref.watch(checkInRepositoryProvider).getRecordsByHabitId(habitId);
  },
);
