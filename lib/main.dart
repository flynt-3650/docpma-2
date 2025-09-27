import 'package:flutter/material.dart';

/// Entry point of the student information application
void main() {
  runApp(const MyApp());
}

/// Main application widget that sets up the MaterialApp
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Студенческая информация',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true, // Enable Material 3 design system
      ),
      home: const MyHomePage(title: 'Информация о студенте'),
      debugShowCheckedModeBanner: false, // Hide debug banner in debug mode
    );
  }
}

/// Home page widget that displays student information
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  /// The title displayed in the app bar
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Иван Иванович Репилов',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Группа: ИКБО-11-22', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Студенческий билет: 22И400', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
