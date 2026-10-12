import 'package:flutter/material.dart';
import '../../core/models/course.dart';
import '../core/providers/course_provider.dart';
import 'package:provider/provider.dart';
class CourseDetailPage extends StatelessWidget {
  final Course course;

  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final courseProvider = context.watch<CourseProvider>();
    final bool isFavorite = courseProvider.isFavorite(course.code);

    return Scaffold(
      appBar: AppBar(title: Text("Detail ${course.title}")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${course.title}\nStatus: ${course.status}\nKode: ${course.code}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                courseProvider.toggleFavorite(course.code);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isFavorite
                          ? 'Kursus ${course.title} dihapus dari Favorit.'
                          : 'Kursus ${course.title} berhasil ditandai sebagai Favorit!',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
              label: Text(isFavorite ? 'Hapus dari Favorit' : 'Pilih / Favorite'),
            ),
          ],
        ),
      ),
    );
  }
}