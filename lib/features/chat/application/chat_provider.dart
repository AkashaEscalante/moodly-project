import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:moodly/features/chat/domain/chat_message_model.dart';

const _systemPrompt =
    'Eres Maya, asistente de bienestar emocional de Moodly. '
    'Hablas exclusivamente en español, con tono empático, cálido y profesional. '
    'Tu función es acompañar al usuario en su bienestar mental: preguntarle cómo se siente, '
    'cómo fue su día, y ofrecer perspectivas positivas basadas en psicología cognitivo-conductual. '
    'Mantén respuestas concisas, máximo 3 oraciones. '
    'No ofrezcas diagnósticos ni tratamientos médicos. '
    'Si detectas señales de crisis o riesgo, recomienda contactar a un profesional de salud mental.';

/// Limpia la key eliminando cualquier carácter de control oculto (BOM, \r, \n,
/// tabs) que puede hacer que Google rechace la key con un error OAuth 401.
String _sanitizeKey(String raw) =>
    raw.replaceAll(RegExp(r'[\x00-\x1F\x7Fï»¿]'), '').trim();

class ChatNotifier extends StateNotifier<AsyncValue<List<ChatMessage>>> {
  ChatNotifier() : super(const AsyncValue.data([])) {
    _addWelcome();
  }

  // Maintains Gemini chat session so it has conversation memory
  ChatSession? _session;

  void _addWelcome() {
    state = AsyncValue.data([
      ChatMessage(
        role: 'assistant',
        content:
            '¡Hola! Soy Maya 🐱 Tu asistente de bienestar emocional. ¿Cómo te has sentido hoy?',
        timestamp: DateTime.now(),
      ),
    ]);
    _session = null; // reset session on new chat
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final current = state.valueOrNull ?? [];

    final userMsg = ChatMessage(
      role: 'user',
      content: trimmed,
      timestamp: DateTime.now(),
    );

    // Show thinking indicator
    final thinking = ChatMessage(
      role: 'assistant',
      content: '...',
      timestamp: DateTime.now(),
    );
    state = AsyncValue.data([...current, userMsg, thinking]);

    try {
      final apiKey = _sanitizeKey(dotenv.env['GEMINI_API_KEY'] ?? '');
      if (apiKey.isEmpty) {
        _replaceThinking(current, userMsg,
            '⚠️ GEMINI_API_KEY no está configurada en el archivo .env. Agrégala para activar a Maya.');
        return;
      }

      // Usa systemInstruction (API oficial) en lugar de inyectar el prompt
      // en el historial — evita conflictos de rol que provocan el error OAuth.
      _session ??= GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
        systemInstruction: Content('system', [TextPart(_systemPrompt)]),
      ).startChat();

      final response = await _session!.sendMessage(Content.text(trimmed));
      final reply =
          response.text?.trim() ?? 'No pude generar una respuesta. Inténtalo de nuevo.';
      _replaceThinking(current, userMsg, reply);
    } on GenerativeAIException catch (e) {
      final msg = e.message.toLowerCase();
      if (msg.contains('oauth') ||
          msg.contains('authentication credential') ||
          msg.contains('invalid authentication') ||
          msg.contains('api_key') ||
          msg.contains('api key') ||
          msg.contains('401')) {
        _replaceThinking(current, userMsg,
            '🔑 API key de Gemini no válida. Ve a Google AI Studio → "Get API key", copia la key y actualiza GEMINI_API_KEY en tu archivo .env.');
      } else if (msg.contains('quota') || msg.contains('429')) {
        _replaceThinking(current, userMsg,
            '⏳ Límite de solicitudes alcanzado. Espera unos segundos e intenta de nuevo.');
      } else {
        _replaceThinking(current, userMsg, 'Maya no pudo responder: ${e.message}');
      }
    } catch (e) {
      _replaceThinking(current, userMsg,
          'No pude conectarme en este momento. Verifica tu conexión a internet e intenta de nuevo.');
    }
  }

  void _replaceThinking(
    List<ChatMessage> previous,
    ChatMessage userMsg,
    String responseText,
  ) {
    state = AsyncValue.data([
      ...previous,
      userMsg,
      ChatMessage(
        role: 'assistant',
        content: responseText,
        timestamp: DateTime.now(),
      ),
    ]);
  }

  void clearChat() => _addWelcome();
}

final chatProvider =
    StateNotifierProvider<ChatNotifier, AsyncValue<List<ChatMessage>>>(
  (ref) => ChatNotifier(),
);
