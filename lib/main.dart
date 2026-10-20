import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/course_provider.dart';
import 'core/services/course_api_service.dart';
import 'core/repositories/course_repository.dart';
import 'screens/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/services/course_supabase_service.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://bblrvfymsemnrgbycemc.supabase.co',
    publishableKey: 'sb_publishable_QmcrnhOcKBPXKkGaCXqVfQ_ku6V-JGz',
  );

const String baseUrl = 'https://6ad720f1f71f154ac487d451.mockapi.io/api/';

  final courseRepository = CourseRepository(CourseApiService(baseUrl));

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