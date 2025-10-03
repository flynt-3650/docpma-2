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

  void _incrementCounter() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Счётчик нажатий:', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 10),
                const Text(
                  '0',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: 200,
              height: 100,
              color: Colors.blueAccent,
              alignment: Alignment.center,
              child: const Text(
                'Контейнер',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 150,
              height: 50,
              child: ElevatedButton(
                onPressed: _incrementCounter,
                child: const Text('Нажми меня'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
