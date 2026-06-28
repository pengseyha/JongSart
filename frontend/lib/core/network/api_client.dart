import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';

/// Thrown when a request fails. Carries a human-readable [message] that is safe
/// to show in the UI, plus the optional HTTP [statusCode].
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// A thin HTTP wrapper around `package:http`.
///
/// Adds JSON headers, a request timeout, and readable error handling. It does
/// not know anything about the app — it just sends GET/POST/PATCH and returns
/// decoded JSON (or throws an [ApiException] with a friendly message).
class ApiClient {
  ApiClient({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? ApiConfig.baseUrl;

  final http.Client _client;
  final String _baseUrl;

  static const Map<String, String> _jsonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<dynamic> get(String path) => _send('GET', path);

  Future<dynamic> post(String path, Map<String, dynamic> body) =>
      _send('POST', path, body);

  Future<dynamic> patch(String path, Map<String, dynamic> body) =>
      _send('PATCH', path, body);

  Future<dynamic> _send(
    String method,
    String path, [
    Map<String, dynamic>? body,
  ]) async {
    final uri = Uri.parse('$_baseUrl$path');
    final encoded = body == null ? null : jsonEncode(body);

    try {
      final http.Response response;
      switch (method) {
        case 'POST':
          response = await _client
              .post(uri, headers: _jsonHeaders, body: encoded)
              .timeout(ApiConfig.timeout);
          break;
        case 'PATCH':
          response = await _client
              .patch(uri, headers: _jsonHeaders, body: encoded)
              .timeout(ApiConfig.timeout);
          break;
        case 'GET':
        default:
          response = await _client
              .get(uri, headers: _jsonHeaders)
              .timeout(ApiConfig.timeout);
      }
      return _handleResponse(response);
    } on TimeoutException {
      throw const ApiException(
        'Request timed out. Please make sure the backend is running.',
      );
    } on http.ClientException catch (e) {
      throw ApiException('Network error: ${e.message}');
    } on FormatException {
      throw const ApiException('Received an invalid response from the server.');
    }
  }

  dynamic _handleResponse(http.Response response) {
    final status = response.statusCode;
    final decoded = response.body.isEmpty ? null : jsonDecode(response.body);

    if (status >= 200 && status < 300) {
      return decoded;
    }

    // NestJS errors look like { "message": "...", "statusCode": 400 }.
    var message = 'Request failed (HTTP $status).';
    if (decoded is Map && decoded['message'] != null) {
      final raw = decoded['message'];
      message = raw is List ? raw.join(', ') : raw.toString();
    }
    throw ApiException(message, statusCode: status);
  }

  /// Releases the underlying HTTP client. Call when the client is disposed.
  void close() => _client.close();
}
