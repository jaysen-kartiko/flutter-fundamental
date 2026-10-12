import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

Future<Map<String, dynamic>> loadStudentData() async {
  final jsonString = await rootBundle.loadString(
    'assets/data/student_data.json',
  );
  return jsonDecode(jsonString) as Map<String, dynamic>;
}

void main() {
  runApp(const MaterialApp(home: CoursesPage()));
}

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final Set<String> _favoriteCodes = {};
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  void _bukaHalamanDetail(
    BuildContext context,
    Map<String, dynamic> course,
  ) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => CourseDetailPage(course: course)),
    );

    if (result == true && mounted) {
      setState(() {
        _favoriteCodes.add(course['code']);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Kursus ${course["title"]} berhasil ditandai sebagai Favorit!',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildCourseItem(Map<String, dynamic> courseItem) {
    final String code = courseItem['code'];
    final bool isFav = _favoriteCodes.contains(code);

    return CourseCard(
      course: courseItem,
      isFavorite: isFav,
      onTap: (courseData) {
        _bukaHalamanDetail(context, courseData);
      },
      onFavoriteChanged: () {
        setState(() {
          if (isFav) {
            _favoriteCodes.remove(code);
          } else {
            _favoriteCodes.add(code);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Kursus Saya (Favorit: ${_favoriteCodes.length})'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Gagal memuat data kursus: ${snapshot.error}'),
            );
          }

          final data = snapshot.data!;
          final courses = data['courses'] as List<dynamic>;

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
                    final courseItem =
                        courses[index] as Map<String, dynamic>;
                    return _buildCourseItem(courseItem);
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
                    final courseItem =
                        courses[index] as Map<String, dynamic>;
                    return _buildCourseItem(courseItem);
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

class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  final Function(Map<String, dynamic>) onTap;
  final bool isFavorite;
  final VoidCallback onFavoriteChanged;

  const CourseCard({
    super.key,
    required this.course,
    required this.onTap,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    final item = course;
    return InkWell(
      onTap: () => onTap(item),
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Informasi Kursus'),
            content: Text(
              'Kode: ${item['code']}\nStatus: ${item['status']}\nSKS: ${item['credits']}',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup'),
              ),
            ],
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                item['status'] == "done"
                    ? Icons.check_circle
                    : item['status'] == 'active'
                    ? Icons.run_circle
                    : Icons.calendar_month_rounded,
                color: Colors.blue,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Kode: ${item['code']}'),
                  ],
                ),
              ),
              Text(
                "${item['credits']} SKS",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: onFavoriteChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CourseDetailPage extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail ${course['title']}")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${course['title']}\n${course['status']}\n${course['code']}",
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Pilih / Favorite'),
            ),
          ],
        ),
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
