import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moodly/features/auth/application/auth_provider.dart'
    show authStateProvider;
import 'package:moodly/features/profile/application/profile_provider.dart'
    show currentProfileProvider, profileRepositoryProvider;
import 'package:moodly/features/profile/domain/profile_model.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _ciudadController;

  String? _sexo;
  DateTime? _fechaNacimiento;
  bool _saving = false;
  bool _loaded = false;

  static const _sexoOptions = [
    'Masculino',
    'Femenino',
    'No binario',
    'Prefiero no decir',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _ciudadController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ciudadController.dispose();
    super.dispose();
  }

  void _prefillFrom(Profile p, String email) {
    if (_loaded) return;
    _nameController.text = p.fullName;
    _emailController.text = email;
    _ciudadController.text = p.ciudad ?? '';
    _sexo = p.sexo;
    _fechaNacimiento = p.fechaNacimiento;
    _loaded = true;
  }

  int? get _edad {
    if (_fechaNacimiento == null) return null;
    final now = DateTime.now();
    int age = now.year - _fechaNacimiento!.year;
    if (now.month < _fechaNacimiento!.month ||
        (now.month == _fechaNacimiento!.month && now.day < _fechaNacimiento!.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0D0D1A) : const Color(0xFFF8F5FF);
    final cardColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A2A3E) : const Color(0xFFF0F0F0);
    final textPrimary = isDark ? Colors.white : const Color(0xFF222222);
    final textSecondary = isDark ? const Color(0xFF9E9E9E) : const Color(0xFF888888);

    final userAsync = ref.watch(authStateProvider);
    final userId = userAsync.valueOrNull?.id ?? '';
    final profileAsync =
        userId.isNotEmpty ? ref.watch(currentProfileProvider(userId)) : null;

    // Prefill once profile loads
    profileAsync?.whenData((p) {
      _prefillFrom(p, userAsync.valueOrNull?.email ?? '');
    });

    // Fallback: prefill name/email from auth when no profile yet
    if (!_loaded) {
      userAsync.whenData((u) {
        if (u != null && _nameController.text.isEmpty) {
          _nameController.text = u.fullName;
          _emailController.text = u.email;
        }
      });
    }

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.canPop() ? context.pop() : context.go('/profile'),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: cardColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Icon(
              Icons.chevron_left_rounded,
              color: isDark ? Colors.white : const Color(0xFF555555),
            ),
          ),
        ),
        title: Text(
          'Editar Perfil',
          style: GoogleFonts.syne(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Builder(builder: (_) {
                      final name = _nameController.text.trim();
                      final parts = name.split(' ');
                      final initials = parts.length >= 2
                          ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
                          : name.isNotEmpty
                              ? name[0].toUpperCase()
                              : '?';
                      return Text(
                        initials,
                        style: GoogleFonts.syne(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // ─── Nombre ────────────────────────────────────────────────────
              _FieldLabel('Nombre completo', textPrimary),
              const SizedBox(height: 8),
              _InputBox(
                controller: _nameController,
                icon: Icons.person_outline_rounded,
                hint: 'Tu nombre completo',
                cardColor: cardColor,
                borderColor: borderColor,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),
              const SizedBox(height: 20),

              // ─── Email (read-only) ─────────────────────────────────────────
              _FieldLabel('Correo electrónico', textPrimary),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF15151F) : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                child: TextField(
                  controller: _emailController,
                  readOnly: true,
                  style: GoogleFonts.dmSans(fontSize: 15, color: textSecondary),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined, color: textSecondary, size: 20),
                    suffixIcon: Icon(Icons.lock_outline_rounded, color: textSecondary, size: 16),
                    hintText: 'tu@email.com',
                    hintStyle: GoogleFonts.dmSans(fontSize: 14, color: textSecondary),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'El correo no puede modificarse por seguridad.',
                style: GoogleFonts.dmSans(
                    fontSize: 11, color: textSecondary, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 20),

              // ─── Sexo ──────────────────────────────────────────────────────
              _FieldLabel('Sexo', textPrimary),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _sexo,
                    hint: Text(
                      'Selecciona una opción',
                      style: GoogleFonts.dmSans(fontSize: 14, color: textSecondary),
                    ),
                    isExpanded: true,
                    dropdownColor: cardColor,
                    icon: Icon(Icons.keyboard_arrow_down_rounded, color: textSecondary),
                    style: GoogleFonts.dmSans(fontSize: 15, color: textPrimary),
                    items: _sexoOptions
                        .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text(s),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _sexo = v),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ─── Fecha de nacimiento / Edad ────────────────────────────────
              _FieldLabel('Fecha de nacimiento', textPrimary),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _pickDate(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.cake_outlined, color: const Color(0xFF9C27B0), size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _fechaNacimiento != null
                              ? '${DateFormat("d 'de' MMMM 'de' yyyy", 'es').format(_fechaNacimiento!)}  ·  $_edad años'
                              : 'Selecciona tu fecha de nacimiento',
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            color: _fechaNacimiento != null ? textPrimary : textSecondary,
                          ),
                        ),
                      ),
                      if (_fechaNacimiento != null)
                        GestureDetector(
                          onTap: () => setState(() => _fechaNacimiento = null),
                          child: Icon(Icons.close_rounded, size: 18, color: textSecondary),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ─── Ciudad ────────────────────────────────────────────────────
              _FieldLabel('Ciudad', textPrimary),
              const SizedBox(height: 8),
              _InputBox(
                controller: _ciudadController,
                icon: Icons.location_city_outlined,
                hint: 'Tu ciudad',
                cardColor: cardColor,
                borderColor: borderColor,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),
              const SizedBox(height: 40),

              // ─── Save button ───────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 54,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF9C27B0).withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _saving ? null : () => _save(userId, profileAsync?.valueOrNull),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28)),
                    ),
                    child: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Text(
                            'Guardar cambios',
                            style: GoogleFonts.syne(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaNacimiento ?? DateTime(2000),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      locale: const Locale('es'),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF9C27B0),
            brightness: Theme.of(ctx).brightness,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _fechaNacimiento = picked);
  }

  Future<void> _save(String userId, Profile? current) async {
    if (userId.isEmpty) return;
    setState(() => _saving = true);
    try {
      final updated = Profile(
        id: userId,
        fullName: _nameController.text.trim(),
        email: current?.email ?? _emailController.text.trim(),
        avatarUrl: current?.avatarUrl,
        bio: current?.bio,
        sexo: _sexo,
        fechaNacimiento: _fechaNacimiento,
        ciudad: _ciudadController.text.trim().isEmpty
            ? null
            : _ciudadController.text.trim(),
      );
      await ref.read(profileRepositoryProvider).updateProfile(updated);
      ref.invalidate(currentProfileProvider(userId));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('¡Perfil actualizado! ✨',
              style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
          backgroundColor: const Color(0xFF9C27B0),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ));
        context.go('/profile');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al guardar: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

// ─── Helper widgets ───────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _FieldLabel(this.text, this.color);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: GoogleFonts.syne(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      );
}

class _InputBox extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hint;
  final Color cardColor;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;

  const _InputBox({
    required this.controller,
    required this.icon,
    required this.hint,
    required this.cardColor,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.dmSans(fontSize: 15, color: textPrimary),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF9C27B0), size: 20),
          hintText: hint,
          hintStyle: GoogleFonts.dmSans(fontSize: 14, color: textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}
