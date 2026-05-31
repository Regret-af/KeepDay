import '../../shared/utils/date_utils.dart';

enum DateStatus {
  checked,
  checkedDuringPause,
  grace,
  missed,
  paused,
  future,
  beforeCreated,
}

enum HomeHabitStatus { notChecked, checked, resting, paused }

class HabitStats {
  const HabitStats({
    required this.durationDays,
    required this.totalCheckInCount,
    required this.bestStreak,
    required this.currentStreak,
  });

  final int durationDays;
  final int totalCheckInCount;
  final int bestStreak;
  final int currentStreak;
}

class PauseRange {
  const PauseRange({required this.startDate, this.endDate});

  final String startDate;
  final String? endDate;
}

class StreakResult {
  const StreakResult({required this.stats, required this.dateStatuses});

  final HabitStats stats;
  final Map<String, DateStatus> dateStatuses;
}

class StreakCalculator {
  const StreakCalculator();

  StreakResult calculate({
    required DateTime createdAt,
    required int gracePerWeek,
    required Iterable<String> checkInDates,
    required Iterable<PauseRange> pauseRanges,
    DateTime? today,
  }) {
    final createdDate = localDateOnly(createdAt);
    final todayDate = localDateOnly(today ?? DateTime.now());
    final checked = checkInDates.toSet();
    final ranges = pauseRanges.toList();
    final statuses = <String, DateStatus>{};
    final weekGraceUsage = <String, int>{};

    if (todayDate.isBefore(createdDate)) {
      return const StreakResult(
        stats: HabitStats(
          durationDays: 0,
          totalCheckInCount: 0,
          bestStreak: 0,
          currentStreak: 0,
        ),
        dateStatuses: {},
      );
    }

    for (
      var date = createdDate;
      !date.isAfter(todayDate);
      date = date.add(const Duration(days: 1))
    ) {
      final key = localDateKey(date);
      final isChecked = checked.contains(key);
      final isPaused = _isPaused(date, ranges);
      if (isPaused && isChecked) {
        statuses[key] = DateStatus.checkedDuringPause;
      } else if (isChecked) {
        statuses[key] = DateStatus.checked;
      } else if (isPaused) {
        statuses[key] = DateStatus.paused;
      } else {
        final weekKey = localDateKey(_weekStart(date));
        final used = weekGraceUsage[weekKey] ?? 0;
        if (used < gracePerWeek) {
          statuses[key] = DateStatus.grace;
          weekGraceUsage[weekKey] = used + 1;
        } else {
          statuses[key] = DateStatus.missed;
        }
      }
    }

    final bestStreak = _bestStreak(createdDate, todayDate, statuses);
    final currentStreak = _currentStreak(createdDate, todayDate, statuses);

    return StreakResult(
      stats: HabitStats(
        durationDays: todayDate.difference(createdDate).inDays + 1,
        totalCheckInCount: checked.length,
        bestStreak: bestStreak,
        currentStreak: currentStreak,
      ),
      dateStatuses: statuses,
    );
  }

  DateStatus resolveDateStatus({
    required DateTime date,
    required DateTime createdAt,
    required Map<String, DateStatus> statuses,
    DateTime? today,
  }) {
    final localDate = localDateOnly(date);
    final createdDate = localDateOnly(createdAt);
    final todayDate = localDateOnly(today ?? DateTime.now());
    if (localDate.isAfter(todayDate)) {
      return DateStatus.future;
    }
    if (localDate.isBefore(createdDate)) {
      return DateStatus.beforeCreated;
    }
    return statuses[localDateKey(localDate)] ?? DateStatus.missed;
  }

  HomeHabitStatus resolveHomeStatus({
    required String habitStatus,
    required DateTime createdAt,
    required Map<String, DateStatus> statuses,
    DateTime? today,
  }) {
    if (habitStatus == 'paused') {
      return HomeHabitStatus.paused;
    }
    final todayStatus = resolveDateStatus(
      date: today ?? DateTime.now(),
      createdAt: createdAt,
      statuses: statuses,
      today: today,
    );
    return switch (todayStatus) {
      DateStatus.checked ||
      DateStatus.checkedDuringPause => HomeHabitStatus.checked,
      DateStatus.grace => HomeHabitStatus.resting,
      _ => HomeHabitStatus.notChecked,
    };
  }

  int _bestStreak(
    DateTime createdDate,
    DateTime todayDate,
    Map<String, DateStatus> statuses,
  ) {
    var best = 0;
    var current = 0;
    for (
      var date = createdDate;
      !date.isAfter(todayDate);
      date = date.add(const Duration(days: 1))
    ) {
      final status = statuses[localDateKey(date)];
      if (_countsForHistoricalStreak(status, date, todayDate)) {
        current += 1;
        if (current > best) {
          best = current;
        }
      } else if (status == DateStatus.paused ||
          status == DateStatus.checkedDuringPause) {
        continue;
      } else {
        current = 0;
      }
    }
    return best;
  }

  int _currentStreak(
    DateTime createdDate,
    DateTime todayDate,
    Map<String, DateStatus> statuses,
  ) {
    final todayStatus = statuses[localDateKey(todayDate)];
    if (todayStatus == DateStatus.missed) {
      return 0;
    }

    var current = 0;
    for (
      var date = todayDate;
      !date.isBefore(createdDate);
      date = date.subtract(const Duration(days: 1))
    ) {
      final status = statuses[localDateKey(date)];
      if (status == DateStatus.checked) {
        current += 1;
      } else if (status == DateStatus.grace) {
        if (!isSameLocalDate(date, todayDate)) {
          current += 1;
        }
      } else if (status == DateStatus.paused ||
          status == DateStatus.checkedDuringPause) {
        continue;
      } else {
        break;
      }
    }
    return current;
  }

  bool _countsForHistoricalStreak(
    DateStatus? status,
    DateTime date,
    DateTime today,
  ) {
    if (status == DateStatus.checked) {
      return true;
    }
    if (status == DateStatus.grace && !isSameLocalDate(date, today)) {
      return true;
    }
    return false;
  }

  bool _isPaused(DateTime date, List<PauseRange> ranges) {
    for (final range in ranges) {
      final start = parseLocalDateKey(range.startDate);
      final end = range.endDate == null
          ? null
          : parseLocalDateKey(range.endDate!);
      if (date.isBefore(start)) {
        continue;
      }
      if (end == null || date.isBefore(end)) {
        return true;
      }
    }
    return false;
  }

  DateTime _weekStart(DateTime date) {
    return date.subtract(Duration(days: date.weekday - DateTime.monday));
  }
}
