import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

class HttpService {
  // Make a GET request with an optional bearer token
  Future<http.Response> get(
    Uri url, {
    Map<String, String>? headers,
    String? token,
  }) async {
    headers ??= {};

    // Always set Accept header for JSON response
    headers['Accept'] = 'application/json';

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
      log('Adding Authorization header with token: Bearer $token');
    }

    try {
      final response = await http.get(url, headers: headers);
      log("Used URL: ${url.toString()}");
      log("Response Status Code: ${response.statusCode}");

      return response;
    } on SocketException {
      log('No Internet Connection');
      rethrow;
    } catch (e) {
      log('Error during GET request: $e');
      rethrow;
    }
  }
}
