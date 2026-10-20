import '../models/course.dart';

abstract class CourseDataSource {
  Future<List<Course>> getCourses();
  Future<Course> createCourse(Course course);
  Future<void> updateCourse(String? id, Course course);
  Future<void> deleteCourse(String? id);
}