import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = ['Narxoz University', 'SDU University', 'KBTU'];

    return Scaffold(
      appBar: AppBar(title: const Text('Таңдаулылар')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: favorites.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey.shade100,
            ),
            child: Text(favorites[index]),
          );
        },
      ),
    );
  }
}