import 'package:flutter/material.dart';

class AppState extends InheritedWidget {
  final String userName;
  final String selectedParameter;

  const AppState({
    super.key,
    required this.userName,
    required this.selectedParameter,
    required super.child,
  });

  static AppState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppState>();
  }

  @override
  bool updateShouldNotify(AppState oldWidget) {
    return userName != oldWidget.userName ||
        selectedParameter != oldWidget.selectedParameter;
  }
}

class DisplayUser extends StatelessWidget {
  const DisplayUser({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    return Text(state?.userName ?? 'Гость');
  }
}
