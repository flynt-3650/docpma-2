import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'features/tasks/screens/task_list_screen_riverpod.dart';
import 'features/tasks/screens/task_form_screen_riverpod.dart';
import 'features/tasks/screens/task_details_screen_riverpod.dart';
import 'features/tasks/screens/statistics_screen_riverpod.dart';
import 'features/tasks/screens/settings_screen_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/riverpod',
      routes: [
        GoRoute(
          path: '/riverpod',
          builder: (context, state) => const TaskListScreenRiverpod(),
        ),
        GoRoute(
          path: '/riverpod/task/new',
          builder: (context, state) => const TaskFormScreenRiverpod(),
        ),
        GoRoute(
          path: '/riverpod/task/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return TaskDetailsScreenRiverpod(taskId: id);
          },
        ),
        GoRoute(
          path: '/riverpod/task/edit/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return TaskFormScreenRiverpod(taskId: id);
          },
        ),
        GoRoute(
          path: '/riverpod/statistics',
          builder: (context, state) => const StatisticsScreenRiverpod(),
        ),
        GoRoute(
          path: '/riverpod/settings',
          builder: (context, state) => const SettingsScreenRiverpod(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Управление задачами (Riverpod)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
