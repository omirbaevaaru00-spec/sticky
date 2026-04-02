import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InterestQuizScreen extends StatefulWidget {
  const InterestQuizScreen({super.key});

  @override
  State<InterestQuizScreen> createState() => _InterestQuizScreenState();
}

class _InterestQuizScreenState extends State<InterestQuizScreen> {
  final List<String> interests = [
    'IT',
    'Business',
    'Medicine',
    'Design',
    'Engineering',
    'Education',
    'Law',
    'Marketing',
    'Finance',
    'Architecture',
  ];

  final Set<String> selected = {};

  void toggleInterest(String value) {
    setState(() {
      if (selected.contains(value)) {
        selected.remove(value);
      } else {
        selected.add(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Қызығушылықтар')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Саған не қызық?',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text(
              'Бірнеше бағыт таңда',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: interests.map((item) {
                  final isSelected = selected.contains(item);

                  return ChoiceChip(
                    label: Text(item),
                    selected: isSelected,
                    onSelected: (_) => toggleInterest(item),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.go('/profile-setup');
                },
                child: const Text('Далее'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}