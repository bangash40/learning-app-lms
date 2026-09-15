/// Thrown by [LmsApiService] when a request to the LMS REST backend fails,
/// either because the server couldn't be reached or it returned an error
/// status. The message is safe to show directly in the UI.
class ApiException implements Exception {
  ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
