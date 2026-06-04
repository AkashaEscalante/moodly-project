import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moodly/features/chat/application/chat_provider.dart';
import 'package:moodly/features/chat/domain/chat_message_model.dart';

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
    final messagesAsync = ref.watch(chatProvider);
    final messages = messagesAsync.valueOrNull ?? [];

    // Auto scroll when messages update
    if (messages.isNotEmpty) _scrollToBottom();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D0D1A) : const Color(0xFFF8F5FF),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0D0D1A) : const Color(0xFFF8F5FF),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
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
                child: Text('🌸', style: TextStyle(fontSize: 18)),
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
      ),
      body: Column(
        children: [
          // Disclaimer banner
          Container(
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
          ),

          // Messages list
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
                      );
                    },
                  ),
          ),

          // Input bar
          Container(
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
                      color: isDark
                          ? const Color(0xFF1E1E2E)
                          : Colors.white,
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
                      controller: _controller,
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
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _send,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: _sending
                          ? null
                          : const LinearGradient(
                              colors: [Color(0xFFFF80AB), Color(0xFF9C27B0)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      color: _sending ? Colors.grey.shade400 : null,
                      shape: BoxShape.circle,
                      boxShadow: _sending
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
                    child: _sending
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
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isDark;
  final bool isThinking;

  const _MessageBubble({
    required this.message,
    required this.isDark,
    required this.isThinking,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF80AB), Color(0xFF9C27B0)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('🌸', style: TextStyle(fontSize: 14)),
              ),
            ),
            const SizedBox(width: 8),
          ],
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
  }
}

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
                  decoration: BoxDecoration(
                    color: widget.isDark
                        ? Colors.white60
                        : const Color(0xFF9C27B0),
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
