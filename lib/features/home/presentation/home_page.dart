import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/database/database_provider.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_status_tag.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../../shared/widgets/confirm_dialog.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.watch(appDatabaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            tooltip: '设置',
            onPressed: () => context.go('/settings'),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(_todayLabel(), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppStatusTag(label: '工程准备', color: Color(0xFF2F7D5C)),
                const SizedBox(height: 12),
                Text(
                  '今日习惯列表将在下一阶段接入。',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Drift 数据库已初始化，当前 schemaVersion 为 ${database.schemaVersion}。',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    AppButton.primary(
                      label: '创建习惯',
                      icon: Icons.add,
                      onPressed: () {
                        AppToast.show(context, '创建页将在 V0.1 接入');
                      },
                    ),
                    AppButton.secondary(
                      label: '确认弹窗',
                      onPressed: () async {
                        await showConfirmDialog(
                          context,
                          title: '确认操作',
                          message: '通用确认弹窗已接入。',
                          confirmLabel: '知道了',
                        );
                      },
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

  String _todayLabel() {
    final now = DateTime.now();
    return '${now.year}年${now.month}月${now.day}日';
  }
}
