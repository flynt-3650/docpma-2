import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'riverpod/task_providers.dart';
import 'features/tasks/screens/task_list_screen.dart';
import 'features/tasks/screens/task_details_screen.dart';
import 'features/tasks/screens/task_form_screen.dart';
import 'features/tasks/screens/statistics_screen.dart';
import 'features/tasks/screens/settings_screen.dart';
import 'features/tasks/screens/profile_screen.dart';
import 'features/tasks/screens/calendar_screen.dart';

void main() {
  runApp(
    const ProviderScope(child: TaskMasterApp()),
  );
}

class TaskMasterApp extends ConsumerWidget {
  const TaskMasterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        // 1. Task List Screen (Home)
        GoRoute(
          path: '/',
          builder: (context, state) => const TaskListScreen(),
        ),

        // 2. Task Details Screen
        GoRoute(
          path: '/task/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return TaskDetailsScreen(taskId: id);
          },
        ),

        // 3. Task Form Screen (Create)
        GoRoute(
          path: '/task/new',
          builder: (context, state) => const TaskFormScreen(),
        ),

        // 4. Task Form Screen (Edit)
        GoRoute(
          path: '/task/edit/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return TaskFormScreen(taskId: id);
          },
        ),

        // 5. Statistics Screen
        GoRoute(
          path: '/statistics',
          builder: (context, state) => const StatisticsScreen(),
        ),

        // 6. Settings Screen
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),

        // 7. Profile Screen
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),

        // Calendar Screen (bonus)
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
