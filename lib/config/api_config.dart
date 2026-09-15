/// Central place for the LMS REST API base URL and endpoint paths.
///
/// The mock backend (json-server / mockapi.io — see mock_backend/README.md)
/// is a drop-in stand-in for the real Internee.pk LMS API. To point the app
/// at a different backend later, change ONLY the values below — no other
/// file in the app should ever hardcode a URL.
class ApiConfig {
  ApiConfig._();

  /// Base URL of the LMS REST backend. Pick the one that matches how you're
  /// running the mock backend (see mock_backend/README.md for setup):
  ///
  /// - Android emulator + local json-server:  http://10.0.2.2:3000
  /// - iOS simulator + local json-server:      http://localhost:3000
  /// - Physical device + local json-server:    http://`your-computer-LAN-IP`:3000
  /// - mockapi.io:                             https://`your-project-id`.mockapi.io/api/v1
  static const String baseUrl = 'http://10.0.2.2:3000';

  static const String coursesPath = '/courses';
  static const String lecturesPath = '/lectures';
  static const String quizzesPath = '/quizzes';

  static Uri courses() => Uri.parse('$baseUrl$coursesPath');

  static Uri courseById(String id) => Uri.parse('$baseUrl$coursesPath/$id');

  static Uri lecturesForCourse(String courseId) =>
      Uri.parse('$baseUrl$lecturesPath').replace(
        queryParameters: {'courseId': courseId},
      );

  static Uri quizzesForCourse(String courseId) =>
      Uri.parse('$baseUrl$quizzesPath').replace(
        queryParameters: {'courseId': courseId},
      );
}
