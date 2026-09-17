import 'package:flutter/material.dart';

import '../models/quiz.dart';
import '../services/api_exception.dart';
import '../services/lms_api_service.dart';
import '../services/progress_service.dart';
import '../widgets/error_view.dart';
import '../widgets/quiz_option_tile.dart';

/// Lets the user attempt a course's quiz one question at a time. The score
/// is shown live as each answer is locked in, and a summary appears once
/// every question has been answered. The result is saved to
/// [ProgressService] as soon as the quiz is finished.
class QuizScreen extends StatefulWidget {
  const QuizScreen({
    super.key,
    required this.courseId,
    required this.apiService,
    required this.progressService,
  });

  final String courseId;
  final LmsApiService apiService;
  final ProgressService progressService;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<Quiz?> _quizFuture;

  @override
  void initState() {
    super.initState();
    _quizFuture = widget.apiService.getQuizForCourse(widget.courseId);
  }

  void _retry() {
    setState(() {
      _quizFuture = widget.apiService.getQuizForCourse(widget.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Quiz?>(
      future: _quizFuture,
      builder: (context, snapshot) {
        final quiz = snapshot.data;
        return Scaffold(
          appBar: AppBar(title: Text(quiz?.title ?? 'Quiz')),
          body: _buildBody(snapshot),
        );
      },
    );
  }

  Widget _buildBody(AsyncSnapshot<Quiz?> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      final error = snapshot.error;
      return ErrorView(
        message: error is ApiException ? error.message : 'Failed to load quiz.',
        onRetry: _retry,
      );
    }
    final quiz = snapshot.data;
    if (quiz == null || quiz.questions.isEmpty) {
      return const Center(
        child: Text('No quiz available for this course yet.'),
      );
    }
    // Keyed on quiz.id so a retry with a different quiz starts fresh.
    return _QuizAttempt(
      key: ValueKey(quiz.id),
      quiz: quiz,
      courseId: widget.courseId,
      progressService: widget.progressService,
    );
  }
}

class _QuizAttempt extends StatefulWidget {
  const _QuizAttempt({
    super.key,
    required this.quiz,
    required this.courseId,
    required this.progressService,
  });

  final Quiz quiz;
  final String courseId;
  final ProgressService progressService;

  @override
  State<_QuizAttempt> createState() => _QuizAttemptState();
}

class _QuizAttemptState extends State<_QuizAttempt> {
  late List<int?> _selectedOptions;
  int _currentIndex = 0;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _selectedOptions = List<int?>.filled(widget.quiz.questions.length, null);
  }

  void _restart() {
    setState(() {
      _selectedOptions = List<int?>.filled(
        widget.quiz.questions.length,
        null,
      );
      _currentIndex = 0;
      _isFinished = false;
    });
  }

  int get _score {
    var score = 0;
    for (var i = 0; i < widget.quiz.questions.length; i++) {
      if (_selectedOptions[i] == widget.quiz.questions[i].correctOptionIndex) {
        score++;
      }
    }
    return score;
  }

  int get _answeredCount => _selectedOptions.where((a) => a != null).length;

  void _selectOption(int optionIndex) {
    if (_selectedOptions[_currentIndex] != null) return;
    setState(() {
      _selectedOptions[_currentIndex] = optionIndex;
    });
  }

  void _goNext() {
    if (_currentIndex == widget.quiz.questions.length - 1) {
      setState(() => _isFinished = true);
      widget.progressService.saveQuizResult(
        courseId: widget.courseId,
        score: _score,
        total: widget.quiz.questions.length,
      );
    } else {
      setState(() => _currentIndex++);
    }
  }

  QuizOptionState _optionStateFor(
    QuizQuestion question,
    int? selected,
    int optionIndex,
  ) {
    if (selected == null) return QuizOptionState.unanswered;
    if (optionIndex == question.correctOptionIndex) {
      return QuizOptionState.correct;
    }
    if (optionIndex == selected) return QuizOptionState.incorrectSelected;
    return QuizOptionState.incorrectUnselected;
  }

  @override
  Widget build(BuildContext context) {
    final questions = widget.quiz.questions;

    if (_isFinished) {
      return _QuizResults(
        score: _score,
        total: questions.length,
        onRetake: _restart,
      );
    }

    final question = questions[_currentIndex];
    final selected = _selectedOptions[_currentIndex];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: _answeredCount / questions.length,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Question ${_currentIndex + 1} of ${questions.length}'),
                  Text('Score: $_score / $_answeredCount'),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              question.question,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView(
            children: [
              for (var i = 0; i < question.options.length; i++)
                QuizOptionTile(
                  label: question.options[i],
                  state: _optionStateFor(question, selected, i),
                  onTap: selected == null ? () => _selectOption(i) : null,
                ),
            ],
          ),
        ),
        if (selected != null)
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _goNext,
                child: Text(
                  _currentIndex == questions.length - 1
                      ? 'Finish'
                      : 'Next Question',
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _QuizResults extends StatelessWidget {
  const _QuizResults({
    required this.score,
    required this.total,
    required this.onRetake,
  });

  final int score;
  final int total;
  final VoidCallback onRetake;

  @override
  Widget build(BuildContext context) {
    final percent = total == 0 ? 0 : ((score / total) * 100).round();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              percent >= 70 ? Icons.emoji_events : Icons.school,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'You scored $score / $total',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text('$percent%', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onRetake,
                child: const Text('Retake Quiz'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Back to Course'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
