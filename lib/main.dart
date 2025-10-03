import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Студенческая информация',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Информация о студенте'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: const Center(child: MyInfoBlock()),
    );
  }
}

class MyInfoBlock extends StatelessWidget {
  const MyInfoBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text(
          'Иван Иванович Репилов',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        const Text('Группа: ИКБО-11-22', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Студенческий билет: 22И400',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
