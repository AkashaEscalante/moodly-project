import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moodly/features/auth/application/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Por favor completa todos los campos');
      return;
    }

    if (password.length < 6) {
      setState(() => _errorMessage = 'La contraseña debe tener al menos 6 caracteres');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authRepositoryProvider).signUp(email, password, name);
      if (!mounted) return;
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        context.go('/onboarding');
      } else {
        setState(() => _errorMessage =
            '¡Cuenta creada! Revisa tu correo electrónico y confirma tu cuenta para poder iniciar sesión.');
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      final msg = switch (e.message.toLowerCase()) {
        String m when m.contains('already registered') ||
            m.contains('already exists') =>
          'Este correo ya está registrado. Inicia sesión.',
        String m when m.contains('invalid email') => 'El formato del correo no es válido.',
        String m when m.contains('weak password') ||
            m.contains('password') =>
          'La contraseña es muy débil. Usa al menos 6 caracteres.',
        String m when m.contains('network') || m.contains('connection') =>
          'Sin conexión. Verifica tu internet.',
        _ => 'Error: ${e.message}',
      };
      setState(() => _errorMessage = msg);
    } catch (e) {
      if (mounted) setState(() => _errorMessage = 'Error inesperado: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF3E8FF), Color(0xFFFFF9F5)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 36),
                const _MoodlyLogoCompact(),
                const SizedBox(height: 32),
                _AuthCard(
                  title: 'Crea tu cuenta 🌷',
                  subtitle: 'Únete a tu espacio de bienestar',
                  child: Column(
                    children: [
                      _SoftTextField(
                        controller: _nameController,
                        label: 'Nombre completo',
                        icon: Icons.person_outline_rounded,
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 16),
                      _SoftTextField(
                        controller: _emailController,
                        label: 'Correo electrónico',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      _SoftTextField(
                        controller: _passwordController,
                        label: 'Contraseña',
                        icon: Icons.lock_outline,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: const Color(0xFFB8B8B8),
                            size: 20,
                          ),
                          onPressed: () =>
                              setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _errorMessage!,
                            style: GoogleFonts.dmSans(
                              fontSize: 13,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 28),
                      _GradientButton(
                        text: '🌸 Crear mi cuenta',
                        isLoading: _isLoading,
                        onPressed: _signUp,
                        gradientColors: const [Color(0xFFCE93D8), Color(0xFF9C27B0)],
                        shadowColor: Color(0xFF9C27B0),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Al registrarte aceptas nuestros términos de uso',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: const Color(0xFFBBBBBB),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                _AuthFooterLink(
                  message: '¿Ya tienes cuenta? ',
                  linkText: 'Inicia sesión',
                  onTap: () => context.go('/login'),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Shared auth UI components
// ──────────────────────────────────────────────

class _MoodlyLogoCompact extends StatelessWidget {
  const _MoodlyLogoCompact();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFCE93D8).withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/LogoMoodly.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: const Color(0xFFF3E8FF),
                child: const Icon(
                  Icons.favorite_rounded,
                  size: 30,
                  color: Color(0xFF9C27B0),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Moodly',
          style: GoogleFonts.pacifico(
            fontSize: 28,
            color: const Color(0xFF7B4F9E),
          ),
        ),
      ],
    );
  }
}

class _AuthCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _AuthCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFCE93D8).withValues(alpha: 0.2),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.syne(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: const Color(0xFFAAAAAA),
            ),
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}

class _SoftTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  const _SoftTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: GoogleFonts.dmSans(fontSize: 15, color: const Color(0xFF333333)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.dmSans(fontSize: 14, color: const Color(0xFFB8B8B8)),
        prefixIcon: Icon(icon, color: const Color(0xFFCE93D8), size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFEEEEEE), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFCE93D8), width: 2),
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onPressed;
  final List<Color> gradientColors;
  final Color shadowColor;

  const _GradientButton({
    required this.text,
    required this.isLoading,
    required this.onPressed,
    this.gradientColors = const [Color(0xFFF48FB1), Color(0xFFE91E8C)],
    this.shadowColor = const Color(0xFFE91E8C),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isLoading
              ? const LinearGradient(colors: [Color(0xFFE0E0E0), Color(0xFFE0E0E0)])
              : LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: isLoading
              ? []
              : [
                  BoxShadow(
                    color: shadowColor.withValues(alpha: 0.28),
                    blurRadius: 18,
                    offset: const Offset(0, 7),
                  ),
                ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                )
              : Text(
                  text,
                  style: GoogleFonts.syne(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
        ),
      ),
    );
  }
}

class _AuthFooterLink extends StatelessWidget {
  final String message;
  final String linkText;
  final VoidCallback onTap;

  const _AuthFooterLink({
    required this.message,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          message,
          style: GoogleFonts.dmSans(color: const Color(0xFFAAAAAA), fontSize: 14),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            linkText,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF7B4F9E),
            ),
          ),
        ),
      ],
    );
  }
}
