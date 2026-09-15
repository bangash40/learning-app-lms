import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/course.dart';
import '../models/lecture.dart';
import '../models/quiz.dart';
import 'api_exception.dart';

/// REST API service for the LMS backend (courses, lectures, quizzes).
///
/// This is the ONLY place in the app that talks HTTP — screens and widgets
/// call these methods and never build a URL or parse JSON themselves.
/// Swapping the mock backend for the real Internee.pk LMS later only
/// requires changing [ApiConfig]; this file's public API stays the same.
class LmsApiService {
  LmsApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<Course>> getCourses() async {
    final response = await _get(ApiConfig.courses());
    final data = jsonDecode(response.body) as List;
    return data
        .map((json) => Course.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Course> getCourseById(String id) async {
    final response = await _get(ApiConfig.courseById(id));
    return Course.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<List<Lecture>> getLecturesForCourse(String courseId) async {
    final response = await _get(ApiConfig.lecturesForCourse(courseId));
    final data = jsonDecode(response.body) as List;
    final lectures = data
        .map((json) => Lecture.fromJson(json as Map<String, dynamic>))
        .toList();
    lectures.sort((a, b) => a.order.compareTo(b.order));
    return lectures;
  }

  /// Returns the quiz attached to [courseId], or null if the course has none.
  Future<Quiz?> getQuizForCourse(String courseId) async {
    final response = await _get(ApiConfig.quizzesForCourse(courseId));
    final data = jsonDecode(response.body) as List;
    if (data.isEmpty) return null;
    return Quiz.fromJson(data.first as Map<String, dynamic>);
  }

  Future<http.Response> _get(Uri uri) async {
    final http.Response response;
    try {
      response = await _client.get(uri).timeout(const Duration(seconds: 10));
    } catch (_) {
      throw ApiException(
        'Could not reach the LMS server. Check your connection and the '
        'API base URL in lib/config/api_config.dart.',
      );
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        'LMS server returned an error (${response.statusCode}).',
      );
    }
    return response;
  }

  void dispose() => _client.close();
}
