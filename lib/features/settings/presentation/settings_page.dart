import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: '返回',
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('设置'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.notifications_none),
            title: Text('通知权限'),
            subtitle: Text('提醒能力将在 V0.3 接入'),
          ),
          Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.ios_share_outlined),
            title: Text('导出 JSON 备份'),
            subtitle: Text('备份能力将在 V0.4 接入'),
          ),
        ],
      ),
    );
  }
}
