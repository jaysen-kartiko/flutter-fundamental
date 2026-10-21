import '../models/course.dart';
import 'course_data_source.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class CourseSupabaseService implements CourseDataSource {
  final SupabaseClient _supabase = Supabase.instance.client;

Future<T> _handleSupabaseRequest<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on PostgrestException catch (e) {
      if (e.code == '42501') {
        throw Exception('Error RLS: Akses ditolak oleh policy database.');
      }
      if (e.code == '23505' || e.code == '23514') {
        throw Exception('Error Validasi: Data duplikat atau melanggar constraint database.');
      }
      if (e.code == '404' || e.code == 'PGRST205' || e.message.contains('404')) {
        throw Exception('Error 404: Endpoint atau tabel tidak ditemukan.');
      }
      throw Exception('Database error: ${e.message}');
    } on FormatException catch (_) {
      throw Exception('Error Mapping JSON: Gagal melakukan parsing data dari server.');
    } on TypeError catch (_) {
      throw Exception('Error Tipe Data: Ketidaksesuaian tipe key pada JSON.');
    } catch (e) {
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('clientexception') || errorStr.contains('failed to fetch') || errorStr.contains('socketexception') || errorStr.contains('failed host lookup') || errorStr.contains('network') || errorStr.contains('err_internet_disconnected')) {
        throw Exception('Error Koneksi: Tidak ada koneksi internet atau gagal terhubung ke server.');
      }
      if (errorStr.contains('404') || errorStr.contains('not found')) {
        throw Exception('Error 404: URL Supabase tidak valid.');
      }
      rethrow;
    }
  }
  @override
  Future<List<Course>> getCourses() async {
    return _handleSupabaseRequest(() async {
      final response = await _supabase.from('courses').select().order('id');
      final List data = response as List;
      return data.map((e) => Course.fromJson(e as Map<String, dynamic>)).toList();
    });
  }

  @override
  Future<Course> createCourse(Course course) async {
    return _handleSupabaseRequest(() async {
      final response = await _supabase
          .from('courses')
          .insert(course.toJson())
          .select()
          .single();

      return Course.fromJson(response);
    });
  }

  @override
  Future<void> updateCourse(int? id, Course course) async {
    if (id == null) throw Exception('ID course tidak boleh null');

    await _handleSupabaseRequest(() async {
      await _supabase.from('courses').update(course.toJson()).eq('id', id);
    });
  }

  @override
  Future<void> deleteCourse(int? id) async {
    if (id == null) throw Exception('ID course tidak boleh null');

    await _handleSupabaseRequest(() async {
      await _supabase.from('courses').delete().eq('id', id);
    });
  }
}