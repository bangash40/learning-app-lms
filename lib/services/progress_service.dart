import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/course_progress.dart';

/// Reads and writes the signed-in user's learning progress in Cloud
/// Firestore, under users/{uid}/courseProgress/{courseId}. Firestore's
/// security rules (see firestore.rules) restrict each user to their own
/// subtree, so [uidProvider] must return the current signed-in user's uid —
/// this service is only ever used from screens reachable after sign-in.
class ProgressService {
  ProgressService({FirebaseFirestore? firestore, required this.uidProvider})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  final String Function() uidProvider;

  CollectionReference<Map<String, dynamic>> get _courseProgress => _firestore
      .collection('users')
      .doc(uidProvider())
      .collection('courseProgress');

  Stream<CourseProgress> watchCourseProgress(String courseId) {
    return _courseProgress
        .doc(courseId)
        .snapshots()
        .map((doc) => CourseProgress.fromMap(courseId, doc.data()));
  }

  Future<void> markLectureComplete(String courseId, String lectureId) {
    return _courseProgress.doc(courseId).set({
      'completedLectureIds': FieldValue.arrayUnion([lectureId]),
    }, SetOptions(merge: true));
  }

  Future<void> saveQuizResult({
    required String courseId,
    required int score,
    required int total,
  }) {
    return _courseProgress.doc(courseId).set({
      'quizScore': score,
      'quizTotal': total,
      'quizCompletedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
