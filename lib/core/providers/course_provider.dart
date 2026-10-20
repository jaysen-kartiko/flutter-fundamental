import 'package:flutter/material.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;

  CourseProvider(this.repository);

  List<Course> courses = [];
  final Set<String> favorites = {};
  bool isLoading = false;
  String? error;
  bool isSaving = false;

  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      courses = await repository.getCourses();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<bool> createCourse(Course newCourse) async {
    isSaving = true;
    notifyListeners();

    try {
      await repository.createCourse(newCourse);

      await loadCourses();
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
Future<bool> updateCourse(String? id, Course updatedCourse) async {
  isSaving = true;
  error = null;
  notifyListeners();

  try {
    await repository.updateCourse(id, updatedCourse);
    await loadCourses(); 
    return true;
  } catch (e) {
    error = e.toString();
    return false;
  } finally {
    isSaving = false;
    notifyListeners();
  }
}

Future<bool> deleteCourse(String? id, String code) async {
    isSaving = true;
    error = null;
    notifyListeners();

    try {
      await repository.deleteCourse(id);

      if (favorites.contains(code)) {
        favorites.remove(code);
      }

      await loadCourses();
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  bool isFavorite(String code) => favorites.contains(code);

  void toggleFavorite(String id) {
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    notifyListeners();
  }
}
