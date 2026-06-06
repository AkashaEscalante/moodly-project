import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moodly/features/auth/application/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Por favor completa todos los campos');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authRepositoryProvider).signIn(email, password);
      if (mounted) context.go('/home');
    } on AuthException catch (e) {
      if (!mounted) return;
      final msg = switch (e.message.toLowerCase()) {
        String m when m.contains('not confirmed') ||
            m.contains('email not confirmed') =>
          'Debes confirmar tu correo antes de iniciar sesión.',
        String m when m.contains('invalid') || m.contains('credentials') =>
          'Email o contraseña incorrectos.',
        String m when m.contains('network') || m.contains('connection') =>
          'Sin conexión. Verifica tu internet.',
        _ => 'Error: ${e.message}',
      };
      setState(() => _errorMessage = msg);
    } catch (_) {
      if (mounted) setState(() => _errorMessage = 'Email o contraseña incorrectos.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF04040F),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // Glow blobs — substrato del glassmorphism
          Positioned(
            top: -80, left: -80,
            child: _GlowBlob(color: const Color(0xFF7B1FA2), size: 300),
          ),
          Positioned(
            bottom: 40, right: -80,
            child: _GlowBlob(color: const Color(0xFFAD1457), size: 240),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 52),

                  // Logo
                  _DarkMoodlyLogo()
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .scale(
                        begin: const Offset(0.85, 0.85),
                        duration: 500.ms,
                        curve: Curves.easeOut,
                      ),

                  const SizedBox(height: 44),

                  // Tarjeta glassmorphic de login
                  _GlassAuthCard(
                    title: 'Bienvenida de vuelta ✨',
                    subtitle: 'Inicia sesión para continuar',
                    child: Column(
                      children: [
                        _DarkTextField(
                          controller: _emailController,
                          label: 'Correo electrónico',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        _DarkTextField(
                          controller: _passwordController,
                          label: 'Contraseña',
                          icon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.white38,
                              size: 20,
                            ),
                            onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword),
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
                        _PurpleGradientButton(
                          text: 'Iniciar Sesión',
                          isLoading: _isLoading,
                          onPressed: _signIn,
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 150.ms, duration: 400.ms)
                      .slideY(
                        begin: 0.08,
                        duration: 400.ms,
                        curve: Curves.easeOut,
                      ),

                  const SizedBox(height: 32),

                  _DarkFooterLink(
                    message: '¿No tienes cuenta? ',
                    linkText: 'Regístrate',
                    onTap: () => context.go('/register'),
                  ).animate().fadeIn(delay: 300.ms),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Logo oscuro ──────────────────────────────────────────────────────────────

class _DarkMoodlyLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9C27B0).withValues(alpha: 0.6),
                blurRadius: 48,
                spreadRadius: 8,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/LogoMoodly.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    colors: [Color(0xFFCE93D8), Color(0xFF4A148C)],
                    center: Alignment(-0.3, -0.3),
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('🐱', style: TextStyle(fontSize: 52)),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Moodly',
          style: GoogleFonts.pacifico(
            fontSize: 36,
            color: Colors.white,
            letterSpacing: 0.5,
            shadows: [
              Shadow(
                color: const Color(0xFF9C27B0).withValues(alpha: 0.7),
                blurRadius: 20,
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Tu espacio de bienestar 🌸',
          style: GoogleFonts.dmSans(
            fontSize: 13,
            color: Colors.white54,
          ),
        ),
      ],
    );
  }
}

// ─── Tarjeta glassmorphic de auth ─────────────────────────────────────────────

class _GlassAuthCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _GlassAuthCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.10),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.syne(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: Colors.white38,
                ),
              ),
              const SizedBox(height: 24),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

// ─── TextField oscuro ─────────────────────────────────────────────────────────

class _DarkTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  const _DarkTextField({
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
      style: GoogleFonts.dmSans(fontSize: 15, color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.dmSans(
            fontSize: 14, color: Colors.white38),
        prefixIcon: Icon(icon, color: const Color(0xFFCE93D8), size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFF1A1A2E),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF2A2A3E), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF9C27B0), width: 2),
        ),
      ),
    );
  }
}

// ─── Botón degradado morado-rosa ──────────────────────────────────────────────

class _PurpleGradientButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onPressed;

  const _PurpleGradientButton({
    required this.text,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isLoading
              ? const LinearGradient(
                  colors: [Color(0xFF2A2A3E), Color(0xFF2A2A3E)])
              : const LinearGradient(
                  colors: [Color(0xFFFF80AB), Color(0xFF9C27B0)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: isLoading
              ? []
              : [
                  BoxShadow(
                    color: const Color(0xFF9C27B0).withValues(alpha: 0.45),
                    blurRadius: 22,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28)),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2.5),
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

// ─── Link pie de pantalla ─────────────────────────────────────────────────────

class _DarkFooterLink extends StatelessWidget {
  final String message;
  final String linkText;
  final VoidCallback onTap;

  const _DarkFooterLink({
    required this.message,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(message,
            style: GoogleFonts.dmSans(color: Colors.white38, fontSize: 14)),
        GestureDetector(
          onTap: onTap,
          child: Text(
            linkText,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFCE93D8),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Glow blob de fondo ───────────────────────────────────────────────────────

class _GlowBlob extends StatelessWidget {
  final Color color;
  final double size;
  const _GlowBlob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.10),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.28),
            blurRadius: size * 0.75,
            spreadRadius: size * 0.35,
          ),
        ],
      ),
    );
  }
}
