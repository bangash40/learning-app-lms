/// A user's progress within a single course: which lectures they've
/// finished watching, and their latest quiz result (if attempted).
class CourseProgress {
  const CourseProgress({
    required this.courseId,
    required this.completedLectureIds,
    this.quizScore,
    this.quizTotal,
  });

  final String courseId;
  final Set<String> completedLectureIds;
  final int? quizScore;
  final int? quizTotal;

  bool get hasQuizResult => quizScore != null && quizTotal != null;

  bool isLectureComplete(String lectureId) =>
      completedLectureIds.contains(lectureId);

  factory CourseProgress.empty(String courseId) =>
      CourseProgress(courseId: courseId, completedLectureIds: const {});

  factory CourseProgress.fromMap(String courseId, Map<String, dynamic>? data) {
    if (data == null) return CourseProgress.empty(courseId);
    return CourseProgress(
      courseId: courseId,
      completedLectureIds: Set<String>.from(
        (data['completedLectureIds'] as List?) ?? const [],
      ),
      quizScore: data['quizScore'] as int?,
      quizTotal: data['quizTotal'] as int?,
    );
  }
}
