import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moodly/features/chat/application/chat_provider.dart';
import 'package:moodly/features/chat/domain/chat_message_model.dart';
import 'package:moodly/features/premium/application/premium_provider.dart';

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _sending = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;

    _controller.clear();
    setState(() => _sending = true);
    await ref.read(chatProvider.notifier).sendMessage(text);
    setState(() => _sending = false);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPremium = ref.watch(isPremiumProvider);
    final messagesAsync = ref.watch(chatProvider);
    final messages = messagesAsync.valueOrNull ?? [];

    if (messages.isNotEmpty) _scrollToBottom();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D0D1A) : const Color(0xFFF8F5FF),
      appBar: _buildAppBar(isDark),
      body: isPremium
          ? _buildChatBody(isDark, messages)
          : _buildPremiumLockedBody(isDark),
    );
  }

  AppBar _buildAppBar(bool isDark) {
    return AppBar(
      backgroundColor: isDark ? const Color(0xFF0D0D1A) : const Color(0xFFF8F5FF),
      elevation: 0,
      leading: GestureDetector(
        onTap: () => context.canPop() ? context.pop() : context.go('/home'),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 6,
              ),
            ],
          ),
          child: Icon(
            Icons.chevron_left_rounded,
            color: isDark ? Colors.white : const Color(0xFF555555),
          ),
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF80AB), Color(0xFF9C27B0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🐱', style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Maya',
                style: GoogleFonts.syne(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF222222),
                ),
              ),
              Text(
                'Asistente de Bienestar',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  color: const Color(0xFF9C27B0),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.refresh_rounded,
            color: isDark ? Colors.white54 : const Color(0xFF9E9E9E),
          ),
          tooltip: 'Nueva conversación',
          onPressed: () {
            ref.read(chatProvider.notifier).clearChat();
            _scrollToBottom();
          },
        ),
      ],
    );
  }

  // ─── Chat normal (usuario premium) ────────────────────────────────────────

  Widget _buildChatBody(bool isDark, List<ChatMessage> messages) {
    return Column(
      children: [
        _DisclaimerBanner(isDark: isDark),
        Expanded(
          child: messages.isEmpty
              ? const SizedBox.shrink()
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return _MessageBubble(
                      message: msg,
                      isDark: isDark,
                      isThinking: msg.content == '...',
                      isLatest: index == messages.length - 1,
                    );
                  },
                ),
        ),
        _InputBar(
          isDark: isDark,
          controller: _controller,
          sending: _sending,
          onSend: _send,
        ),
      ],
    );
  }

  // ─── Vista bloqueada (usuario no premium) ─────────────────────────────────

  Widget _buildPremiumLockedBody(bool isDark) {
    return Column(
      children: [
        _DisclaimerBanner(isDark: isDark),
        Expanded(
          child: Stack(
            children: [
              // Mensajes de previsualización (borrosos)
              _LockedChatPreview(isDark: isDark),
              // Superposición con fade hacia el bloqueo
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        (isDark ? const Color(0xFF0D0D1A) : const Color(0xFFF8F5FF))
                            .withValues(alpha: 0.85),
                        isDark ? const Color(0xFF0D0D1A) : const Color(0xFFF8F5FF),
                      ],
                      stops: const [0.0, 0.55, 1.0],
                    ),
                  ),
                ),
              ),
              // Tarjeta de bloqueo
              Align(
                alignment: const Alignment(0, 0.25),
                child: _PremiumLockCard(
                  isDark: isDark,
                  onTap: () => context.push('/premium'),
                ),
              ),
            ],
          ),
        ),
        _LockedInputBar(isDark: isDark),
      ],
    );
  }
}

// ─── Banner disclaimer ────────────────────────────────────────────────────────

class _DisclaimerBanner extends StatelessWidget {
  final bool isDark;
  const _DisclaimerBanner({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF9C27B0).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF9C27B0).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded,
              color: Color(0xFF9C27B0), size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Maya no reemplaza a un profesional de salud mental.',
              style: GoogleFonts.dmSans(
                fontSize: 11,
                color: const Color(0xFF9C27B0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Previsualización borrosa (no premium) ────────────────────────────────────

class _LockedChatPreview extends StatelessWidget {
  final bool isDark;
  static const _sample = [
    (true, '¿Cómo puedo manejar la ansiedad antes de un examen?'),
    (false, 'Entiendo cómo te sientes. La ansiedad antes de los exámenes es muy común. Primero, respira profundo: inhala por 4 segundos, sostén 4 y exhala 4. Esto activa tu sistema nervioso parasimpático. 🌿'),
    (true, 'Gracias, eso me ayuda mucho. ¿Qué más puedo hacer?'),
    (false, 'También te recomiendo dividir tu estudio en bloques de 25 min con descansos de 5 — la técnica Pomodoro. Tu cerebro retiene mejor así, y la presión se reduce. ¿Quieres que te ayude con un plan?'),
  ];

  const _LockedChatPreview({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          physics: const NeverScrollableScrollPhysics(),
          children: _sample.map((item) {
            final isUser = item.$1;
            final text = item.$2;
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                mainAxisAlignment: isUser
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: isUser
                            ? const LinearGradient(
                                colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
                              )
                            : null,
                        color: isUser
                            ? null
                            : (isDark
                                ? const Color(0xFF1E1E2E)
                                : Colors.white),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20),
                          topRight: const Radius.circular(20),
                          bottomLeft: Radius.circular(isUser ? 20 : 4),
                          bottomRight: Radius.circular(isUser ? 4 : 20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withValues(alpha: isDark ? 0.2 : 0.07),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        text,
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          color: isUser
                              ? Colors.white
                              : (isDark
                                  ? Colors.white
                                  : const Color(0xFF333333)),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ─── Tarjeta de bloqueo premium ───────────────────────────────────────────────

class _PremiumLockCard extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTap;
  const _PremiumLockCard({required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        const Color(0xFF2A1040).withValues(alpha: 0.95),
                        const Color(0xFF1A0A2E).withValues(alpha: 0.95),
                      ]
                    : [
                        Colors.white.withValues(alpha: 0.92),
                        const Color(0xFFF3E5F5).withValues(alpha: 0.92),
                      ],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: const Color(0xFF9C27B0).withValues(alpha: 0.35),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9C27B0).withValues(alpha: 0.25),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ícono de bloqueo con gradiente
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF80AB), Color(0xFF9C27B0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF9C27B0).withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.lock_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .scale(begin: const Offset(0.7, 0.7), duration: 400.ms, curve: Curves.easeOutBack),
                const SizedBox(height: 18),
                Text(
                  'Desbloquea a Maya',
                  style: GoogleFonts.syne(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF222222),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'El chat con tu asistente de bienestar\nes una función exclusiva de Premium.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: isDark ? Colors.white54 : const Color(0xFF777777),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                // Beneficios
                _LockBenefit(
                  emoji: '💬',
                  text: 'Chat ilimitado con Maya',
                  isDark: isDark,
                ),
                const SizedBox(height: 8),
                _LockBenefit(
                  emoji: '🧠',
                  text: 'Análisis emocional con IA',
                  isDark: isDark,
                ),
                const SizedBox(height: 8),
                _LockBenefit(
                  emoji: '💜',
                  text: 'Respuestas personalizadas',
                  isDark: isDark,
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF80AB), Color(0xFF9C27B0)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF9C27B0).withValues(alpha: 0.4),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Text(
                      'Ver planes Premium',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.syne(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LockBenefit extends StatelessWidget {
  final String emoji;
  final String text;
  final bool isDark;
  const _LockBenefit({required this.emoji, required this.text, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFF9C27B0).withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 15)),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: GoogleFonts.dmSans(
            fontSize: 13,
            color: isDark ? Colors.white70 : const Color(0xFF444444),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ─── Input bar bloqueada ──────────────────────────────────────────────────────

class _LockedInputBar extends StatelessWidget {
  final bool isDark;
  const _LockedInputBar({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D0D1A) : const Color(0xFFF8F5FF),
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF1E1E2E) : const Color(0xFFEEEEEE),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E1E2E)
                    : const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF2A2A3E)
                      : const Color(0xFFDDDDDD),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lock_rounded,
                    size: 16,
                    color: isDark ? Colors.white24 : const Color(0xFFBBBBBB),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Función Premium — desbloquea para chatear',
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: isDark
                          ? const Color(0xFF444455)
                          : const Color(0xFFBBBBBB),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E2E) : const Color(0xFFEEEEEE),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.send_rounded,
              color: isDark ? Colors.white12 : const Color(0xFFCCCCCC),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Input bar activa (premium) ───────────────────────────────────────────────

class _InputBar extends StatelessWidget {
  final bool isDark;
  final TextEditingController controller;
  final bool sending;
  final VoidCallback onSend;

  const _InputBar({
    required this.isDark,
    required this.controller,
    required this.sending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D0D1A) : const Color(0xFFF8F5FF),
        border: Border(
          top: BorderSide(
            color: isDark
                ? const Color(0xFF1E1E2E)
                : const Color(0xFFEEEEEE),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF2A2A3E)
                      : const Color(0xFFEEEEEE),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: controller,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: isDark ? Colors.white : const Color(0xFF333333),
                ),
                decoration: InputDecoration(
                  hintText: 'Escribe tu mensaje...',
                  hintStyle: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: isDark
                        ? const Color(0xFF555566)
                        : const Color(0xFFCCCCCC),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => onSend(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onSend,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: sending
                    ? null
                    : const LinearGradient(
                        colors: [Color(0xFFFF80AB), Color(0xFF9C27B0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                color: sending ? Colors.grey.shade400 : null,
                shape: BoxShape.circle,
                boxShadow: sending
                    ? []
                    : [
                        BoxShadow(
                          color: const Color(0xFF9C27B0)
                              .withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: sending
                  ? const Padding(
                      padding: EdgeInsets.all(14),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Message bubble ───────────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isDark;
  final bool isThinking;
  final bool isLatest;

  const _MessageBubble({
    required this.message,
    required this.isDark,
    required this.isThinking,
    required this.isLatest,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    final bubble = Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: isUser
                    ? const LinearGradient(
                        colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isUser
                    ? null
                    : (isDark ? const Color(0xFF1E1E2E) : Colors.white),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: isThinking
                  ? _ThinkingDots(isDark: isDark)
                  : Text(
                      message.content,
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        color: isUser
                            ? Colors.white
                            : (isDark
                                ? Colors.white
                                : const Color(0xFF333333)),
                        height: 1.5,
                      ),
                    ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );

    if (!isLatest) return bubble;
    return bubble
        .animate()
        .fadeIn(duration: 260.ms)
        .slideY(begin: 0.06, duration: 260.ms, curve: Curves.easeOut);
  }
}

// ─── Thinking dots ────────────────────────────────────────────────────────────

class _ThinkingDots extends StatefulWidget {
  final bool isDark;
  const _ThinkingDots({required this.isDark});

  @override
  State<_ThinkingDots> createState() => _ThinkingDotsState();
}

class _ThinkingDotsState extends State<_ThinkingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i / 3;
            final t = (_anim.value - delay).clamp(0.0, 1.0);
            final opacity = (t < 0.5 ? t * 2 : (1 - t) * 2).clamp(0.3, 1.0);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFCE93D8),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
