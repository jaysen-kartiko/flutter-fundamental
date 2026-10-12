import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/course_provider.dart';
import '../widgets/course_card.dart';
import '../course_detail_page.dart';


class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final courseProvider = context.watch<CourseProvider>();
    final favoriteCourses = courseProvider.courses
        .where((course) => courseProvider.isFavorite(course.code))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Kursus Favorit (${favoriteCourses.length})'),
      ),
      body: favoriteCourses.isEmpty
          ? const Center(child: Text('Belum ada kursus favorit.'))
          : ListView.builder(
              itemCount: favoriteCourses.length,
              itemBuilder: (context, index) {
                final course = favoriteCourses[index];
                return CourseCard(
                  course: course,
                  onTap: (courseData) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CourseDetailPage(course: courseData),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}