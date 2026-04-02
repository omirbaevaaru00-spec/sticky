import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget languageButton(String title, String subtitle) {
      return InkWell(
        onTap: () {
          context.go('/quiz');
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(subtitle, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Тілді таңдау')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'Қосымша тілін таңда',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            languageButton('Қазақша', 'Интерфейс қазақ тілінде'),
            const SizedBox(height: 16),
            languageButton('Русский', 'Интерфейс на русском языке'),
          ],
        ),
      ),
    );
  }
}