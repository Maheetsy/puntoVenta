// lib/locator.dart

import 'package:get_it/get_it.dart';
import 'core/services/chatbot_service.dart'; // Ajusta la ruta a tu servicio

final locator = GetIt.instance;

void setupLocator() {
  // Registra ChatbotService como un "lazy singleton".
  // Esto significa que se creará una única instancia la primera vez que se pida,
  // y se reutilizará esa misma instancia en todas las llamadas futuras.
  locator.registerLazySingleton(() => ChatbotService());
}
