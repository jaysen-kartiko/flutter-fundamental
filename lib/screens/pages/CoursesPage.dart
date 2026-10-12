import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/course_provider.dart';
import '../../core/models/course.dart';
import '../widgets/course_card.dart';
import '../course_detail_page.dart';
import 'FavoritePage.dart';
class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  void _bukaHalamanDetail(BuildContext context, Course course) async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => CourseDetailPage(course: course)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Kursus Saya (Favorit: ${courseProvider.favorites.length})'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesPage()),
              );
            },
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (courseProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (courseProvider.error != null) {
            return Center(
              child: Text('Gagal memuat data kursus: ${courseProvider.error}'),
            );
          }

          final courses = courseProvider.courses;

          if (courses.isEmpty) {
            return const Center(child: Text('Tidak ada kursus tersedia.'));
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              bool isCompact = constraints.maxWidth < 600;

              if (isCompact) {
                return ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final courseItem = courses[index];
                    return CourseCard(
                      course: courseItem,
                      onTap: (courseData) {
                        _bukaHalamanDetail(context, courseData);
                      },
                    );
                  },
                );
              } else {
                return GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: constraints.maxWidth > 900 ? 3 : 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 1.6,
                  ),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final courseItem = courses[index];
                    return CourseCard(
                      course: courseItem,
                      onTap: (courseData) {
                        _bukaHalamanDetail(context, courseData);
                      },
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}