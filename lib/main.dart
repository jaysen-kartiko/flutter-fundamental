import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

Future<Map<String, dynamic>> loadStudentData() async {
  final jsonString = await rootBundle.loadString(
    'assets/data/student_dataa.json',
  );
  return jsonDecode(jsonString) as Map<String, dynamic>;
}

const String studentName = 'Jaysen Natanael Kartiko';
const String studentId = '2415051028';

void main() {
  runApp(const MyApp());
}

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

        return Column(
          children: [
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
