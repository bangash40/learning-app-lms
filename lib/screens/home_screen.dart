import 'package:flutter/material.dart';

import '../models/course.dart';
import '../services/api_exception.dart';
import '../services/auth_service.dart';
import '../services/lms_api_service.dart';
import '../services/progress_service.dart';
import '../widgets/course_card.dart';
import '../widgets/error_view.dart';
import 'course_detail_screen.dart';

/// Landing screen shown once a user is signed in: browse the courses
/// fetched from the LMS REST API. Tap a course to see its detail view.
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.authService,
    required this.apiService,
    required this.progressService,
  });

  final AuthService authService;
  final LmsApiService apiService;
  final ProgressService progressService;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Course>> _coursesFuture;

  @override
  void initState() {
    super.initState();
    _coursesFuture = widget.apiService.getCourses();
  }

  void _retry() {
    setState(() {
      _coursesFuture = widget.apiService.getCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: _retry,
          ),
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: widget.authService.signOut,
          ),
        ],
      ),
      body: FutureBuilder<List<Course>>(
        future: _coursesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            final error = snapshot.error;
            return ErrorView(
              message: error is ApiException
                  ? error.message
                  : 'Failed to load courses.',
              onRetry: _retry,
            );
          }
          final courses = snapshot.data ?? [];
          if (courses.isEmpty) {
            return const Center(child: Text('No courses available yet.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return CourseCard(
                course: course,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CourseDetailScreen(
                      course: course,
                      apiService: widget.apiService,
                      progressService: widget.progressService,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
