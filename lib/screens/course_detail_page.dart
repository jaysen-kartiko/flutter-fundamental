import 'package:flutter/material.dart';
import '../../core/models/course.dart';
import '../core/providers/course_provider.dart';
import 'package:provider/provider.dart';
import 'pages/editCoursePage.dart'; 

class CourseDetailPage extends StatelessWidget {
  final Course course;
  final String? courseId; 
  const CourseDetailPage({super.key, required this.course, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final courseProvider = context.watch<CourseProvider>();
    final bool isFavorite = courseProvider.isFavorite(course.code);

    return Scaffold(
      appBar: AppBar(
        title: Text("Detail ${course.title}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => editCoursePage(
                    course: course,
                    courseId: courseId,
                  ),
                ),
              );
            },
          ),
        ],
      ),
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