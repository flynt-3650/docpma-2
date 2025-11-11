import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'di/service_locator.dart';
import 'features/tasks/models/task.dart';
import 'features/tasks/screens/task_list_screen_getit.dart';
import 'features/tasks/screens/task_form_screen_getit.dart';
import 'features/tasks/screens/task_details_screen_getit.dart';
import 'features/tasks/screens/statistics_screen.dart';
import 'features/tasks/screens/settings_screen.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const TaskListScreenGetIt(),
        ),
        GoRoute(
          path: '/task/new',
          builder: (context, state) => const TaskFormScreenGetIt(),
        ),
        GoRoute(
          path: '/task/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return TaskDetailsScreenGetIt(taskId: id);
          },
        ),
        GoRoute(
          path: '/task/:id/edit',
          builder: (context, state) {
            final task = state.extra as Task?;
            return TaskFormScreenGetIt(task: task);
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
      ],
    );

    return MaterialApp.router(
      title: 'Управление задачами',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
