import 'package:flutter/material.dart';

import '../models/lecture.dart';

/// A single lecture row within a course's detail screen.
class LectureTile extends StatelessWidget {
  const LectureTile({
    super.key,
    required this.lecture,
    this.isCompleted = false,
    this.onTap,
  });

  final Lecture lecture;
  final bool isCompleted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isCompleted
            ? Theme.of(context).colorScheme.primaryContainer
            : null,
        child: isCompleted
            ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
            : Text('${lecture.order}'),
      ),
      title: Text(lecture.title),
      subtitle: Text('${lecture.durationMinutes} min'),
      trailing: const Icon(Icons.play_circle_outline),
      onTap: onTap,
    );
  }
}
