import 'package:flutter_test/flutter_test.dart';
import 'package:keepday/domain/services/streak_calculator.dart';

void main() {
  const calculator = StreakCalculator();

  test('grace is assigned from early to late dates in a natural week', () {
    final result = calculator.calculate(
      createdAt: DateTime(2026, 5, 25),
      gracePerWeek: 1,
      checkInDates: const ['2026-05-25', '2026-05-28'],
      pauseRanges: const [],
      today: DateTime(2026, 5, 29),
    );

    expect(result.dateStatuses['2026-05-26'], DateStatus.grace);
    expect(result.dateStatuses['2026-05-27'], DateStatus.missed);
    expect(result.stats.totalCheckInCount, 2);
    expect(result.stats.bestStreak, 2);
    expect(result.stats.currentStreak, 0);
  });

  test('today grace does not count into current streak', () {
    final result = calculator.calculate(
      createdAt: DateTime(2026, 5, 25),
      gracePerWeek: 1,
      checkInDates: const ['2026-05-25', '2026-05-26'],
      pauseRanges: const [],
      today: DateTime(2026, 5, 27),
    );

    expect(result.dateStatuses['2026-05-27'], DateStatus.grace);
    expect(result.stats.bestStreak, 2);
    expect(result.stats.currentStreak, 2);
  });

  test('pause days do not consume grace and do not break streak', () {
    final result = calculator.calculate(
      createdAt: DateTime(2026, 5, 25),
      gracePerWeek: 1,
      checkInDates: const ['2026-05-25', '2026-05-26', '2026-05-29'],
      pauseRanges: const [
        PauseRange(startDate: '2026-05-27', endDate: '2026-05-29'),
      ],
      today: DateTime(2026, 5, 29),
    );

    expect(result.dateStatuses['2026-05-27'], DateStatus.paused);
    expect(result.dateStatuses['2026-05-28'], DateStatus.paused);
    expect(result.dateStatuses['2026-05-29'], DateStatus.checked);
    expect(result.stats.currentStreak, 3);
    expect(result.stats.bestStreak, 3);
  });

  test('check-in during pause counts total but not streak', () {
    final result = calculator.calculate(
      createdAt: DateTime(2026, 5, 25),
      gracePerWeek: 1,
      checkInDates: const [
        '2026-05-25',
        '2026-05-26',
        '2026-05-27',
        '2026-05-29',
      ],
      pauseRanges: const [
        PauseRange(startDate: '2026-05-27', endDate: '2026-05-29'),
      ],
      today: DateTime(2026, 5, 29),
    );

    expect(result.dateStatuses['2026-05-27'], DateStatus.checkedDuringPause);
    expect(result.stats.totalCheckInCount, 4);
    expect(result.stats.currentStreak, 3);
    expect(result.stats.bestStreak, 3);
  });

  test('creation week starts at created date', () {
    final result = calculator.calculate(
      createdAt: DateTime(2026, 5, 27),
      gracePerWeek: 2,
      checkInDates: const [],
      pauseRanges: const [],
      today: DateTime(2026, 5, 29),
    );

    expect(result.dateStatuses['2026-05-25'], isNull);
    expect(result.dateStatuses['2026-05-27'], DateStatus.grace);
    expect(result.dateStatuses['2026-05-28'], DateStatus.grace);
    expect(result.dateStatuses['2026-05-29'], DateStatus.missed);
  });
}
