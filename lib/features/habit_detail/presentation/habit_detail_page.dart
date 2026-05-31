import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/database/app_database.dart';
import '../../../data/repositories/check_in_repository.dart';
import '../../../data/repositories/habit_repository.dart';
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
              final checkedToday = records.any(
                (record) => record.checkInDate == todayDateKey(),
              );
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 28, 16, 40),
                children: [
                  _HabitHeader(habit: habit, accent: accent),
                  const SizedBox(height: 60),
                  _StatsGrid(habit: habit, accent: accent),
                  const SizedBox(height: 60),
                  _CalendarCard(records: records, accent: accent),
                  const SizedBox(height: 60),
                  _HeatmapCard(records: records, accent: accent),
                  const SizedBox(height: 28),
                  FilledButton.icon(
                    onPressed: () => _toggleToday(context, ref, checkedToday),
                    icon: Icon(checkedToday ? Icons.undo : Icons.check),
                    label: Text(checkedToday ? '取消今日打卡' : '今日打卡'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.pause_circle_outline),
                    label: const Text('暂停习惯'),
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
                      backgroundColor: keepdayDanger.withValues(alpha: 0.05),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
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
          '创建于 ${humanDateLabel(habit.createdAt)}',
          style: const TextStyle(color: keepdayMuted, fontSize: 14),
        ),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.habit, required this.accent});

  final Habit habit;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final durationDays =
        DateTime.now()
            .difference(
              DateTime(
                habit.createdAt.year,
                habit.createdAt.month,
                habit.createdAt.day,
              ),
            )
            .inDays +
        1;
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
          value: durationDays.toString(),
          accent: accent,
        ),
        _StatTile(
          label: '累计打卡',
          value: habit.totalCheckInCount.toString(),
          accent: accent,
        ),
        _StatTile(
          label: '最佳连续',
          value: habit.bestStreak.toString(),
          accent: accent,
        ),
        _StatTile(
          label: '当前连续',
          value: habit.currentStreak.toString(),
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

class _CalendarCard extends StatelessWidget {
  const _CalendarCard({required this.records, required this.accent});

  final List<CheckInRecord> records;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final leading = monthStart.weekday - 1;
    final checkedDates = records.map((record) => record.checkInDate).toSet();

    return KeepDayCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${now.year}年${now.month}月',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Icon(Icons.chevron_left, size: 18, color: keepdayMuted),
              const Icon(Icons.chevron_right, size: 18, color: keepdayMuted),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
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
                _CalendarDay(
                  day: day,
                  accent: accent,
                  checked: checkedDates.contains(
                    localDateKey(DateTime(now.year, now.month, day)),
                  ),
                  today: day == now.day,
                ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              _Legend(color: accent, label: '已打卡'),
              const _Legend(color: Color(0x55D78A1F), label: '宽限'),
              _Legend(outlined: true, color: accent, label: '今天'),
              const _Legend(color: keepdayLine, label: '未打卡'),
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
    required this.accent,
    required this.checked,
    required this.today,
  });

  final int day;
  final Color accent;
  final bool checked;
  final bool today;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: checked ? accent.withValues(alpha: 0.82) : null,
          borderRadius: BorderRadius.circular(4),
          border: today ? Border.all(color: accent, width: 2) : null,
        ),
        alignment: Alignment.center,
        child: Text(
          '$day',
          style: TextStyle(
            color: checked ? Colors.white : keepdayText,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({this.color, required this.label, this.outlined = false});

  final Color? color;
  final String label;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: outlined ? null : color,
            borderRadius: BorderRadius.circular(2),
            border: Border.all(
              color: outlined
                  ? (color ?? keepdayPrimary)
                  : (color ?? keepdayLine),
              width: outlined ? 2 : 1,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: keepdayMuted, fontSize: 11)),
      ],
    );
  }
}

class _HeatmapCard extends StatelessWidget {
  const _HeatmapCard({required this.records, required this.accent});

  final List<CheckInRecord> records;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final checked = records.map((record) => record.checkInDate).toSet();
    final today = DateTime.now();
    return KeepDayCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  '历程热力图',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                '近 12 个月',
                style: TextStyle(color: keepdayMuted, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var row = 0; row < 7; row++)
                  Row(
                    children: [
                      for (var col = 0; col < 52; col++)
                        _HeatmapCell(
                          accent: accent,
                          checked: checked.contains(
                            localDateKey(
                              today.subtract(
                                Duration(days: (51 - col) * 7 + (6 - row)),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeatmapCell extends StatelessWidget {
  const _HeatmapCell({required this.checked, required this.accent});

  final bool checked;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: checked ? accent : keepdayLine,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
