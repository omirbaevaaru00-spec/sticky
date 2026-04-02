import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      'Қосымша қалай жұмыс істейді?',
      'Университетті қалай сақтау керек?',
      'Құпиясөзді қалай өзгертуге болады?',
      'Тілді қалай ауыстыруға болады?',
      'Қолдау қызметіне қалай жазамын?',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Көмек орталығы')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            tileColor: Colors.grey.shade100,
            title: Text(items[index]),
            trailing: const Icon(Icons.chevron_right),
          );
        },
      ),
    );
  }
}