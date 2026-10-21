import '../models/course.dart';
import 'course_data_source.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class CourseSupabaseService implements CourseDataSource {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<List<Course>> getCourses() async {
    final response = await _supabase.from('courses').select().order('id');

    final List data = response as List;
    return data.map((e) => Course.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<Course> createCourse(Course course) async {
    final response = await _supabase
        .from('courses')
        .insert(course.toJson())
        .select()
        .single();

    return Course.fromJson(response);
  }

  @override
  Future<void> updateCourse(int? id, Course course) async {
    if (id == null) throw Exception('ID course tidak boleh null');

    await _supabase.from('courses').update(course.toJson()).eq('id', id);
  }

  @override
  Future<void> deleteCourse(int? id) async {
    if (id == null) throw Exception('ID course tidak boleh null');

    await _supabase.from('courses').delete().eq('id', id);
  }
}
