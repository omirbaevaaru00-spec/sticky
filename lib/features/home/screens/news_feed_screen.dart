import 'package:flutter/material.dart';

class NewsFeedScreen extends StatelessWidget {
  const NewsFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final news = [
      {
        'title': 'Narxoz жаңа бағдарлама ашты',
        'subtitle': 'IT және Business бағытында жаңа мүмкіндіктер',
      },
      {
        'title': 'SDU қабылдау мерзімін жариялады',
        'subtitle': 'Құжат қабылдау басталды',
      },
      {
        'title': 'KBTU ашық есік күнін өткізеді',
        'subtitle': 'Болашақ студенттерге арналған іс-шара',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Жаңалықтар')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: news.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = news[index];
          return ListTile(
            contentPadding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            tileColor: Colors.grey.shade100,
            title: Text(item['title']!),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(item['subtitle']!),
            ),
          );
        },
      ),
    );
  }
}