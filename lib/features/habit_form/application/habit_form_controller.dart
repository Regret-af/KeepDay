import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/habit_repository.dart';

class HabitFormValidationResult {
  const HabitFormValidationResult._({this.input, this.error});

  const HabitFormValidationResult.valid(HabitInput input)
    : this._(input: input);

  const HabitFormValidationResult.invalid(String error) : this._(error: error);

  final HabitInput? input;
  final String? error;

  bool get isValid => input != null;
}

class HabitFormController {
  HabitFormController(this._habitRepository);

  final HabitRepository _habitRepository;

  HabitFormValidationResult validate({
    required String name,
    required String color,
    String? icon,
    int gracePerWeek = 0,
    bool reminderEnabled = false,
    String? reminderTime,
  }) {
    final trimmedName = name.trim();
    final trimmedIcon = icon?.trim();

    if (trimmedName.isEmpty) {
      return const HabitFormValidationResult.invalid('习惯名称不能为空');
    }
    if (trimmedName.contains('\n') || trimmedName.contains('\r')) {
      return const HabitFormValidationResult.invalid('习惯名称不能换行');
    }
    if (trimmedName.length > 30) {
      return const HabitFormValidationResult.invalid('习惯名称最多 30 个字符');
    }
    if (color.trim().isEmpty) {
      return const HabitFormValidationResult.invalid('请选择颜色');
    }
    if (gracePerWeek < 0 || gracePerWeek > 2) {
      return const HabitFormValidationResult.invalid('宽限期只能是 0、1、2 天');
    }
    if (reminderEnabled && (reminderTime == null || reminderTime.isEmpty)) {
      return const HabitFormValidationResult.invalid('开启提醒后需要选择提醒时间');
    }

    return HabitFormValidationResult.valid(
      HabitInput(
        name: trimmedName,
        color: color,
        icon: trimmedIcon == null || trimmedIcon.isEmpty ? null : trimmedIcon,
        gracePerWeek: gracePerWeek,
        reminderEnabled: reminderEnabled,
        reminderTime: reminderTime,
      ),
    );
  }

  Future<bool> hasDuplicateName(String name, {String? excludeId}) {
    return _habitRepository.hasActiveHabitWithName(
      name.trim(),
      excludeId: excludeId,
    );
  }

  Future<String> create(HabitInput input) => _habitRepository.createHabit(input);

  Future<void> update(String id, HabitInput input) {
    return _habitRepository.updateHabit(id, input);
  }
}

final habitFormControllerProvider = Provider<HabitFormController>((ref) {
  return HabitFormController(ref.watch(habitRepositoryProvider));
});
