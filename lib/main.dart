import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/course_provider.dart';
import 'core/services/course_service.dart';
import 'core/repositories/course_repository.dart';
import 'screens/home_page.dart';

void main() {
  final courseService = CourseService();
  final courseRepository = CourseRepository(courseService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CourseProvider(courseRepository)..loadCourses(),
        ),
        Provider<CourseRepository>.value(value: courseRepository),
      ],
      child: const MaterialApp(home: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NavigationApp(),
    );
  }
}