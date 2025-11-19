import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_config.dart';
import '../errors/exceptions.dart';

class NodeApiClient {
  final String baseUrl;

  NodeApiClient({
    String? baseUrl,
  }) : baseUrl = baseUrl ?? ApiConfig.nodeApiBaseUrl;

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
    String? token,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final requestHeaders = {...ApiConfig.headers, ...?headers};
      
      if (token != null) {
        requestHeaders['Authorization'] = 'Bearer $token';
      }

      final response = await http
          .get(
            uri,
            headers: requestHeaders,
          )
          .timeout(ApiConfig.timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    String? token,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final requestHeaders = {...ApiConfig.headers, ...?headers};
      
      if (token != null) {
        requestHeaders['Authorization'] = 'Bearer $token';
      }

      final response = await http
          .post(
            uri,
            headers: requestHeaders,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      final decoded = jsonDecode(response.body);
      if (decoded is List) {
        return {'data': decoded};
      }
      return decoded as Map<String, dynamic>;
    } else {
      String errorMessage = 'Error del servidor: ${response.statusCode}';
      try {
        final errorBody = jsonDecode(response.body);
        if (errorBody is Map && errorBody.containsKey('message')) {
          errorMessage = errorBody['message'].toString();
        } else if (errorBody is Map && errorBody.containsKey('detail')) {
          errorMessage = errorBody['detail'].toString();
        }
      } catch (_) {
        // Si no se puede parsear el error, usar el mensaje por defecto
      }
      throw ServerException(
        message: errorMessage,
        statusCode: response.statusCode,
      );
    }
  }

  Exception _handleError(dynamic error) {
    if (error is ServerException) {
      return error;
    } else if (error is http.ClientException || error.toString().contains('SocketException')) {
      return NetworkException(message: 'Error de conexión. Verifique su conexión a internet.');
    } else if (error.toString().contains('TimeoutException') || error.toString().contains('timeout')) {
      return NetworkException(message: 'Tiempo de espera agotado. Intente nuevamente.');
    } else if (error is Exception) {
      return NetworkException(message: 'Error de red: ${error.toString()}');
    } else {
      return NetworkException(message: 'Error de conexión: $error');
    }
  }
}

