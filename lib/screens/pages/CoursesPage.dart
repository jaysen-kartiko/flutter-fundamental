import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/course_provider.dart';
import '../../core/models/course.dart';
import '../widgets/course_card.dart';
import '../course_detail_page.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  void _bukaHalamanDetail(
    BuildContext context,
    Course course,
  ) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => CourseDetailPage(course: course)),
    );

    if (result == true && context.mounted) {
      context.read<CourseProvider>().toggleFavorite(course.code);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Kursus ${course.title} berhasil ditandai sebagai Favorit!',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Kursus Saya (Favorit: ${courseProvider.favorites.length})'),
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
// Widget buildCoursesList(BuildContext context, List<dynamic> courses) {
//   final data = courses;

//   void bukaHalamanDetail(
//     BuildContext context,
//     Map<String, dynamic> course,
//   ) async {
//     final result = await Navigator.push<bool>(
//       context,
//       MaterialPageRoute(builder: (_) => CourseDetailPage(course: course)),
//     );

//     if (result == true) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Kursus ${course["title"]} berhasil ditandai sebagai Favorit!',
//           ),
//           duration: const Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   return ListView.builder(
//     shrinkWrap: true,
//     physics: const NeverScrollableScrollPhysics(),
//     itemCount: data.length,
//     itemBuilder: (context, index) {
//       final item = data[index];
//       return CourseCard(
//         course: item,
//         onTap: (courseData) {
//           bukaHalamanDetail(context, courseData);
//         },
//       );
//     },
//   );
// }


// class ProfileCard extends StatefulWidget {
//   const ProfileCard({super.key}); // Diperbaiki dari "const new"

//   @override
//   State<ProfileCard> createState() => ProfileCardState();
// }

// class ProfileCardState extends State<ProfileCard> {
//   late Future<Map<String, dynamic>> studentFuture;

//   @override
//   void initState() {
//     super.initState();
//     studentFuture = loadStudentData();
//   }

//   Widget buildProfileDetail(Map<String, dynamic> student) {
//     return Text(
//       "Nama: ${student['name'] ?? '-'}",
//       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Profil Mahasiswa')),
//       body: FutureBuilder(
//         future: studentFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
//           }

//           final data = snapshot.data!;
//           final student = data['student'] as Map<String, dynamic>;
//           final courses = data['courses'] as List<dynamic>;

//           final int totalCourses = courses.length;
//           final int doneCourses = courses
//               .where((c) => c['status'] == 'done')
//               .length;
//           final double progressPercent = totalCourses > 0
//               ? (doneCourses / totalCourses) * 100
//               : 0.0;

//           final List<String> skills = [
//             'Pemrograman',
//             'Editing',
//             'photography',
//             'music',
//             'videography',
//             'learn',
//           ];

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   children: skills.map((e) => Chip(label: Text(e))).toList(),
//                 ),
//                 const SizedBox(height: 16),
//                 buildProfileDetail(student),
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const CircleAvatar(
//                       backgroundImage: AssetImage('assets/images/profile.jpg'),
//                     ),
//                     const SizedBox(width: 12),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: const [
//                         Text(
//                           "Flutter UI Fundamental",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           "Pertemuan 4",
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Card(
//                         color: Colors.blue.shade50,
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             children: [
//                               const Text(
//                                 "Total Courses",
//                                 style: TextStyle(color: Colors.grey),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 "$totalCourses",
//                                 style: const TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.blue,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Card(
//                         color: Colors.green.shade50,
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             children: [
//                               const Text(
//                                 "Progress Done",
//                                 style: TextStyle(color: Colors.grey),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 "${progressPercent.toStringAsFixed(0)}%",
//                                 style: const TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.green,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   "Daftar Materi",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//                 const SizedBox(height: 8),
//                 buildCoursesList(context, courses),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
