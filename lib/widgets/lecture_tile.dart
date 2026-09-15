import 'package:flutter/material.dart';

import '../models/lecture.dart';

/// A single lecture row within a course's detail screen.
/// [onTap] is left unwired until the video player is added (Step 5).
class LectureTile extends StatelessWidget {
  const LectureTile({super.key, required this.lecture, this.onTap});

  final Lecture lecture;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text('${lecture.order}')),
      title: Text(lecture.title),
      subtitle: Text('${lecture.durationMinutes} min'),
      trailing: const Icon(Icons.play_circle_outline),
      onTap: onTap,
    );
  }
}
