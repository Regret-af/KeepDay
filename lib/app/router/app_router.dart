import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/habit_detail/presentation/habit_detail_page.dart';
import '../../features/habit_form/presentation/habit_form_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/settings/presentation/habit_management_page.dart';
import '../../features/settings/presentation/settings_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/habits/new',
        name: 'habit-new',
        builder: (context, state) => const HabitFormPage(),
      ),
      GoRoute(
        path: '/habits/:id',
        name: 'habit-detail',
        builder: (context, state) {
          return HabitDetailPage(habitId: state.pathParameters['id']!);
        },
      ),
      GoRoute(
        path: '/habits/:id/edit',
        name: 'habit-edit',
        builder: (context, state) {
          return HabitFormPage(habitId: state.pathParameters['id']!);
        },
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/settings/habits',
        name: 'settings-habits',
        builder: (context, state) => const HabitManagementPage(),
      ),
    ],
  );
});
