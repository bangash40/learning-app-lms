import 'package:flutter/material.dart';

import '../models/course.dart';
import '../models/course_progress.dart';
import '../models/lecture.dart';
import '../services/api_exception.dart';
import '../services/lms_api_service.dart';
import '../services/progress_service.dart';
import '../widgets/error_view.dart';
import '../widgets/lecture_tile.dart';
import 'quiz_screen.dart';
import 'video_player_screen.dart';

/// Shows a single course's details plus its list of lectures.
/// Tapping a lecture opens [VideoPlayerScreen] to play it, and each lecture
/// shows a checkmark once [ProgressService] reports it as watched.
class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({
    super.key,
    required this.course,
    required this.apiService,
    required this.progressService,
  });

  final Course course;
  final LmsApiService apiService;
  final ProgressService progressService;

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late Future<List<Lecture>> _lecturesFuture;

  @override
  void initState() {
    super.initState();
    _lecturesFuture = widget.apiService.getLecturesForCourse(
      widget.course.id,
    );
  }

  void _retry() {
    setState(() {
      _lecturesFuture = widget.apiService.getLecturesForCourse(
        widget.course.id,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    return Scaffold(
      appBar: AppBar(title: Text(course.title)),
      body: StreamBuilder<CourseProgress>(
        stream: widget.progressService.watchCourseProgress(course.id),
        builder: (context, progressSnapshot) {
          final progress =
              progressSnapshot.data ?? CourseProgress.empty(course.id);
          return ListView(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  course.thumbnailUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.broken_image_outlined, size: 48),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'by ${course.instructor}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        Chip(label: Text(course.category)),
                        Chip(label: Text(course.level)),
                        Chip(
                          label: Text('${course.durationMinutes} min total'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      course.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Lectures',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<Lecture>>(
                future: _lecturesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (snapshot.hasError) {
                    final error = snapshot.error;
                    return ErrorView(
                      message: error is ApiException
                          ? error.message
                          : 'Failed to load lectures.',
                      onRetry: _retry,
                    );
                  }
                  final lectures = snapshot.data ?? [];
                  if (lectures.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: Text('No lectures yet for this course.'),
                      ),
                    );
                  }
                  return Column(
                    children: lectures
                        .map(
                          (lecture) => LectureTile(
                            lecture: lecture,
                            isCompleted: progress.isLectureComplete(
                              lecture.id,
                            ),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => VideoPlayerScreen(
                                  lecture: lecture,
                                  progressService: widget.progressService,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
              if (progress.hasQuizResult)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Text(
                    'Last quiz score: ${progress.quizScore} / ${progress.quizTotal}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.quiz_outlined),
                    label: Text(
                      progress.hasQuizResult ? 'Retake Quiz' : 'Take Quiz',
                    ),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => QuizScreen(
                          courseId: course.id,
                          apiService: widget.apiService,
                          progressService: widget.progressService,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
