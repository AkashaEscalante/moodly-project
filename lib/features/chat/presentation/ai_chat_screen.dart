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

    final isPremium = ref.read(isPremiumProvider);
    final limitNotifier = ref.read(dailyLimitProvider.notifier);

    // Guardia: no enviar si ya se agotó el límite
    if (!isPremium && limitNotifier.hasReachedLimit) return;

    _controller.clear();
    setState(() => _sending = true);

    await ref.read(chatProvider.notifier).sendMessage(text);

    // Incrementar contador DESPUÉS de la respuesta exitosa
    if (!isPremium) {
      limitNotifier.increment();
    }

    if (mounted) setState(() => _sending = false);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPremium = ref.watch(isPremiumProvider);
    final limitState = ref.watch(dailyLimitProvider);
    final messagesAsync = ref.watch(chatProvider);
    final messages = messagesAsync.valueOrNull ?? [];

    // Calcular límite directamente desde el estado observado (dispara rebuild)
    final todayStr = DateTime.now().toIso8601String().split('T')[0];
    final todayCount = limitState.date == todayStr ? limitState.count : 0;
    final isLimitReached = !isPremium && todayCount >= kFreeChatLimit;
    final remaining = isPremium
        ? kFreeChatLimit
        : (kFreeChatLimit - todayCount).clamp(0, kFreeChatLimit);

    if (messages.isNotEmpty) _scrollToBottom();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D0D1A) : const Color(0xFFF8F5FF),
      appBar: _buildAppBar(isDark),
      body: isLimitReached
          ? _buildLimitReachedBody(isDark)
          : _buildChatBody(isDark, messages, isPremium, remaining),
    );
  }

  // ─── AppBar ────────────────────────────────────────────────────────────────

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

  // ─── Chat normal (con/sin límite) ──────────────────────────────────────────

  Widget _buildChatBody(
    bool isDark,
    List<ChatMessage> messages,
    bool isPremium,
    int remaining,
  ) {
    return Column(
      children: [
        _DisclaimerBanner(isDark: isDark),
        // Contador de mensajes para usuarios free
        if (!isPremium)
          _DailyCountBanner(
            remaining: remaining,
            isDark: isDark,
          ),
        Expanded(
          child: messages.isEmpty
              ? _WelcomeHint(isDark: isDark)
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
        _WatermarkLabel(isDark: isDark),
        _InputBar(
          isDark: isDark,
          controller: _controller,
          sending: _sending,
          onSend: _send,
        ),
      ],
    );
  }

  // ─── Vista cuando se agotó el límite diario ────────────────────────────────

  Widget _buildLimitReachedBody(bool isDark) {
    return Column(
      children: [
        _DisclaimerBanner(isDark: isDark),
        Expanded(
          child: Stack(
            children: [
              // Preview borrosa de los mensajes actuales
              _BlurredMessagesPreview(isDark: isDark),
              // Degradado de fade hacia el bloqueo
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        (isDark
                                ? const Color(0xFF0D0D1A)
                                : const Color(0xFFF8F5FF))
                            .withValues(alpha: 0.8),
                        isDark
                            ? const Color(0xFF0D0D1A)
                            : const Color(0xFFF8F5FF),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
              // Tarjeta de paywall
              Align(
                alignment: const Alignment(0, 0.2),
                child: _PaywallCard(
                  isDark: isDark,
                  onTap: () => context.push('/premium'),
                ),
              ),
            ],
          ),
        ),
        _WatermarkLabel(isDark: isDark),
        _LockedInputBar(isDark: isDark),
      ],
    );
  }
}

// ─── Marca de agua del desarrollador ─────────────────────────────────────────

class _WatermarkLabel extends StatelessWidget {
  final bool isDark;
  const _WatermarkLabel({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Center(
        child: Text(
          'Akasha Escalante',
          style: GoogleFonts.dmSans(
            fontSize: 10,
            color: isDark
                ? Colors.white.withValues(alpha: 0.12)
                : Colors.grey.withValues(alpha: 0.25),
          ),
        ),
      ),
    );
  }
}

// ─── Banner de disclaimer ─────────────────────────────────────────────────────

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
        border:
            Border.all(color: const Color(0xFF9C27B0).withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded,
              color: Color(0xFF9C27B0), size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Maya no reemplaza a un profesional de salud mental.',
              style:
                  GoogleFonts.dmSans(fontSize: 11, color: const Color(0xFF9C27B0)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Contador de mensajes restantes (plan Gratis) ─────────────────────────────

class _DailyCountBanner extends StatelessWidget {
  final int remaining;
  final bool isDark;
  const _DailyCountBanner({required this.remaining, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isLow = remaining <= 1;
    final accent =
        isLow ? const Color(0xFFFF7043) : const Color(0xFF9C27B0);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(
            isLow ? Icons.warning_amber_rounded : Icons.chat_bubble_outline_rounded,
            color: accent,
            size: 14,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.dmSans(fontSize: 11, color: accent),
                children: [
                  TextSpan(
                    text: 'Plan Gratis — ',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: remaining > 0
                        ? 'te quedan $remaining mensaje${remaining == 1 ? '' : 's'} hoy'
                        : '¡Has usado todos tus mensajes de hoy!',
                  ),
                  if (remaining > 0)
                    TextSpan(
                      text: '  ·  Actualiza a Premium para mensajes ilimitados',
                      style: TextStyle(color: accent.withValues(alpha: 0.7)),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Hint de bienvenida cuando no hay mensajes ────────────────────────────────

class _WelcomeHint extends StatelessWidget {
  final bool isDark;
  const _WelcomeHint({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF80AB), Color(0xFF9C27B0)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('🐱', style: TextStyle(fontSize: 32)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '¡Hola! Soy Maya 💜',
              style: GoogleFonts.syne(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Estoy aquí para escucharte.\nCuéntame, ¿cómo te sientes hoy?',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: isDark ? Colors.white54 : const Color(0xFF888888),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Preview borrosa cuando se agotó el límite ────────────────────────────────

class _BlurredMessagesPreview extends ConsumerWidget {
  final bool isDark;

  static const _sample = [
    (true, '¿Cómo puedo manejar mejor el estrés?'),
    (false,
        'Entiendo que el estrés puede ser agotador. Una técnica que ayuda mucho es la respiración 4-7-8: inhala 4 seg, sostén 7 y exhala 8. Reduce el cortisol inmediatamente. 🌿'),
    (true, '¿Y si no puedo dormir por la ansiedad?'),
    (false,
        'La ansiedad nocturna es muy común. Prueba escribir en un diario todo lo que te preocupa antes de dormir — vaciar la mente en papel le dice al cerebro que puede soltar el control. 💜'),
  ];

  const _BlurredMessagesPreview({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Muestra los mensajes reales si los hay, de lo contrario, los de muestra
    final messages = ref.watch(chatProvider).valueOrNull ?? [];
    final displayMessages = messages.isNotEmpty ? messages : null;

    return ClipRect(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          physics: const NeverScrollableScrollPhysics(),
          children: displayMessages != null
              ? displayMessages.map((msg) => _SimpleBubble(
                    text: msg.content,
                    isUser: msg.isUser,
                    isDark: isDark,
                  )).toList()
              : _sample.map((s) => _SimpleBubble(
                    text: s.$2,
                    isUser: s.$1,
                    isDark: isDark,
                  )).toList(),
        ),
      ),
    );
  }
}

class _SimpleBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final bool isDark;
  const _SimpleBubble(
      {required this.text, required this.isUser, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: isUser
                    ? const LinearGradient(
                        colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
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
              ),
              child: Text(
                text,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: isUser
                      ? Colors.white
                      : (isDark ? Colors.white : const Color(0xFF333333)),
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Tarjeta de Paywall (límite alcanzado) ────────────────────────────────────

class _PaywallCard extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTap;
  const _PaywallCard({required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        const Color(0xFF2A1040).withValues(alpha: 0.96),
                        const Color(0xFF1A0A2E).withValues(alpha: 0.96),
                      ]
                    : [
                        Colors.white.withValues(alpha: 0.94),
                        const Color(0xFFF3E5F5).withValues(alpha: 0.94),
                      ],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: const Color(0xFF9C27B0).withValues(alpha: 0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9C27B0).withValues(alpha: 0.3),
                  blurRadius: 36,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ícono
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF7043), Color(0xFF9C27B0)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF9C27B0).withValues(alpha: 0.45),
                        blurRadius: 22,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.star_rounded,
                      color: Colors.white, size: 28),
                )
                    .animate()
                    .fadeIn(duration: 350.ms)
                    .scale(
                      begin: const Offset(0.7, 0.7),
                      duration: 350.ms,
                      curve: Curves.easeOutBack,
                    ),
                const SizedBox(height: 16),

                // Título
                Text(
                  '¡$kFreeChatLimit mensajes usados hoy!',
                  style: GoogleFonts.syne(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF222222),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'El plan Gratis incluye $kFreeChatLimit mensajes diarios con Maya.\nPasa a Premium y chatea sin límites.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: isDark ? Colors.white54 : const Color(0xFF666666),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),

                // Métodos de pago (visual mockup)
                _PaymentMethodsPreview(isDark: isDark),

                const SizedBox(height: 22),

                // CTA principal
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
                          color: const Color(0xFF9C27B0).withValues(alpha: 0.42),
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
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'El límite se reinicia mañana a medianoche',
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: isDark ? Colors.white30 : const Color(0xFFAAAAAA),
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

// ─── Visual de métodos de pago ────────────────────────────────────────────────

class _PaymentMethodsPreview extends StatelessWidget {
  final bool isDark;
  const _PaymentMethodsPreview({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PayChip(
            icon: Icons.credit_card_rounded,
            label: 'Tarjeta',
            subtitle: 'Crédito / Débito',
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _OxxoChip(isDark: isDark),
        ),
      ],
    );
  }
}

class _PayChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool isDark;
  const _PayChip({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF1E1E2E) : const Color(0xFFF5F0FF);
    final border = isDark ? const Color(0xFF3A2A5E) : const Color(0xFFD9C8F5);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF9C27B0), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.syne(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF333333),
                    )),
                Text(subtitle,
                    style: GoogleFonts.dmSans(
                      fontSize: 10,
                      color: isDark ? Colors.white38 : const Color(0xFF888888),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OxxoChip extends StatelessWidget {
  final bool isDark;
  const _OxxoChip({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF1E1E2E) : const Color(0xFFFFF8E1);
    final border = isDark ? const Color(0xFF3A2E10) : const Color(0xFFFFE082);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFFE53935),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Center(
              child: Text('O',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  )),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('OXXO',
                    style: GoogleFonts.syne(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF333333),
                    )),
                Text('Pago en efectivo',
                    style: GoogleFonts.dmSans(
                      fontSize: 10,
                      color: isDark ? Colors.white38 : const Color(0xFF888888),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Barra de input bloqueada ──────────────────────────────────────────────────

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
            color:
                isDark ? const Color(0xFF1E1E2E) : const Color(0xFFEEEEEE),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1A1A2E)
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
                  Icon(Icons.lock_rounded,
                      size: 15,
                      color: isDark ? Colors.white24 : const Color(0xFFBBBBBB)),
                  const SizedBox(width: 8),
                  Text(
                    'Límite diario alcanzado — actualiza a Premium',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
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
              color:
                  isDark ? const Color(0xFF1E1E2E) : const Color(0xFFEEEEEE),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.send_rounded,
                color: isDark ? Colors.white12 : const Color(0xFFCCCCCC),
                size: 20),
          ),
        ],
      ),
    );
  }
}

// ─── Barra de input activa ────────────────────────────────────────────────────

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
            color:
                isDark ? const Color(0xFF1E1E2E) : const Color(0xFFEEEEEE),
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
                  hintText: 'Escríbele a Maya...',
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
                          color: const Color(0xFF9C27B0).withValues(alpha: 0.35),
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
                  : const Icon(Icons.send_rounded,
                      color: Colors.white, size: 20),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    color: Colors.black
                        .withValues(alpha: isDark ? 0.2 : 0.07),
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
                            : (isDark ? Colors.white : const Color(0xFF333333)),
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
      builder: (_, _) => Row(
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
      ),
    );
  }
}
