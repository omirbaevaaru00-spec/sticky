import 'package:flutter/material.dart';

class SavedSearchesScreen extends StatelessWidget {
  const SavedSearchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final savedSearches = [
      'Алматы • IT • English',
      'Астана • Business • Scholarship',
      'Online • Design',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Сақталған іздеулер')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: savedSearches.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            tileColor: Colors.grey.shade100,
            title: Text(savedSearches[index]),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          );
        },
      ),
    );
  }
}