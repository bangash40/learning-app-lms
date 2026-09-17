import 'package:flutter/material.dart';

/// Visual state of a single quiz option, set once an answer is locked in so
/// the correct/incorrect choice is highlighted immediately.
enum QuizOptionState {
  unanswered,
  correct,
  incorrectSelected,
  incorrectUnselected,
}

class QuizOptionTile extends StatelessWidget {
  const QuizOptionTile({
    super.key,
    required this.label,
    required this.state,
    required this.onTap,
  });

  final String label;
  final QuizOptionState state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    Color? tileColor;
    IconData? trailingIcon;
    Color? iconColor;

    switch (state) {
      case QuizOptionState.unanswered:
        break;
      case QuizOptionState.correct:
        tileColor = colorScheme.primaryContainer;
        trailingIcon = Icons.check_circle;
        iconColor = colorScheme.primary;
      case QuizOptionState.incorrectSelected:
        tileColor = colorScheme.errorContainer;
        trailingIcon = Icons.cancel;
        iconColor = colorScheme.error;
      case QuizOptionState.incorrectUnselected:
        break;
    }

    return Card(
      color: tileColor,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Text(label),
        trailing: trailingIcon == null
            ? null
            : Icon(trailingIcon, color: iconColor),
        onTap: onTap,
      ),
    );
  }
}
