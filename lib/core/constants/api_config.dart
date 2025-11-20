class ApiConfig {
  ApiConfig._();

  // URL base del API FastAPI (MySQL)
  static const String fastApiBaseUrl = 'http://10.0.2.2:8000';

  // URL base del API Node.js (MongoDB)
  static const String nodeApiBaseUrl =
      'https://backendnodejs-abos.onrender.com';

  // Endpoints FastAPI
  static const String productsEndpoint = '/products/';
  static const String categoriesEndpoint = '/categories/';
  static const String salesEndpoint = '/sales/';

  // Endpoints Node.js
  static const String authLoginEndpoint = '/api/auth/login';
  static const String authMeEndpoint = '/api/auth/me';

  // Headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Timeout
  static const Duration timeout = Duration(seconds: 30);
}
