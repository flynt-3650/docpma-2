import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Справка'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Инструкция',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                '• Профиль',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Отображает имя пользователя и текущее значение счётчика',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 15),
              Text(
                '• Оценки',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Добавление и удаление задач из списка',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 15),
              Text(
                '• Расписание',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Увеличение счётчика с учётом выбранного шага',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 15),
              Text(
                '• Настройки',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Изменение шага инкремента (1, 2, 5 или 10)',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 15),
              Text(
                '• Справка',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Инструкция по использованию приложения',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
