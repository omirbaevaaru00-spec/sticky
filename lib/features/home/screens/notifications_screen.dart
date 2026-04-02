import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      'Сен сақтаған университет жаңа жаңалық жариялады',
      'Қабылдау мерзімі жақындап қалды',
      'Жаңа университеттер сенің қызығушылығыңа сай табылды',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Хабарламалар')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.notifications_none),
            ),
            title: Text(notifications[index]),
          );
        },
      ),
    );
  }
}