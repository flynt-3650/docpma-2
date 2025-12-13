import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'presentation/providers/task_providers.dart';
import 'features/tasks/screens/task_list_screen.dart';
import 'features/tasks/screens/task_details_screen.dart';
import 'features/tasks/screens/task_form_screen.dart';
import 'features/tasks/screens/statistics_screen.dart';
import 'features/tasks/screens/settings_screen.dart';
import 'features/tasks/screens/profile_screen.dart';
import 'features/tasks/screens/calendar_screen.dart';

void main() {
  runApp(const ProviderScope(child: TaskMasterApp()));
}

class TaskMasterApp extends ConsumerWidget {
  const TaskMasterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const TaskListScreen()),
        GoRoute(
          path: '/task/new',
          builder: (context, state) => const TaskFormScreen(),
        ),
        GoRoute(
          path: '/task/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return TaskDetailsScreen(taskId: id);
          },
        ),
        GoRoute(
          path: '/task/edit/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return TaskFormScreen(taskId: id);
          },
        ),
        GoRoute(
          path: '/statistics',
          builder: (context, state) => const StatisticsScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/calendar',
          builder: (context, state) => const CalendarScreen(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'TaskMaster Pro',
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
