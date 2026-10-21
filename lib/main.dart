import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/course_provider.dart';
import 'core/services/course_api_service.dart';
import 'core/repositories/course_repository.dart';
import 'screens/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/services/course_supabase_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    publishableKey: dotenv.env['PUBLISHABLE_KEY'] ?? '',
  );

const String baseUrl = 'https://6ad720f1f71f154ac487d451.mockapi.io/api/';

  final courseRepository = CourseRepository(CourseSupabaseService());

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