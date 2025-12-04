// lib/core/services/chatbot_service.dart

import 'package:google_generative_ai/google_generative_ai.dart';
import '../constants/gemini_config.dart';

class ChatbotService {
  late final GenerativeModel _model;
  late final ChatSession _chat;

  ChatbotService() {
    // 1. Inicializa el Modelo (solo API Key y modelo)
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: GEMINI_API_KEY,
      // ⚠️ IMPORTANTE: Se elimina el parámetro 'config' que causaba errores en tu versión.
    );

    // 2. Inicializa la Sesión de Chat sin argumentos.
    // Esta es la sintaxis más simple y compatible con versiones antiguas.
    _chat = _model.startChat();
  }

  // Método principal para interactuar con la IA
  Future<String> sendMessage(String message) async {
    try {
      // ⚠️ Usamos 'Content.text' sin prefijo, ya que la importación es completa.
      final response = await _chat.sendMessage(Content.text(message));

      if (response.text == null || response.text!.isEmpty) {
        return 'Lo siento, no pude generar una respuesta. Por favor, reformula tu pregunta.';
      }

      return response.text!;
    } catch (e) {
      print('Error al enviar mensaje a Gemini: $e');
      return 'Ocurrió un error de conexión con el asistente. Intenta verificar tu API Key o conexión a internet.';
    }
  }
}