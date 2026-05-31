import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/database/app_database.dart';
import '../../../data/repositories/check_in_repository.dart';
import '../../../data/repositories/habit_repository.dart';
import '../../../domain/services/streak_calculator.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../../../shared/widgets/keepday_shell.dart';
import '../application/home_controller.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(activeHabitsProvider);
    final recordsAsync = ref.watch(checkInsProvider);
    final pausePeriodsAsync = ref.watch(pausePeriodsProvider);

    return Scaffold(
      appBar: KeepDayTopBar(
        title: AppConstants.appName,
        actions: [
          IconButton(
            tooltip: '创建习惯',
            onPressed: () => context.push('/habits/new'),
            icon: const Icon(Icons.add, color: keepdayText),
          ),
          IconButton(
            tooltip: '设置',
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings_outlined, color: keepdayText),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: '创建习惯',
        onPressed: () => context.push('/habits/new'),
        backgroundColor: keepdayPrimary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const KeepDayBottomNav(active: 'habits'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 104),
          children: [
            Text(
              _homeDateLabel(DateTime.now()),
              style: const TextStyle(
                fontSize: 28,
                height: 1.1,
                fontWeight: FontWeight.w800,
                color: keepdayText,
              ),
            ),
            const SizedBox(height: 14),
            _NotificationBanner(),
            const SizedBox(height: 14),
            habitsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  KeepDayCard(child: Text('加载失败：$error')),
              data: (habits) {
                final records = recordsAsync.value ?? const [];
                final pausePeriods = pausePeriodsAsync.value ?? const [];
                final items = habits
                    .map(
                      (habit) => _HomeHabitItem.from(
                        habit: habit,
                        records: records
                            .where((record) => record.habitId == habit.id)
                            .toList(),
                        pausePeriods: pausePeriods
                            .where((period) => period.habitId == habit.id)
                            .toList(),
                      ),
                    )
                    .toList();
                final normalItems =
                    items
                        .where(
                          (item) => item.homeStatus != HomeHabitStatus.paused,
                        )
                        .toList()
                      ..sort((a, b) {
                        final statusCompare =
                            _homeStatusOrder(a.homeStatus) -
                            _homeStatusOrder(b.homeStatus);
                        if (statusCompare != 0) {
                          return statusCompare;
                        }
                        return a.habit.createdAt.compareTo(b.habit.createdAt);
                      });
                final pausedItems = items
                    .where((item) => item.homeStatus == HomeHabitStatus.paused)
                    .toList();
                final completed = normalItems
                    .where((item) => item.homeStatus == HomeHabitStatus.checked)
                    .length;
                final resting = normalItems
                    .where((item) => item.homeStatus == HomeHabitStatus.resting)
                    .length;
                final total = normalItems.length - resting;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ProgressCard(
                      completed: completed,
                      total: total,
                      resting: resting,
                    ),
                    const SizedBox(height: 14),
                    if (habits.isEmpty)
                      const _EmptyHabitsCard()
                    else if (normalItems.isEmpty)
                      const _AllPausedCard()
                    else
                      for (final item in normalItems) ...[
                        _HabitCard(item: item),
                        const SizedBox(height: 12),
                      ],
                    const SizedBox(height: 18),
                    _PausedHabitsSection(items: pausedItems),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _homeDateLabel(DateTime date) {
    const weekdays = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];
    return '${date.month} 月 ${date.day} 日，${weekdays[date.weekday - 1]}';
  }
}

class _HomeHabitItem {
  const _HomeHabitItem({
    required this.habit,
    required this.homeStatus,
    required this.stats,
  });

  factory _HomeHabitItem.from({
    required Habit habit,
    required List<CheckInRecord> records,
    required List<HabitPausePeriod> pausePeriods,
  }) {
    final calculator = const StreakCalculator();
    final result = calculator.calculate(
      createdAt: habit.createdAt,
      gracePerWeek: habit.gracePerWeek,
      checkInDates: records.map((record) => record.checkInDate),
      pauseRanges: pausePeriods.map(
        (period) =>
            PauseRange(startDate: period.startDate, endDate: period.endDate),
      ),
    );
    return _HomeHabitItem(
      habit: habit,
      homeStatus: calculator.resolveHomeStatus(
        habitStatus: habit.status,
        createdAt: habit.createdAt,
        statuses: result.dateStatuses,
      ),
      stats: result.stats,
    );
  }

  final Habit habit;
  final HomeHabitStatus homeStatus;
  final HabitStats stats;
}

int _homeStatusOrder(HomeHabitStatus status) {
  return switch (status) {
    HomeHabitStatus.notChecked => 0,
    HomeHabitStatus.resting => 1,
    HomeHabitStatus.checked => 2,
    HomeHabitStatus.paused => 3,
  };
}

class _NotificationBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: keepdaySecondary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: keepdaySecondary.withValues(alpha: 0.16)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.notifications_off_outlined, color: keepdaySecondary),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '通知未开启，可能无法按时提醒你打卡',
              style: TextStyle(
                color: Color(0xFF6D4100),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.completed,
    required this.total,
    required this.resting,
  });

  final int completed;
  final int total;
  final int resting;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : completed / total;
    return KeepDayCard(
      padding: const EdgeInsets.all(24),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Expanded(
                    child: Text(
                      '今日进度',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    '$completed/$total',
                    style: const TextStyle(
                      color: keepdayPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  minHeight: 6,
                  value: progress,
                  backgroundColor: keepdaySurfaceSoft,
                  valueColor: const AlwaysStoppedAnimation(keepdayPrimary),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                total == 0
                    ? resting > 0
                          ? '今天有 $resting 个习惯处于宽限休息中。'
                          : '创建第一个习惯，开始记录今天。'
                    : completed == total
                    ? '今天的习惯都完成了。'
                    : '坚持就是胜利，还剩 ${total - completed} 个习惯待完成。',
                style: const TextStyle(color: keepdayMuted, fontSize: 12),
              ),
            ],
          ),
          const Positioned(
            right: -18,
            top: -22,
            child: Opacity(
              opacity: 0.04,
              child: Icon(Icons.auto_awesome, size: 120, color: keepdayText),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHabitsCard extends StatelessWidget {
  const _EmptyHabitsCard();

  @override
  Widget build(BuildContext context) {
    return KeepDayCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '还没有习惯',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            '创建第一个习惯后，就可以在首页一键打卡。',
            style: TextStyle(color: keepdayMuted),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => context.push('/habits/new'),
            icon: const Icon(Icons.add),
            label: const Text('创建习惯'),
          ),
        ],
      ),
    );
  }
}

class _AllPausedCard extends StatelessWidget {
  const _AllPausedCard();

  @override
  Widget build(BuildContext context) {
    return const KeepDayCard(
      child: Text(
        '当前习惯都处于暂停中，可以在下方展开查看并恢复。',
        style: TextStyle(color: keepdayMuted),
      ),
    );
  }
}

class _HabitCard extends ConsumerWidget {
  const _HabitCard({required this.item});

  final _HomeHabitItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habit = item.habit;
    final accent = habitReadableColor(habit.color);
    final checkedToday = item.homeStatus == HomeHabitStatus.checked;
    final resting = item.homeStatus == HomeHabitStatus.resting;
    return KeepDayCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: () => context.push('/habits/${habit.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 44,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(width: 12),
              KeepDayHabitIcon(
                icon: habit.icon,
                background: habitSoftColor(habit.color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '连续 ${item.stats.currentStreak} 天 · 累计 ${item.stats.totalCheckInCount} 次',
                      style: const TextStyle(color: keepdayMuted, fontSize: 12),
                    ),
                    if (habit.reminderEnabled && habit.reminderTime != null)
                      Text(
                        '提醒 ${habit.reminderTime}',
                        style: const TextStyle(
                          color: keepdayMuted,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              if (resting)
                _RestingBadge(accent: accent)
              else
                KeepDayStatusRing(
                  checked: checkedToday,
                  checkedColor: accent,
                  onTap: () => _toggle(context, ref),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _toggle(BuildContext context, WidgetRef ref) async {
    final repository = ref.read(checkInRepositoryProvider);
    final habit = item.habit;
    final checkedToday = item.homeStatus == HomeHabitStatus.checked;
    try {
      if (checkedToday) {
        final confirmed = await showConfirmDialog(
          context,
          title: '取消今日打卡',
          message: '确认取消“${habit.name}”今天的打卡记录吗？',
          confirmLabel: '取消打卡',
          destructive: true,
        );
        if (!confirmed) {
          return;
        }
        await repository.cancelTodayCheckIn(habit.id);
      } else {
        await repository.checkInToday(habit.id);
      }
    } catch (error) {
      if (context.mounted) {
        AppToast.show(context, '操作失败：$error');
      }
    }
  }
}

class _RestingBadge extends StatelessWidget {
  const _RestingBadge({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '休息中',
        style: TextStyle(
          color: accent,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PausedHabitsSection extends ConsumerWidget {
  const _PausedHabitsSection({required this.items});

  final List<_HomeHabitItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    return ExpansionTile(
      initiallyExpanded: true,
      tilePadding: EdgeInsets.zero,
      iconColor: keepdayMuted,
      collapsedIconColor: keepdayMuted,
      title: Text(
        '已暂停的习惯 (${items.length})',
        style: const TextStyle(
          color: keepdayMuted,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: KeepDayCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => context.push('/habits/${item.habit.id}'),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            KeepDayHabitIcon(
                              icon: item.habit.icon,
                              background: habitSoftColor(item.habit.color),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item.habit.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      try {
                        await ref
                            .read(habitRepositoryProvider)
                            .resumeHabit(item.habit.id);
                      } catch (error) {
                        if (context.mounted) {
                          AppToast.show(context, '恢复失败：$error');
                        }
                      }
                    },
                    child: const Text('恢复'),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
