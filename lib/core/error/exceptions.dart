/// Represents an exception that occurs during an API call.
class ServerException implements Exception {
  final String message;
  final int? statusCode; // Can be null for non-HTTP errors like no internet

  ServerException({required this.message, this.statusCode});

  @override
  String toString() =>
      'ServerException(message: $message, statusCode: $statusCode)';
}

/// Represents an exception for when no data is found from a local source.
class CacheException implements Exception {
  final String message;

  CacheException({this.message = "Could not retrieve data from cache."});

  @override
  String toString() => message;
}
