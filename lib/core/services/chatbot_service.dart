// lib/core/services/chatbot_service.dart

import 'package:google_generative_ai/google_generative_ai.dart';
import '../constants/gemini_config.dart';

class ChatbotService {
  late final GenerativeModel _model;
  late final ChatSession _chat;

  ChatbotService() {
    // 1. Inicializa el Modelo.
    _model = GenerativeModel(
      // Reitero: 'gemini-2.5-flash' no es un modelo válido. Usa 'gemini-1.5-flash'
      // o el que corresponda de la documentación de Google AI.
      model: 'gemini-1.5-flash',
      apiKey: GEMINI_API_KEY,
    );

    // 2. Define la instrucción de sistema como un diálogo inicial.
    // Esta es la forma compatible con versiones que no tienen Content.system().
    final initialHistory = <Content>[
      // Le "dices" al modelo cuál es su rol.
      Content.text(
          "A partir de ahora, tu único rol es ser un asistente de ayuda para un "
              "sistema de punto de venta (POS) llamado 'Punto de Venta'. "
              "Responderás preguntas sobre cómo usar el sistema (productos, ventas, "
              "reportes, usuarios, etc.) de manera concisa. No responderás "
              "preguntas ajenas a este contexto POS. Tu idioma principal es el español."
      ),
      // Le "pides" al modelo que confirme que entendió.
      Content.model([
        TextPart(
            "Entendido. Estoy listo para asistirte con cualquier pregunta sobre "
                "el sistema 'Punto de Venta'."
        )
      ])
    ];

    // 3. Inicializa la Sesión de Chat con este historial de contexto.
    _chat = _model.startChat(history: initialHistory);
  }

  // Método principal para interactuar con la IA
  Future<String> sendMessage(String message) async {
    try {
      // Usa Content.text() para enviar el mensaje del usuario.
      // Esto es sintácticamente correcto para todas las versiones recientes.
      final response = await _chat.sendMessage(Content.text(message));

      final text = response.text;
      if (text == null || text.isEmpty) {
        return 'Lo siento, no pude generar una respuesta. Por favor, reformula tu pregunta.';
      }

      return text;
    } catch (e) {
      print('Error al enviar mensaje a Gemini: $e');
      return 'Ocurrió un error de conexión con el asistente. Intenta verificar tu API Key o conexión a internet.';
    }
  }
}
