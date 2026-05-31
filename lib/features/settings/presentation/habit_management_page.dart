import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/database/app_database.dart';
import '../../../data/repositories/habit_repository.dart';
import '../../../features/home/application/home_controller.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../../../shared/widgets/keepday_shell.dart';

class HabitManagementPage extends ConsumerWidget {
  const HabitManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(activeHabitsProvider);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        leading: IconButton(
          tooltip: '返回',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/settings');
            }
          },
          icon: const Icon(Icons.arrow_back, color: keepdayPrimaryContainer),
        ),
        centerTitle: true,
        title: const Text(
          '习惯管理',
          style: TextStyle(
            color: keepdayPrimaryContainer,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      bottomNavigationBar: const KeepDayBottomNav(active: 'profile'),
      body: habitsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('加载失败：$error')),
        data: (habits) {
          if (habits.isEmpty) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 28, 16, 120),
              children: [
                KeepDayCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '还没有习惯',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '创建习惯后，可以在这里集中编辑、暂停、恢复或删除。',
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
                ),
              ],
            );
          }

          final normalHabits = habits
              .where((habit) => habit.status != 'paused')
              .toList();
          final pausedHabits = habits
              .where((habit) => habit.status == 'paused')
              .toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 28, 16, 120),
            children: [
              _SummaryCard(
                total: habits.length,
                normal: normalHabits.length,
                paused: pausedHabits.length,
              ),
              const SizedBox(height: 24),
              const KeepDaySectionLabel('进行中的习惯'),
              if (normalHabits.isEmpty)
                const _EmptyGroupCard(text: '当前没有进行中的习惯。')
              else
                for (final habit in normalHabits) ...[
                  _HabitManagementCard(habit: habit),
                  const SizedBox(height: 12),
                ],
              const SizedBox(height: 24),
              const KeepDaySectionLabel('已暂停的习惯'),
              if (pausedHabits.isEmpty)
                const _EmptyGroupCard(text: '当前没有暂停的习惯。')
              else
                for (final habit in pausedHabits) ...[
                  _HabitManagementCard(habit: habit),
                  const SizedBox(height: 12),
                ],
            ],
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.total,
    required this.normal,
    required this.paused,
  });

  final int total;
  final int normal;
  final int paused;

  @override
  Widget build(BuildContext context) {
    return KeepDayCard(
      child: Row(
        children: [
          _SummaryItem(label: '全部', value: total),
          _SummaryItem(label: '进行中', value: normal),
          _SummaryItem(label: '已暂停', value: paused),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value.toString(),
            style: const TextStyle(
              color: keepdayPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: keepdayMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _EmptyGroupCard extends StatelessWidget {
  const _EmptyGroupCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return KeepDayCard(
      child: Text(text, style: const TextStyle(color: keepdayMuted)),
    );
  }
}

class _HabitManagementCard extends ConsumerWidget {
  const _HabitManagementCard({required this.habit});

  final Habit habit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accent = habitReadableColor(habit.color);
    final paused = habit.status == 'paused';
    return KeepDayCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => context.push('/habits/${habit.id}'),
            child: Row(
              children: [
                KeepDayHabitIcon(
                  icon: habit.icon,
                  background: habitSoftColor(habit.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: keepdayText,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        paused
                            ? '已暂停 · 累计 ${habit.totalCheckInCount} 次'
                            : '连续 ${habit.currentStreak} 天 · 累计 ${habit.totalCheckInCount} 次',
                        style: const TextStyle(
                          color: keepdayMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusPill(
                  text: paused ? '暂停中' : '进行中',
                  color: paused ? keepdaySecondary : accent,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/habits/${habit.id}/edit'),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('编辑'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _togglePause(context, ref),
                  icon: Icon(
                    paused
                        ? Icons.play_circle_outline
                        : Icons.pause_circle_outline,
                    size: 18,
                  ),
                  label: Text(paused ? '恢复' : '暂停'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: keepdaySecondary,
                    side: BorderSide(
                      color: keepdaySecondary.withValues(alpha: 0.28),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: '删除',
                onPressed: () => _delete(context, ref),
                color: keepdayDanger,
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _togglePause(BuildContext context, WidgetRef ref) async {
    final repository = ref.read(habitRepositoryProvider);
    final paused = habit.status == 'paused';
    try {
      if (paused) {
        await repository.resumeHabit(habit.id);
      } else {
        final confirmed = await showConfirmDialog(
          context,
          title: '暂停习惯',
          message: '暂停后该习惯会移入暂停区，暂停期间不消耗宽限。',
          confirmLabel: '暂停',
        );
        if (!confirmed) {
          return;
        }
        await repository.pauseHabit(habit.id);
      }
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
      message: '删除后该习惯不会再展示，确认删除“${habit.name}”吗？',
      confirmLabel: '删除',
      destructive: true,
    );
    if (!confirmed) {
      return;
    }

    try {
      await ref.read(habitRepositoryProvider).softDeleteHabit(habit.id);
    } catch (error) {
      if (context.mounted) {
        AppToast.show(context, '删除失败：$error');
      }
    }
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
