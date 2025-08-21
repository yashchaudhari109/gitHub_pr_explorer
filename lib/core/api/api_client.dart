import 'dart:convert';
import 'dart:io';

import 'package:github_pr_explorer/core/error/exceptions.dart';
import 'package:http/http.dart' as http;

/// A wrapper around the http client to handle API requests,
/// response parsing, and error handling.
class ApiClient {
  final http.Client _client;

  ApiClient(this._client);

  /// Performs a GET request.
  ///
  /// Decodes the JSON response if the status code is 200.
  /// Throws a [ServerException] with the status code for non-200 responses
  /// or other network issues.
  Future<dynamic> get(Uri uri) async {
    try {
      final response = await _client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/vnd.github.v3+json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw ServerException(
          message: 'Error from API: Status Code ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw ServerException(
        message: 'No Internet connection. Please check your network.',
      );
    } on FormatException {
      throw ServerException(
        message: 'Invalid response format from the server.',
      );
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'An unknown error occurred: $e');
    }
  }
}
