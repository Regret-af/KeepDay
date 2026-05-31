import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/database/app_database.dart';
import '../../../data/repositories/check_in_repository.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../../../shared/widgets/keepday_shell.dart';
import '../application/home_controller.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(activeHabitsProvider);
    final todayRecordsAsync = ref.watch(todayCheckInsProvider);

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
                final todayRecords = todayRecordsAsync.value ?? const [];
                final checkedIds = todayRecords
                    .map((record) => record.habitId)
                    .toSet();
                final sortedHabits = [...habits]
                  ..sort((a, b) {
                    final aChecked = checkedIds.contains(a.id);
                    final bChecked = checkedIds.contains(b.id);
                    if (aChecked != bChecked) {
                      return aChecked ? 1 : -1;
                    }
                    return a.createdAt.compareTo(b.createdAt);
                  });
                final completed = habits
                    .where((habit) => checkedIds.contains(habit.id))
                    .length;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ProgressCard(completed: completed, total: habits.length),
                    const SizedBox(height: 14),
                    if (habits.isEmpty)
                      const _EmptyHabitsCard()
                    else
                      for (final habit in sortedHabits) ...[
                        _HabitCard(
                          habit: habit,
                          checkedToday: checkedIds.contains(habit.id),
                        ),
                        const SizedBox(height: 12),
                      ],
                    const SizedBox(height: 18),
                    const _PausedHabitsPlaceholder(),
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
  const _ProgressCard({required this.completed, required this.total});

  final int completed;
  final int total;

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
                    ? '创建第一个习惯，开始记录今天。'
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

class _HabitCard extends ConsumerWidget {
  const _HabitCard({required this.habit, required this.checkedToday});

  final Habit habit;
  final bool checkedToday;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accent = habitReadableColor(habit.color);
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
                      '累计 ${habit.totalCheckInCount} 次',
                      style: const TextStyle(color: keepdayMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
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

class _PausedHabitsPlaceholder extends StatelessWidget {
  const _PausedHabitsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      iconColor: keepdayMuted,
      collapsedIconColor: keepdayMuted,
      title: const Text(
        '已阶段性暂停的习惯',
        style: TextStyle(
          color: keepdayMuted,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      children: const [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              '暂停与恢复将在 V0.2 接入。',
              style: TextStyle(color: keepdayMuted),
            ),
          ),
        ),
      ],
    );
  }
}
