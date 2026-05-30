import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/database/app_database.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../../../shared/widgets/keepday_shell.dart';
import '../../habit_detail/application/habit_detail_controller.dart';
import '../application/habit_form_controller.dart';

class HabitFormPage extends ConsumerStatefulWidget {
  const HabitFormPage({this.habitId, super.key});

  final String? habitId;

  @override
  ConsumerState<HabitFormPage> createState() => _HabitFormPageState();
}

class _HabitFormPageState extends ConsumerState<HabitFormPage> {
  final _nameController = TextEditingController();
  String _icon = _emojiOptions.first;
  String _color = _colorOptions.first.value;
  int _gracePerWeek = 0;
  bool _reminderEnabled = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 8, minute: 0);
  bool _loadedHabit = false;
  bool _saving = false;

  bool get _isEditing => widget.habitId != null;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final habitAsync = _isEditing
        ? ref.watch(habitDetailProvider(widget.habitId!))
        : const AsyncData<Habit?>(null);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        leadingWidth: 88,
        leading: TextButton.icon(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
          icon: const Icon(Icons.arrow_back, size: 20),
          label: const Text('返回'),
        ),
        centerTitle: true,
        title: Text(
          _isEditing ? '编辑习惯' : '创建习惯',
          style: const TextStyle(
            color: keepdayPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton(
              onPressed: _saving ? null : () => _save(habitAsync.value),
              child: Text(_saving ? '保存中' : '保存'),
            ),
          ),
        ],
      ),
      body: habitAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('加载失败：$error')),
        data: (habit) {
          if (_isEditing && habit == null) {
            return const Center(child: Text('习惯不存在'));
          }
          _loadHabitOnce(habit);

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 28, 16, 36),
            children: [
              _IdentityAnchor(icon: _icon),
              const SizedBox(height: 32),
              _LabeledField(
                label: '习惯名称',
                child: TextField(
                  controller: _nameController,
                  maxLength: 30,
                  decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    hintText: '例如：每天阅读、早起跑步...',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _Section(
                label: '常用图标',
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (final emoji in _emojiOptions)
                      _EmojiButton(
                        emoji: emoji,
                        selected: _icon == emoji,
                        onTap: () => setState(() => _icon = emoji),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _Section(
                label: '主题颜色',
                child: KeepDayCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 12,
                          children: [
                            for (final option in _colorOptions)
                              _ColorDot(
                                option: option,
                                selected: _color == option.value,
                                onTap: () =>
                                    setState(() => _color = option.value),
                              ),
                          ],
                        ),
                      ),
                      Text(
                        _selectedColorLabel(_color),
                        style: const TextStyle(
                          color: keepdayMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _GraceSelector(
                value: _gracePerWeek,
                onChanged: (value) => setState(() => _gracePerWeek = value),
              ),
              const SizedBox(height: 24),
              _ReminderCard(
                enabled: _reminderEnabled,
                time: _reminderTime,
                onEnabledChanged: (value) =>
                    setState(() => _reminderEnabled = value),
                onTimeTap: _pickReminderTime,
              ),
              const SizedBox(height: 24),
              _QuoteCard(),
            ],
          );
        },
      ),
    );
  }

  void _loadHabitOnce(Habit? habit) {
    if (_loadedHabit || habit == null) {
      return;
    }
    _loadedHabit = true;
    _nameController.text = habit.name;
    _icon = habit.icon?.isNotEmpty == true ? habit.icon! : _emojiOptions.first;
    _color = habit.color;
    _gracePerWeek = habit.gracePerWeek;
    _reminderEnabled = habit.reminderEnabled;
    if (habit.reminderTime != null) {
      final parts = habit.reminderTime!.split(':');
      if (parts.length == 2) {
        _reminderTime = TimeOfDay(
          hour: int.tryParse(parts[0]) ?? 8,
          minute: int.tryParse(parts[1]) ?? 0,
        );
      }
    }
  }

  Future<void> _pickReminderTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (result != null) {
      setState(() => _reminderTime = result);
    }
  }

  Future<void> _save(Habit? habit) async {
    final controller = ref.read(habitFormControllerProvider);
    final reminderTime = _reminderEnabled
        ? '${_reminderTime.hour.toString().padLeft(2, '0')}:'
              '${_reminderTime.minute.toString().padLeft(2, '0')}'
        : null;
    final result = controller.validate(
      name: _nameController.text,
      icon: _icon,
      color: _color,
      gracePerWeek: _gracePerWeek,
      reminderEnabled: _reminderEnabled,
      reminderTime: reminderTime,
    );

    if (!result.isValid) {
      AppToast.show(context, result.error ?? '表单校验失败');
      return;
    }

    final input = result.input!;
    final duplicate = await controller.hasDuplicateName(
      input.name,
      excludeId: habit?.id,
    );
    if (!mounted) {
      return;
    }
    if (duplicate) {
      final confirmed = await showConfirmDialog(
        context,
        title: '创建同名习惯',
        message: '已存在同名习惯，仍然继续保存吗？',
        confirmLabel: '继续保存',
      );
      if (!confirmed || !mounted) {
        return;
      }
    }

    setState(() => _saving = true);
    try {
      if (_isEditing) {
        await controller.update(habit!.id, input);
        if (mounted) {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/habits/${habit.id}');
          }
        }
      } else {
        await controller.create(input);
        if (mounted) {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/');
          }
        }
      }
    } catch (error) {
      if (mounted) {
        AppToast.show(context, '保存失败：$error');
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }
}

class _IdentityAnchor extends StatelessWidget {
  const _IdentityAnchor({required this.icon});

  final String icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: keepdaySurface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: keepdayLine),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A2F8F83),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(icon, style: const TextStyle(fontSize: 40)),
            ),
            const Positioned(
              right: -4,
              bottom: -4,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: keepdayPrimary,
                child: Icon(Icons.edit, size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          '选择你的习惯象征',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _Section(
      label: label,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        decoration: BoxDecoration(
          color: keepdaySurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: keepdayLine),
        ),
        child: child,
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            label,
            style: const TextStyle(
              color: keepdayMuted,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _EmojiButton extends StatelessWidget {
  const _EmojiButton({
    required this.emoji,
    required this.selected,
    required this.onTap,
  });

  final String emoji;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: keepdaySurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? keepdayPrimary : keepdayLine,
            width: selected ? 2 : 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(emoji, style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _ColorOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final value = int.parse(option.value.replaceFirst('#', '0xFF'));
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Color(value),
          shape: BoxShape.circle,
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Color(value).withValues(alpha: 0.24),
                    blurRadius: 0,
                    spreadRadius: 5,
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}

class _GraceSelector extends StatelessWidget {
  const _GraceSelector({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                '每周宽限天数',
                style: TextStyle(
                  color: keepdayMuted,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: keepdaySecondary.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                '温柔坚持',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF1EF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: keepdayLine),
          ),
          child: Row(
            children: [
              for (final item in [0, 1, 2])
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => onChanged(item),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: value == item ? keepdaySurface : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: value == item
                            ? const [
                                BoxShadow(
                                  color: Color(0x12000000),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$item天',
                        style: TextStyle(
                          color: value == item ? keepdayPrimary : keepdayMuted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '宽限天数内未完成不会中断连续纪录。',
          style: TextStyle(color: keepdayMuted, fontSize: 12),
        ),
      ],
    );
  }
}

class _ReminderCard extends StatelessWidget {
  const _ReminderCard({
    required this.enabled,
    required this.time,
    required this.onEnabledChanged,
    required this.onTimeTap,
  });

  final bool enabled;
  final TimeOfDay time;
  final ValueChanged<bool> onEnabledChanged;
  final VoidCallback onTimeTap;

  @override
  Widget build(BuildContext context) {
    return KeepDayCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: keepdayPrimary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.notifications, color: keepdayPrimary),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '开启提醒',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '在设定时间准时督促',
                      style: TextStyle(color: keepdayMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Switch(value: enabled, onChanged: onEnabledChanged),
            ],
          ),
          if (enabled) ...[
            const Divider(height: 28, color: keepdayLine),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    '提醒时间',
                    style: TextStyle(
                      color: keepdayMuted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onTimeTap,
                  child: Text(time.format(context)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF273236),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.centerLeft,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '今日格言',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6),
          Text(
            '“细微的改变，终将汇集成不凡的坚持。”',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorOption {
  const _ColorOption(this.value, this.label);

  final String value;
  final String label;
}

const _emojiOptions = ['📖', '🏃', '💧', '🍎', '🧘', '🎸'];

String _selectedColorLabel(String value) {
  for (final option in _colorOptions) {
    if (option.value.toLowerCase() == value.toLowerCase()) {
      return option.label;
    }
  }
  return '自定义';
}

const _colorOptions = [
  _ColorOption('#00685E', '碧波绿'),
  _ColorOption('#2F7D5C', '松石绿'),
  _ColorOption('#875200', '琥珀棕'),
  _ColorOption('#D97706', '暖橙'),
  _ColorOption('#0059BA', '湖泊蓝'),
  _ColorOption('#2563EB', '晴空蓝'),
  _ColorOption('#D84C4C', '珊瑚红'),
  _ColorOption('#C2410C', '陶土红'),
  _ColorOption('#2EAD6B', '新叶绿'),
  _ColorOption('#7C3AED', '鸢尾紫'),
  _ColorOption('#0F766E', '深青绿'),
];
