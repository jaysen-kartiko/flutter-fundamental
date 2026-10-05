import 'package:flutter/material.dart';

import 'dart:convert';
import 'ScrollableCard.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<Map<String, dynamic>> loadStudentData() async {
  final jsonString = await rootBundle.loadString(
    'assets/data/student_data.json',
  );
  return jsonDecode(jsonString) as Map<String, dynamic>;
}

const String studentName = 'Jaysen Natanael Kartiko';
const String studentId = '2415051028';

// void main() {
//   runApp(const MyApp());
// }
void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: ScrollableCard(),
        ),
      ),
    ),
  );
}

Widget buildBox(String text) => Container(
      color: Colors.blue.shade100,
      child: Center(child: Text(text)),
    );

Widget buildProfileDetail(Map<String, dynamic> student) {
  final data = student;
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [Text("Nama: ${data['name']}"), Text("NIM: ${data['nim']}")],
      ),
    ),
  );
}

Widget buildCoursesList(List<dynamic> courses) {
  final data = courses;
  return Expanded(
    child: ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return ListTile(
          leading: Icon(
            item['status'] == "done"
                ? Icons.check_circle
                : item['status'] == 'active'
                ? Icons.run_circle
                : Icons.calendar_month_rounded,
          ),
          title: Text(item['title'] as String),
          subtitle: Text(item['code'] as String),
          trailing: Text(
            "${item['credits']} SKS",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        );
      },
    ),
  );
}

class CompactLayout extends StatelessWidget {
  const CompactLayout({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Compact $studentName - $studentId',
            style: TextStyle(color: Colors.red),
          ),
          const Icon(Icons.phone, color: Colors.red),
        ],
      ),
    );
  }
}

class MediumLayout extends StatelessWidget {
  const MediumLayout({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Medium $studentName - $studentId',
            style: TextStyle(color: Colors.orange),
          ),
          const Icon(Icons.tablet, color: Colors.orange),
        ],
      ),
    );
  }
}

class ExpandedLayout extends StatelessWidget {
  const ExpandedLayout({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Expanded $studentName - $studentId',
            style: TextStyle(color: Colors.green),
          ),
          const Icon(Icons.desktop_mac, color: Colors.green),
        ],
      ),
    );
  }
}

class ProfileCard extends StatefulWidget {
  const new({super.key});

  @override
  State<ProfileCard> createState() => ProfileCardState();
}

class ProfileCardState extends State<ProfileCard> {
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: studentFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
        }

        int columnsFor(double width) {
    if (width < 600) return 1;
    if (width < 840) return 2;
    return 3;
  }

        final data = snapshot.data!;
        final student = data['student'] as Map<String, dynamic>;
        final courses = data['courses'] as List<dynamic>;

        final int totalCourses = courses.length;
        final int doneCourses = courses
            .where((c) => c['status'] == 'done')
            .length;
        final double progressPercent = totalCourses > 0
            ? (doneCourses / totalCourses) * 100
            : 0.0;

        final size = MediaQuery.of(context).size;
        final orientation = MediaQuery.of(context).orientation;

        final List<String> skills = ['Pemrograman', 'Editing', 'photography', 'music', 'videography', 'learn'];

        return Column(
          children: [
            
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Width: ${size.width.toStringAsFixed(0)}'),
                  Text('Height: ${size.height.toStringAsFixed(0)}'),
                  Text('Orientation: $orientation'),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 600) {
                        return const CompactLayout();
                      } else if (constraints.maxWidth < 840) {
                        return const MediumLayout();
                      } else {
                        return const ExpandedLayout();
                      }
                    },
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(flex: 2, child: buildBox('A')),
                const SizedBox(width: 8),
                Expanded(child: buildBox('B')),
              ],
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.map((e) => Chip(label: Text(e))).toList(),
            ),
            Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columnsFor(constraints.maxWidth),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2.5,
                      ),
                      itemCount: courses.length,
                      itemBuilder: (context, index) => CourseCard(course: courses[index]),
                    );
                  },
                ),
              ),
            buildProfileDetail(student),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Flutter UI Fundamental",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("Pertemuan 4", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            "Total Courses",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "$totalCourses",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    color: Colors.green.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            "Progress Done",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${progressPercent.toStringAsFixed(0)}%",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "Daftar Materi",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            buildCoursesList(courses),
          ],
        );
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            'Learning Dashboard',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: ProfileCard(),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              course['title'] as String,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text('Kode: ${course['code']}', style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}