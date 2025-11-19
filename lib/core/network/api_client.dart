import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_config.dart';
import '../errors/exceptions.dart';
import '../services/auth_service.dart';

class ApiClient {
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  ApiClient({String? baseUrl, Map<String, String>? headers})
    : baseUrl = baseUrl ?? ApiConfig.fastApiBaseUrl,
      defaultHeaders = headers ?? ApiConfig.headers;

  // Obtener headers con token JWT
  Future<Map<String, String>> _getHeaders({
    Map<String, String>? additionalHeaders,
  }) async {
    final headers = {...defaultHeaders, ...?additionalHeaders};
    final token = await AuthService.getToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final requestHeaders = await _getHeaders(additionalHeaders: headers);
      final response = await http
          .get(uri, headers: requestHeaders)
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
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final requestHeaders = await _getHeaders(additionalHeaders: headers);
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

  Future<Map<String, dynamic>> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final requestHeaders = await _getHeaders(additionalHeaders: headers);
      final response = await http
          .patch(
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

  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final requestHeaders = await _getHeaders(additionalHeaders: headers);
      final response = await http
          .delete(uri, headers: requestHeaders)
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
      try {
        final decoded = jsonDecode(response.body);
        // Si la respuesta es una lista, la envuelve en un mapa
        if (decoded is List) {
          return {'data': decoded};
        }
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
        // Si no es un mapa ni una lista, devolver vacío
        return {};
      } catch (e) {
        throw ServerException(
          message: 'Error al parsear la respuesta del servidor: $e',
          statusCode: response.statusCode,
        );
      }
    } else {
      String errorMessage = 'Error del servidor: ${response.statusCode}';
      try {
        if (response.body.isNotEmpty) {
          final errorBody = jsonDecode(response.body);
          if (errorBody is Map) {
            if (errorBody.containsKey('detail')) {
              errorMessage = errorBody['detail'].toString();
              // Si detail es una lista o un objeto, extraer el mensaje
              if (errorMessage.contains('{') || errorMessage.contains('[')) {
                if (errorBody['detail'] is List &&
                    (errorBody['detail'] as List).isNotEmpty) {
                  errorMessage = (errorBody['detail'] as List).first.toString();
                } else if (errorBody['detail'] is Map) {
                  final detailMap = errorBody['detail'] as Map;
                  errorMessage = detailMap.values.first.toString();
                }
              }
            } else if (errorBody.containsKey('message')) {
              errorMessage = errorBody['message'].toString();
            } else if (errorBody.containsKey('msg')) {
              errorMessage = errorBody['msg'].toString();
            }
          }
        }
      } catch (_) {
        // Si no se puede parsear el error, usar el mensaje por defecto
        errorMessage =
            'Error ${response.statusCode}: ${response.body.isNotEmpty ? response.body.substring(0, response.body.length > 100 ? 100 : response.body.length) : "Sin detalles"}';
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
    } else if (error is http.ClientException) {
      return NetworkException(
        message:
            'Error de conexión. Verifique que el servidor FastAPI esté corriendo en ${ApiConfig.fastApiBaseUrl}',
      );
    } else if (error.toString().contains('SocketException') ||
        error.toString().contains('Failed host lookup') ||
        error.toString().contains('Connection refused')) {
      return NetworkException(
        message:
            'No se puede conectar al servidor. Verifique que FastAPI esté corriendo en ${ApiConfig.fastApiBaseUrl}',
      );
    } else if (error.toString().contains('TimeoutException') ||
        error.toString().contains('timeout')) {
      return NetworkException(
        message: 'Tiempo de espera agotado. Intente nuevamente.',
      );
    } else if (error is Exception) {
      return NetworkException(message: 'Error de red: ${error.toString()}');
    } else {
      return NetworkException(message: 'Error de conexión: $error');
    }
  }
}
