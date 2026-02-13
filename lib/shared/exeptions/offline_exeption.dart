class OfflineException implements Exception {
  final String message;
  OfflineException([this.message = 'No internet connection']);

  @override
  String toString() => message;
}
