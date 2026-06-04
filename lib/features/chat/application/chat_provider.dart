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
      final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
      if (apiKey.isEmpty) {
        _replaceThinking(current, userMsg,
            'Lo siento, el asistente no está configurado. Por favor agrega tu GEMINI_API_KEY al archivo .env.');
        return;
      }

      // Initialize model + session lazily (reuse across messages for memory)
      _session ??= GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
        systemInstruction: Content.system(_systemPrompt),
        generationConfig: GenerationConfig(maxOutputTokens: 300),
      ).startChat();

      final response = await _session!.sendMessage(Content.text(trimmed));
      final reply = response.text ?? 'Lo siento, no pude generar una respuesta.';
      _replaceThinking(current, userMsg, reply.trim());
    } catch (e) {
      _replaceThinking(current, userMsg,
          'No pude conectarme en este momento. Por favor verifica tu conexión.');
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
