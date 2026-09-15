/// One multiple-choice question within a [Quiz].
class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
  });

  final String id;
  final String question;
  final List<String> options;

  /// Index into [options] of the correct answer.
  final int correctOptionIndex;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'].toString(),
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      correctOptionIndex: json['correctOptionIndex'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'question': question,
    'options': options,
    'correctOptionIndex': correctOptionIndex,
  };
}

/// A quiz attached to a course, as returned by GET /quizzes?courseId=:id.
class Quiz {
  const Quiz({
    required this.id,
    required this.courseId,
    required this.title,
    required this.questions,
  });

  final String id;
  final String courseId;
  final String title;
  final List<QuizQuestion> questions;

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'].toString(),
      courseId: json['courseId'].toString(),
      title: json['title'] as String,
      questions: (json['questions'] as List)
          .map((q) => QuizQuestion.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'courseId': courseId,
    'title': title,
    'questions': questions.map((q) => q.toJson()).toList(),
  };
}
