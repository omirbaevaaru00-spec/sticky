import 'package:flutter/material.dart';

class UniversityDetailScreen extends StatelessWidget {
  final String id;

  const UniversityDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Университет'),
      ),
      body: Center(
        child: Text('ID: $id'),
      ),
    );
  }
}
