import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/database/app_database.dart';
import '../../../data/repositories/check_in_repository.dart';
import '../../../data/repositories/habit_repository.dart';
import '../../../domain/services/streak_calculator.dart';
import '../../../shared/utils/date_utils.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../../../shared/widgets/keepday_shell.dart';
import '../application/habit_detail_controller.dart';

class HabitDetailPage extends ConsumerWidget {
  const HabitDetailPage({required this.habitId, super.key});

  final String habitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitAsync = ref.watch(habitDetailProvider(habitId));
    final recordsAsync = ref.watch(habitRecordsProvider(habitId));
    final pausePeriodsAsync = ref.watch(habitPausePeriodsProvider(habitId));

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        leading: IconButton(
          tooltip: '返回',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
          icon: const Icon(Icons.arrow_back, color: keepdayPrimaryContainer),
        ),
        centerTitle: true,
        title: const Text(
          '习惯详情',
          style: TextStyle(
            color: keepdayPrimaryContainer,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.push('/habits/$habitId/edit'),
            child: const Text('编辑'),
          ),
        ],
      ),
      body: habitAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('加载失败：$error')),
        data: (habit) {
          if (habit == null || habit.deletedAt != null) {
            return const Center(child: Text('习惯不存在'));
          }
          final accent = habitReadableColor(habit.color);

          return recordsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(child: Text('加载失败：$error')),
            data: (records) {
              return pausePeriodsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) =>
                    Center(child: Text('加载失败：$error')),
                data: (pausePeriods) {
                  final calculator = const StreakCalculator();
                  final result = calculator.calculate(
                    createdAt: habit.createdAt,
                    gracePerWeek: habit.gracePerWeek,
                    checkInDates: records.map((record) => record.checkInDate),
                    pauseRanges: pausePeriods.map(
                      (period) => PauseRange(
                        startDate: period.startDate,
                        endDate: period.endDate,
                      ),
                    ),
                  );
                  final checkedToday =
                      result.dateStatuses[todayDateKey()] == DateStatus.checked;

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(16, 28, 16, 40),
                    children: [
                      _HabitHeader(habit: habit, accent: accent),
                      const SizedBox(height: 28),
                      _StatsGrid(stats: result.stats, accent: accent),
                      const SizedBox(height: 28),
                      _CalendarCard(
                        habit: habit,
                        statuses: result.dateStatuses,
                        accent: accent,
                        onDateTap: (date) => _handleDateTap(
                          context,
                          ref,
                          habit,
                          records,
                          result.dateStatuses,
                          date,
                        ),
                      ),
                      const SizedBox(height: 28),
                      _HeatmapCard(
                        habit: habit,
                        statuses: result.dateStatuses,
                        accent: accent,
                      ),
                      const SizedBox(height: 28),
                      FilledButton.icon(
                        onPressed: () =>
                            _toggleToday(context, ref, checkedToday),
                        icon: Icon(checkedToday ? Icons.undo : Icons.check),
                        label: Text(checkedToday ? '取消今日打卡' : '今日打卡'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () => _togglePause(context, ref, habit),
                        icon: Icon(
                          habit.status == 'paused'
                              ? Icons.play_circle_outline
                              : Icons.pause_circle_outline,
                        ),
                        label: Text(habit.status == 'paused' ? '恢复习惯' : '暂停习惯'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: keepdaySecondary,
                          side: BorderSide(
                            color: keepdaySecondary.withValues(alpha: 0.28),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () => _delete(context, ref),
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('删除习惯'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: keepdayDanger,
                          side: BorderSide(
                            color: keepdayDanger.withValues(alpha: 0.16),
                          ),
                          backgroundColor: keepdayDanger.withValues(
                            alpha: 0.05,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _handleDateTap(
    BuildContext context,
    WidgetRef ref,
    Habit habit,
    List<CheckInRecord> records,
    Map<String, DateStatus> statuses,
    DateTime date,
  ) async {
    final calculator = const StreakCalculator();
    final status = calculator.resolveDateStatus(
      date: date,
      createdAt: habit.createdAt,
      statuses: statuses,
    );
    final key = localDateKey(date);
    if (status == DateStatus.beforeCreated || status == DateStatus.future) {
      AppToast.show(context, '该日期不可操作');
      return;
    }

    try {
      final hasRecord = records.any((record) => record.checkInDate == key);
      if (hasRecord) {
        final confirmed = await showConfirmDialog(
          context,
          title: '取消打卡',
          message: '确认取消 ${humanDateLabel(date)} 的打卡记录吗？',
          confirmLabel: '取消打卡',
          destructive: true,
        );
        if (!confirmed) {
          return;
        }
        await ref.read(checkInRepositoryProvider).cancelCheckIn(habit.id, key);
      } else {
        await ref.read(checkInRepositoryProvider).checkInDate(habit.id, key);
      }
      ref.invalidate(habitDetailProvider(habitId));
      ref.invalidate(habitRecordsProvider(habitId));
      ref.invalidate(habitPausePeriodsProvider(habitId));
    } catch (error) {
      if (context.mounted) {
        AppToast.show(context, '操作失败：$error');
      }
    }
  }

  Future<void> _toggleToday(
    BuildContext context,
    WidgetRef ref,
    bool checkedToday,
  ) async {
    final repository = ref.read(checkInRepositoryProvider);
    try {
      if (checkedToday) {
        final confirmed = await showConfirmDialog(
          context,
          title: '取消今日打卡',
          message: '确认取消今天的打卡记录吗？',
          confirmLabel: '取消打卡',
          destructive: true,
        );
        if (!confirmed) {
          return;
        }
        await repository.cancelTodayCheckIn(habitId);
      } else {
        await repository.checkInToday(habitId);
      }
      ref.invalidate(habitDetailProvider(habitId));
      ref.invalidate(habitRecordsProvider(habitId));
      ref.invalidate(habitPausePeriodsProvider(habitId));
    } catch (error) {
      if (context.mounted) {
        AppToast.show(context, '操作失败：$error');
      }
    }
  }

  Future<void> _togglePause(
    BuildContext context,
    WidgetRef ref,
    Habit habit,
  ) async {
    final repository = ref.read(habitRepositoryProvider);
    try {
      if (habit.status == 'paused') {
        await repository.resumeHabit(habit.id);
      } else {
        final confirmed = await showConfirmDialog(
          context,
          title: '暂停习惯',
          message: '暂停后该习惯会移入首页暂停区，暂停期间不消耗宽限。',
          confirmLabel: '暂停',
        );
        if (!confirmed) {
          return;
        }
        await repository.pauseHabit(habit.id);
      }
      ref.invalidate(habitDetailProvider(habitId));
      ref.invalidate(habitRecordsProvider(habitId));
      ref.invalidate(habitPausePeriodsProvider(habitId));
    } catch (error) {
      if (context.mounted) {
        AppToast.show(context, '操作失败：$error');
      }
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context,
      title: '删除习惯',
      message: '删除后该习惯不会再展示，确认删除吗？',
      confirmLabel: '删除',
      destructive: true,
    );
    if (!confirmed) {
      return;
    }

    try {
      await ref.read(habitRepositoryProvider).softDeleteHabit(habitId);
      if (context.mounted) {
        context.go('/');
      }
    } catch (error) {
      if (context.mounted) {
        AppToast.show(context, '删除失败：$error');
      }
    }
  }
}

class _HabitHeader extends StatelessWidget {
  const _HabitHeader({required this.habit, required this.accent});

  final Habit habit;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        KeepDayHabitIcon(
          icon: habit.icon,
          size: 80,
          background: habitSoftColor(habit.color),
        ),
        const SizedBox(height: 12),
        Text(
          habit.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            height: 1.1,
            fontWeight: FontWeight.w800,
          ).copyWith(color: accent),
        ),
        const SizedBox(height: 4),
        Text(
          habit.status == 'paused'
              ? '已暂停 · 创建于 ${humanDateLabel(habit.createdAt)}'
              : '创建于 ${humanDateLabel(habit.createdAt)}',
          style: const TextStyle(color: keepdayMuted, fontSize: 14),
        ),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.stats, required this.accent});

  final HabitStats stats;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _StatTile(
          label: '持续天数',
          value: stats.durationDays.toString(),
          accent: accent,
        ),
        _StatTile(
          label: '累计打卡',
          value: stats.totalCheckInCount.toString(),
          accent: accent,
        ),
        _StatTile(
          label: '最佳连续',
          value: stats.bestStreak.toString(),
          accent: accent,
        ),
        _StatTile(
          label: '当前连续',
          value: stats.currentStreak.toString(),
          accent: keepdaySecondary,
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    this.accent = keepdayPrimary,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return KeepDayCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: keepdayMuted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: accent,
              fontSize: 28,
              height: 1.1,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarCard extends StatefulWidget {
  const _CalendarCard({
    required this.habit,
    required this.statuses,
    required this.accent,
    required this.onDateTap,
  });

  final Habit habit;
  final Map<String, DateStatus> statuses;
  final Color accent;
  final ValueChanged<DateTime> onDateTap;

  @override
  State<_CalendarCard> createState() => _CalendarCardState();
}

class _CalendarCardState extends State<_CalendarCard> {
  late DateTime _visibleMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _visibleMonth = DateTime(now.year, now.month);
  }

  void _goPrevious() {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
    });
  }

  void _goNext() {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
    });
  }

  void _handleSwipe(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity < -240) {
      _goNext();
    } else if (velocity > 240) {
      _goPrevious();
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final monthStart = _visibleMonth;
    final daysInMonth = DateTime(
      _visibleMonth.year,
      _visibleMonth.month + 1,
      0,
    ).day;
    final leading = monthStart.weekday - 1;
    final calculator = const StreakCalculator();

    return KeepDayCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${_visibleMonth.year}年${_visibleMonth.month}月',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: '上个月',
                onPressed: _goPrevious,
                icon: const Icon(Icons.chevron_left),
              ),
              IconButton(
                tooltip: '下个月',
                onPressed: _goNext,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragEnd: _handleSwipe,
            child: GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 8,
              children: [
                for (final day in ['一', '二', '三', '四', '五', '六', '日'])
                  Center(
                    child: Text(
                      day,
                      style: const TextStyle(
                        color: keepdayMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                for (var i = 0; i < leading; i++) const SizedBox.shrink(),
                for (var day = 1; day <= daysInMonth; day++)
                  Builder(
                    builder: (context) {
                      final date = DateTime(
                        _visibleMonth.year,
                        _visibleMonth.month,
                        day,
                      );
                      final status = calculator.resolveDateStatus(
                        date: date,
                        createdAt: widget.habit.createdAt,
                        statuses: widget.statuses,
                      );
                      return _CalendarDay(
                        day: day,
                        status: status,
                        accent: widget.accent,
                        today: isSameLocalDate(date, now),
                        onTap: () => widget.onDateTap(date),
                      );
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              _Legend(color: widget.accent, label: '已打卡'),
              const _Legend(color: Color(0xFFD78A1F), label: '宽限'),
              const _Legend(color: keepdayLine, label: '暂停'),
              const _Legend(color: Color(0xFFE8EDF0), label: '未打卡'),
            ],
          ),
        ],
      ),
    );
  }
}

class _CalendarDay extends StatelessWidget {
  const _CalendarDay({
    required this.day,
    required this.status,
    required this.accent,
    required this.today,
    required this.onTap,
  });

  final int day;
  final DateStatus status;
  final Color accent;
  final bool today;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final disabled =
        status == DateStatus.beforeCreated || status == DateStatus.future;
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: disabled ? null : onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: _statusColor(status, accent),
            borderRadius: BorderRadius.circular(4),
            border: today ? Border.all(color: accent, width: 2) : null,
          ),
          alignment: Alignment.center,
          child: Text(
            '$day',
            style: TextStyle(
              color: _statusTextColor(status),
              fontSize: 14,
              fontWeight: today ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
            border: Border.all(
              color: color == keepdayLine ? keepdayMuted : color,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: keepdayMuted, fontSize: 11)),
      ],
    );
  }
}

class _HeatmapCard extends StatefulWidget {
  const _HeatmapCard({
    required this.habit,
    required this.statuses,
    required this.accent,
  });

  final Habit habit;
  final Map<String, DateStatus> statuses;
  final Color accent;

  @override
  State<_HeatmapCard> createState() => _HeatmapCardState();
}

class _HeatmapCardState extends State<_HeatmapCard> {
  late int _year;

  @override
  void initState() {
    super.initState();
    _year = DateTime.now().year;
  }

  void _goPreviousYear() {
    setState(() => _year -= 1);
  }

  void _goNextYear() {
    setState(() => _year += 1);
  }

  @override
  Widget build(BuildContext context) {
    final calculator = const StreakCalculator();
    final yearStart = DateTime(_year);
    final firstCellDate = yearStart.subtract(
      Duration(days: yearStart.weekday - DateTime.monday),
    );
    return KeepDayCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  '年度完成热力图',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                tooltip: '上一年',
                onPressed: _goPreviousYear,
                icon: const Icon(Icons.chevron_left),
              ),
              Text(
                '$_year',
                style: const TextStyle(
                  color: keepdayText,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              IconButton(
                tooltip: '下一年',
                onPressed: _goNextYear,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _HeatmapWeekdayLabels(),
              const SizedBox(width: 8),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: _heatmapColumnCount * _heatmapColumnWidth,
                        child: SizedBox.shrink(),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var row = 0; row < 7; row++)
                            Row(
                              children: [
                                for (
                                  var col = 0;
                                  col < _heatmapColumnCount;
                                  col++
                                )
                                  Builder(
                                    builder: (context) {
                                      final date = firstCellDate.add(
                                        Duration(days: col * 7 + row),
                                      );
                                      final status = date.year == _year
                                          ? calculator.resolveDateStatus(
                                              date: date,
                                              createdAt: widget.habit.createdAt,
                                              statuses: widget.statuses,
                                            )
                                          : DateStatus.beforeCreated;
                                      return _HeatmapCell(
                                        color: _statusColor(
                                          status,
                                          widget.accent,
                                        ),
                                        outlined:
                                            status ==
                                                DateStatus.beforeCreated ||
                                            status == DateStatus.future,
                                      );
                                    },
                                  ),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      _HeatmapMonthLabels(
                        firstCellDate: firstCellDate,
                        year: _year,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeatmapWeekdayLabels extends StatelessWidget {
  const _HeatmapWeekdayLabels();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final label in ['周一', '周二', '周三', '周四', '周五', '周六', '周日'])
          SizedBox(
            height: 16,
            child: Text(
              label,
              style: const TextStyle(color: keepdayMuted, fontSize: 10),
            ),
          ),
      ],
    );
  }
}

class _HeatmapMonthLabels extends StatelessWidget {
  const _HeatmapMonthLabels({required this.firstCellDate, required this.year});

  final DateTime firstCellDate;
  final int year;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _heatmapColumnCount * _heatmapColumnWidth,
      height: 14,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var month = 1; month <= 12; month++)
            Positioned(
              left:
                  (DateTime(year, month).difference(firstCellDate).inDays ~/
                      7) *
                  _heatmapColumnWidth,
              top: 0,
              child: Text(
                '$month月',
                style: const TextStyle(color: keepdayMuted, fontSize: 10),
              ),
            ),
        ],
      ),
    );
  }
}

class _HeatmapCell extends StatelessWidget {
  const _HeatmapCell({required this.color, required this.outlined});

  final Color color;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
        border: outlined ? Border.all(color: keepdayLine, width: 0.7) : null,
      ),
    );
  }
}

const int _heatmapColumnCount = 53;
const double _heatmapColumnWidth = 16;

Color _statusColor(DateStatus status, Color accent) {
  return switch (status) {
    DateStatus.checked => accent,
    DateStatus.checkedDuringPause => accent.withValues(alpha: 0.48),
    DateStatus.grace => const Color(0xFFD78A1F).withValues(alpha: 0.34),
    DateStatus.paused => keepdayLine,
    DateStatus.missed => const Color(0xFFE8EDF0),
    DateStatus.future || DateStatus.beforeCreated => const Color(0xFFF6F8F7),
  };
}

Color _statusTextColor(DateStatus status) {
  return switch (status) {
    DateStatus.checked => Colors.white,
    DateStatus.checkedDuringPause => Colors.white,
    DateStatus.beforeCreated || DateStatus.future => keepdayMuted,
    _ => keepdayText,
  };
}
