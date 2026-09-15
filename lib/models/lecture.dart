/// A single video lecture belonging to a course, as returned by
/// GET /lectures?courseId=:id.
class Lecture {
  const Lecture({
    required this.id,
    required this.courseId,
    required this.title,
    required this.videoUrl,
    required this.durationMinutes,
    required this.order,
  });

  final String id;
  final String courseId;
  final String title;
  final String videoUrl;
  final int durationMinutes;

  /// Position of this lecture within its course's lecture list (1-based).
  final int order;

  factory Lecture.fromJson(Map<String, dynamic> json) {
    return Lecture(
      id: json['id'].toString(),
      courseId: json['courseId'].toString(),
      title: json['title'] as String,
      videoUrl: json['videoUrl'] as String,
      durationMinutes: json['durationMinutes'] as int,
      order: json['order'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'courseId': courseId,
    'title': title,
    'videoUrl': videoUrl,
    'durationMinutes': durationMinutes,
    'order': order,
  };
}
