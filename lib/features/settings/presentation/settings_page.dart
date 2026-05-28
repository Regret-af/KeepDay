import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/keepday_shell.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KeepDayTopBar(
        title: AppConstants.appName,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.settings, color: keepdayPrimary),
          ),
        ],
      ),
      bottomNavigationBar: const KeepDayBottomNav(active: 'profile'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 28, 16, 120),
        children: [
          _NotificationAlert(),
          const SizedBox(height: 32),
          const KeepDaySectionLabel('日常管理'),
          KeepDayCard(
            padding: EdgeInsets.zero,
            child: _SettingsRow(
              icon: Icons.format_list_bulleted,
              iconColor: keepdayPrimary,
              title: '习惯管理',
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF98F3E4),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'V0.2',
                  style: TextStyle(
                    color: keepdayPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const KeepDaySectionLabel('数据安全'),
          KeepDayCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                const _SettingsRow(
                  icon: Icons.ios_share_outlined,
                  iconColor: keepdayTertiary,
                  title: '导出 JSON 备份',
                ),
                Container(height: 1, color: keepdayLine),
                const _SettingsRow(
                  icon: Icons.publish_outlined,
                  iconColor: keepdaySuccess,
                  title: '恢复 JSON 备份',
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            '您的数据将保存在本地设备。KeepDay 致力于保护用户隐私，我们不会上传或分析您的个人习惯数据，所有记录仅归您所有。',
            style: TextStyle(color: keepdayMuted, fontSize: 12, height: 1.5),
          ),
          const SizedBox(height: 56),
          const _AboutBlock(),
        ],
      ),
    );
  }
}

class _NotificationAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: keepdaySecondary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: keepdaySecondary.withValues(alpha: 0.20)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A2F8F83),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_off, color: keepdaySecondary),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '通知提醒未开启',
                  style: TextStyle(
                    color: Color(0xFF6D4100),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '开启通知以获取每日习惯提醒',
                  style: TextStyle(color: keepdayMuted, fontSize: 12),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: () {},
            child: const Text('去开启'),
          ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.trailing,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, color: keepdayText),
              ),
            ),
            if (trailing != null) ...[
              trailing!,
              const SizedBox(width: 8),
            ],
            const Icon(Icons.chevron_right, color: Color(0xFFBDC9C6)),
          ],
        ),
      ),
    );
  }
}

class _AboutBlock extends StatelessWidget {
  const _AboutBlock();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: keepdaySurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: keepdayLine),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A2F8F83),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.calendar_today,
            color: keepdayPrimary,
            size: 32,
          ),
        ),
        const SizedBox(height: 14),
        TextButton(
          onPressed: () {},
          child: const Text(
            '关于 KeepDay',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        const Text(
          'VERSION 0.1.0',
          style: TextStyle(
            color: Color(0xFF6E7977),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
