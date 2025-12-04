// lib/features/chatbot/presentation/pages/chatbot_page.dart

import 'package:flutter/material.dart';
// --- Importaciones para el Localizador de Servicios ---
import '../../../../locator.dart'; //1. Importa el archivo locator
import '../../../../core/services/chatbot_service.dart'; // Importa la clase del servicio

// Clase para modelar un mensaje en el chat
class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});
}

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  // ✅ PASO CLAVE: OBTENER LA INSTANCIA ÚNICA DEL SERVICIO
  // En lugar de: final ChatbotService _chatbotService = ChatbotService();
  // Usamos 'locator' para obtener el singleton que ya fue creado.
  final ChatbotService _chatbotService = locator<ChatbotService>(); // 2. Usa el locator

  // Lista de mensajes, inicializada con el saludo del bot.
  final List<Message> _messages = [
    Message(
      text: '¡Hola! Soy tu asistente inteligente de "Punto de Venta". Pregúntame sobre cómo usar las funciones del sistema.',
      isUser: false,
    ),
  ];

  // Función para manejar el envío de mensajes
  void _handleSubmitted(String text) async {
    if (text.isEmpty || _isLoading) return;
    final userMessage = text.trim();
    _controller.clear();

    // Añade el mensaje del usuario a la lista y activa el estado de carga
    setState(() {
      _messages.insert(0, Message(text: userMessage, isUser: true));
      _isLoading = true;
    });

    try {
      // Llama al servicio (que ahora es una instancia única)
      final botResponse = await _chatbotService.sendMessage(userMessage);

      // Añade la respuesta del bot a la lista
      setState(() {
        _messages.insert(0, Message(text: botResponse, isUser: false));
      });
    } catch (e) {
      // Manejo de errores
      setState(() {
        _messages.insert(0, Message(text: 'Error de comunicación: $e', isUser: false));
      });
    } finally {
      // Desactiva el estado de carga, independientemente del resultado
      setState(() {
        _isLoading = false;
      });
    }
  }

  // --- Widgets de la UI (Sin cambios aquí) ---

  Widget _buildMessage(Message message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment:
        message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15),
                  topRight: const Radius.circular(15),
                  bottomLeft: Radius.circular(message.isUser ? 15 : 0),
                  bottomRight: Radius.circular(message.isUser ? 0 : 15),
                ),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0), // Padding añadido para mejor apariencia
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _controller,
                onSubmitted: _handleSubmitted,
                enabled: !_isLoading,
                decoration: InputDecoration.collapsed(
                    hintText: _isLoading ? 'Asistente pensando...' : 'Escribe tu pregunta...'),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: _isLoading
                    ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Icon(Icons.send),
                onPressed: _isLoading ? null : () => _handleSubmitted(_controller.text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistente Inteligente POS'),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _buildMessage(_messages[index]),
              itemCount: _messages.length,
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}
