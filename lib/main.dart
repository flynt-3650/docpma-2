import 'package:flutter/material.dart';
import 'profile/profile_screen.dart';
import 'profile/grades_screen.dart';
import 'profile/schedule_screen.dart';
import 'settings/settings_screen.dart';
import 'auth/about_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Навигация',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeShell(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;
  String _userName = 'Иван Репилов';
  int _step = 1;
  int _counter = 0;
  final List<String> _tasks = [];

  void updateStep(int newStep) {
    setState(() {
      _step = newStep;
    });
  }

  void incrementCounter() {
    setState(() {
      _counter += _step;
    });
  }

  void addTask(String task) {
    setState(() {
      _tasks.add(task);
    });
  }

  void removeTaskAt(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      ProfileScreen(userName: _userName, counter: _counter),
      GradesScreen(
        tasks: _tasks,
        onAddTask: addTask,
        onRemoveTask: removeTaskAt,
      ),
      ScheduleScreen(
        counter: _counter,
        step: _step,
        onIncrement: incrementCounter,
      ),
      SettingsScreen(currentStep: _step, onStepChanged: updateStep),
      const AboutScreen(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person), label: 'Профиль'),
          NavigationDestination(icon: Icon(Icons.task), label: 'Задачи'),
          NavigationDestination(
            icon: Icon(Icons.analytics),
            label: 'Статистика',
          ),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Настройки'),
          NavigationDestination(icon: Icon(Icons.help), label: 'Справка'),
        ],
      ),
    );
  }
}
