import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/course_provider.dart';
import '../../core/models/course.dart';
import '../widgets/course_card.dart';
import '../course_detail_page.dart';
import 'FavoritePage.dart';
import '../../StudentInfo.dart';

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
              int crossAxisCount = isCompact ? 1 : 2;

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Card(
                            elevation: 0,
                            color: Colors.blue.withOpacity(0.08),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                ' $studentId - $studentName',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Card(
                                  elevation: 0,
                                  color: Colors.blue.withOpacity(0.08),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Courses',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '${courses.length}',
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const FavoritesPage()),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Card(
                                    elevation: 0,
                                    color: Colors.blue.withOpacity(0.08),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Favorites',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            '${courseProvider.favorites.length}',
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 3.2, 
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final courseItem = courses[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isCompact ? 0 : 8.0,
                          ),
                          child: CourseCard(
                            course: courseItem,
                            onTap: (courseData) {
                              _bukaHalamanDetail(context, courseData);
                            },
                          ),
                        );
                      },
                      childCount: courses.length,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}