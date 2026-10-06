// courses_page.dart
import 'package:flutter/material.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(
          leading: Icon(Icons.book, color: Colors.blue),
        title: Text('Flutter UI Fundamental'),
        subtitle: Text('IF101 - Selesai'),
      ),
      ListTile(
        leading: Icon(Icons.book, color: Colors.orange),
        title: Text('State Management'),
        subtitle: Text('IF102 - Sedang Berjalan'),
      ),
    ],
  );
  }
}