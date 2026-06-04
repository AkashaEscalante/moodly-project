import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moodly/core/providers/theme_provider.dart';
import 'package:moodly/features/auth/application/auth_provider.dart'
    show authStateProvider, authRepositoryProvider;
import 'package:moodly/features/profile/application/profile_provider.dart'
    show currentProfileProvider, profileRepositoryProvider, streakDataProvider;
import 'package:moodly/features/profile/domain/profile_model.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userAsync = ref.watch(authStateProvider);
    final userId = userAsync.valueOrNull?.id ?? '';

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D0D1A) : const Color(0xFFF8F5FF),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => _ProfileBody(
          name: 'Usuario',
          email: '',
          userId: '',
          isDark: isDark,
        ),
        data: (user) => _ProfileBody(
          name: user?.fullName ?? 'Usuario',
          email: user?.email ?? '',
          userId: userId,
          isDark: isDark,
        ),
      ),
      bottomNavigationBar: _MoodlyBottomNav(currentIndex: 4, isDark: isDark),
    );
  }
}

class _ProfileBody extends ConsumerStatefulWidget {
  final String name;
  final String email;
  final String userId;
  final bool isDark;

  const _ProfileBody({
    required this.name,
    required this.email,
    required this.userId,
    required this.isDark,
  });

  @override
  ConsumerState<_ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends ConsumerState<_ProfileBody> {
  bool _notificationsOn = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.userId.isNotEmpty) {
        ref
            .read(profileRepositoryProvider)
            .recordAppOpen(widget.userId)
            .then((_) {
          if (mounted && widget.userId.isNotEmpty) {
            ref.invalidate(currentProfileProvider(widget.userId));
          }
        }).catchError((_) {});
      }
    });
  }

  String get _initials {
    final parts = widget.name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return widget.name.isNotEmpty ? widget.name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final cardColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A2A3E) : const Color(0xFFF0F0F0);
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    final textPrimary = isDark ? Colors.white : const Color(0xFF222222);
    final textSecondary = isDark ? const Color(0xFF9E9E9E) : const Color(0xFF888888);

    final profileAsync = widget.userId.isNotEmpty
        ? ref.watch(currentProfileProvider(widget.userId))
        : const AsyncValue<Profile>.loading();
    final streakAsync = widget.userId.isNotEmpty
        ? ref.watch(streakDataProvider(widget.userId))
        : const AsyncValue<Map<String, int>>.data(
            {'current_streak': 0, 'longest_streak': 0, 'total_entries': 0});

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // ─── Header ─────────────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF4A1F6E), const Color(0xFF2D1B4E)]
                      : [const Color(0xFF9C27B0), const Color(0xFF7B1FA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(36)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _initials,
                        style: GoogleFonts.syne(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    widget.name,
                    style: GoogleFonts.syne(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  // Show extra info from profile (city, sex)
                  profileAsync.whenOrNull(
                    data: (p) {
                      final parts = <String>[];
                      if (p.ciudad != null && p.ciudad!.isNotEmpty) parts.add(p.ciudad!);
                      if (p.sexo != null && p.sexo!.isNotEmpty) parts.add(p.sexo!);
                      if (parts.isEmpty) return null;
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          parts.join(' · '),
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.75),
                          ),
                        ),
                      );
                    },
                  ) ?? const SizedBox.shrink(),
                  if (widget.email.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        widget.email,
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => context.go('/edit-profile'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        'Editar Perfil',
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ─── Stats ────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tus Estadísticas',
                    style: GoogleFonts.syne(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.local_fire_department_rounded,
                          value: streakAsync.when(
                            data: (s) => '${s['current_streak']}',
                            loading: () => '…',
                            error: (_, _) => '0',
                          ),
                          label: 'Racha',
                          sublabel: 'días',
                          iconColor: const Color(0xFF9C27B0),
                          bgColor: isDark
                              ? const Color(0xFF9C27B0).withValues(alpha: 0.15)
                              : const Color(0xFFF3E5F5),
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.emoji_emotions_rounded,
                          value: streakAsync.when(
                            data: (s) => '${s['total_entries']}',
                            loading: () => '…',
                            error: (_, _) => '0',
                          ),
                          label: 'Registros',
                          sublabel: 'estados',
                          iconColor: const Color(0xFFF48FB1),
                          bgColor: isDark
                              ? const Color(0xFFF48FB1).withValues(alpha: 0.15)
                              : const Color(0xFFFCE4EC),
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.star_rounded,
                          value: streakAsync.when(
                            data: (s) => '${s['longest_streak']}',
                            loading: () => '…',
                            error: (_, _) => '0',
                          ),
                          label: 'Mejor racha',
                          sublabel: 'días',
                          iconColor: const Color(0xFFFFC107),
                          bgColor: isDark
                              ? const Color(0xFFFFC107).withValues(alpha: 0.15)
                              : const Color(0xFFFFFDE7),
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ─── Configuración ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Configuración',
                    style: GoogleFonts.syne(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ToggleCard(
                    icon: Icons.dark_mode_outlined,
                    title: 'Modo Oscuro',
                    subtitle: 'Cambia el tema de la app',
                    value: isDarkMode,
                    cardColor: cardColor,
                    borderColor: borderColor,
                    iconColor: const Color(0xFF7986CB),
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    onChanged: (v) {
                      ref.read(themeModeProvider.notifier).state =
                          v ? ThemeMode.dark : ThemeMode.light;
                    },
                  ),
                  const SizedBox(height: 10),
                  _ToggleCard(
                    icon: Icons.notifications_outlined,
                    title: 'Recordatorios',
                    subtitle: 'Avisos de bienestar diarios',
                    value: _notificationsOn,
                    cardColor: cardColor,
                    borderColor: borderColor,
                    iconColor: const Color(0xFF4CAF50),
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    onChanged: (v) => setState(() => _notificationsOn = v),
                  ),
                ],
              ),
            ),

            // ─── Premium banner ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: GestureDetector(
                onTap: () => context.go('/premium'),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6A1B9A), Color(0xFFAD1457)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF9C27B0).withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Text('🐱', style: TextStyle(fontSize: 32)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hazte Premium',
                              style: GoogleFonts.syne(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Chat ilimitado · Stats completas · IA análisis',
                              style: GoogleFonts.dmSans(
                                fontSize: 11,
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded,
                          color: Colors.white54, size: 16),
                    ],
                  ),
                ),
              ),
            ),

            // ─── Soporte ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Soporte',
                    style: GoogleFonts.syne(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _LinkCard(
                    icon: Icons.help_outline_rounded,
                    title: 'Centro de Ayuda',
                    subtitle: 'Preguntas frecuentes y soporte',
                    cardColor: cardColor,
                    borderColor: borderColor,
                    iconColor: const Color(0xFFFFA726),
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    onTap: () => context.go('/help'),
                  ),
                  const SizedBox(height: 10),
                  _LinkCard(
                    icon: Icons.lock_outline_rounded,
                    title: 'Privacidad',
                    subtitle: 'Controla tus datos personales',
                    cardColor: cardColor,
                    borderColor: borderColor,
                    iconColor: const Color(0xFFF48FB1),
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    onTap: () => context.go('/privacy'),
                  ),
                ],
              ),
            ),

            // ─── Cerrar Sesión ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 36),
              child: GestureDetector(
                onTap: () async {
                  await ref.read(authRepositoryProvider).signOut();
                  if (context.mounted) context.go('/login');
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFFFF5252).withValues(alpha: 0.1)
                        : const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFFFF5252).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.logout_rounded, size: 18, color: Color(0xFFFF5252)),
                      const SizedBox(width: 8),
                      Text(
                        'Cerrar Sesión',
                        style: GoogleFonts.dmSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFFF5252),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final String sublabel;
  final Color iconColor;
  final Color bgColor;
  final bool isDark;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.sublabel,
    required this.iconColor,
    required this.bgColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.syne(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: isDark ? const Color(0xFF9E9E9E) : const Color(0xFF666666),
            ),
          ),
          if (sublabel.isNotEmpty)
            Text(
              sublabel,
              style: GoogleFonts.dmSans(
                fontSize: 9,
                color: isDark ? const Color(0xFF6E6E7E) : const Color(0xFFAAAAAA),
              ),
            ),
        ],
      ),
    );
  }
}

class _ToggleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final Color cardColor;
  final Color borderColor;
  final Color iconColor;
  final Color textPrimary;
  final Color textSecondary;
  final ValueChanged<bool> onChanged;

  const _ToggleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.cardColor,
    required this.borderColor,
    required this.iconColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.syne(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textPrimary)),
                Text(subtitle,
                    style: GoogleFonts.dmSans(fontSize: 12, color: textSecondary)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: iconColor,
            activeThumbColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _LinkCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color cardColor;
  final Color borderColor;
  final Color iconColor;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onTap;

  const _LinkCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.cardColor,
    required this.borderColor,
    required this.iconColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.syne(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textPrimary)),
                  Text(subtitle,
                      style: GoogleFonts.dmSans(fontSize: 12, color: textSecondary)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: textSecondary),
          ],
        ),
      ),
    );
  }
}

// ─── Bottom Nav ───────────────────────────────────────────────────────────────

class _MoodlyBottomNav extends StatelessWidget {
  final int currentIndex;
  final bool isDark;
  const _MoodlyBottomNav({required this.currentIndex, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF1A1A2E) : Colors.white;
    return Container(
      decoration: BoxDecoration(
        color: bg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home_outlined, label: 'Inicio', index: 0, currentIndex: currentIndex, route: '/home', isDark: isDark),
              _NavItem(icon: Icons.emoji_emotions_outlined, label: 'Ánimo', index: 1, currentIndex: currentIndex, route: '/mood-checkin', isDark: isDark),
              _NavItem(icon: Icons.auto_stories_outlined, label: 'Guía', index: 2, currentIndex: currentIndex, route: '/consejos', isDark: isDark),
              _NavItem(icon: Icons.menu_book_outlined, label: 'Diario', index: 3, currentIndex: currentIndex, route: '/diary', isDark: isDark),
              _NavItem(icon: Icons.person_outline_rounded, label: 'Perfil', index: 4, currentIndex: currentIndex, route: '/profile', isDark: isDark),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final String route;
  final bool isDark;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.route,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final selected = index == currentIndex;
    return GestureDetector(
      onTap: () => context.go(route),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF9C27B0).withValues(alpha: isDark ? 0.3 : 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22,
                color: selected ? const Color(0xFF9C27B0) : const Color(0xFFAAAAAA)),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? const Color(0xFF9C27B0) : const Color(0xFFAAAAAA),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
