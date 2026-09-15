/// A single LMS course, as returned by GET /courses.
class Course {
  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.category,
    required this.level,
    required this.thumbnailUrl,
    required this.durationMinutes,
  });

  final String id;
  final String title;
  final String description;
  final String instructor;
  final String category;
  final String level;
  final String thumbnailUrl;
  final int durationMinutes;

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'].toString(),
      title: json['title'] as String,
      description: json['description'] as String,
      instructor: json['instructor'] as String,
      category: json['category'] as String,
      level: json['level'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      durationMinutes: json['durationMinutes'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'instructor': instructor,
    'category': category,
    'level': level,
    'thumbnailUrl': thumbnailUrl,
    'durationMinutes': durationMinutes,
  };
}
