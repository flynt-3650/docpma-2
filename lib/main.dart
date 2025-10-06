import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Простейший список',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SimpleListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SimpleListScreen extends StatelessWidget {
  const SimpleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Данные для списка в виде String
    final List<String> items = [
      'Первый элемент списка',
      'Второй элемент списка',
      'Третий элемент списка',
      'Четвертый элемент списка',
      'Пятый элемент списка',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Простейший список'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Контейнер в виде Column с элементами списка
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Элементы списка в виде Text с данными String
            for (String item in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
