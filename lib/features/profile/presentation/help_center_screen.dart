import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  static const _faqs = [
    (
      q: '¿Cómo registro mi estado de ánimo?',
      a:
          'Toca el botón "Registrar" en la pantalla principal o selecciona el ícono de estado de ánimo en la barra inferior. Elige la emoción que mejor describe cómo te sientes, ajusta la intensidad del 1 al 5, añade actividades y una nota personal.',
    ),
    (
      q: '¿Puedo usar la app sin conexión a internet?',
      a:
          'La app requiere conexión para guardar y sincronizar tus registros con la nube. Sin internet puedes ver registros ya cargados, pero no podrás guardar nuevas entradas hasta reconectarte.',
    ),
    (
      q: '¿Cómo elimino una entrada del diario?',
      a:
          'Ve a "Mi Diario" y busca la entrada que deseas eliminar. Toca el ícono de papelera en la esquina superior derecha de la tarjeta. Se te pedirá confirmar antes de eliminarla.',
    ),
    (
      q: '¿Mis datos personales son privados?',
      a:
          'Sí. Tus datos están cifrados y almacenados de forma segura. Nunca se venden ni se comparten con terceros. Puedes revisar nuestra política completa en Perfil → Privacidad.',
    ),
    (
      q: '¿Cómo cambio entre modo oscuro y modo claro?',
      a:
          'Ve a tu Perfil y en la sección de Configuración encontrarás el toggle "Modo oscuro". Actívalo o desactívalo según tu preferencia.',
    ),
    (
      q: '¿Cómo funciona el chat con Maya?',
      a:
          'Maya es tu asistente de bienestar emocional, impulsada por inteligencia artificial. Puedes hablar con ella sobre cómo te sientes, tu día, o pedir consejos. Responde de forma empática y profesional. Accede desde la tarjeta "Habla con Maya" en la pantalla principal.',
    ),
    (
      q: '¿Por qué no veo mis estadísticas de la semana?',
      a:
          'Las estadísticas se calculan con base en tus registros de los últimos 7 días. Si acabas de crear tu cuenta, registra tu estado de ánimo durante algunos días para ver los datos reflejados.',
    ),
    (
      q: '¿Cómo recupero mi contraseña?',
      a:
          'En la pantalla de inicio de sesión toca "¿Olvidaste tu contraseña?". Recibirás un correo con las instrucciones para restablecerla.',
    ),
  ];

  static const _steps = [
    ('1', 'Crea tu cuenta', 'Regístrate con tu correo y una contraseña segura.'),
    ('2', 'Completa el onboarding', 'Familiarízate con las funciones principales.'),
    ('3', 'Registra tu primer estado de ánimo', 'Toca "Registrar" y elige cómo te sientes.'),
    ('4', 'Escribe en tu diario', 'Usa "Mi Diario" para reflexionar sobre tu día.'),
    ('5', 'Revisa tus estadísticas', 'Después de algunos días, explora tus patrones emocionales.'),
    ('6', 'Habla con Maya', 'Conversa con tu asistente de bienestar cuando lo necesites.'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0D0D1A) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF222222);
    final textSecondary = isDark ? const Color(0xFF9E9E9E) : const Color(0xFF666666);
    final cardColor = isDark ? const Color(0xFF1E1E2E) : const Color(0xFFF8F5FF);
    final borderColor = isDark ? const Color(0xFF2A2A3E) : const Color(0xFFEEEEEE);

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
              color: isDark ? const Color(0xFF1E1E2E) : const Color(0xFFF5F5F5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chevron_left_rounded,
              color: isDark ? Colors.white : const Color(0xFF555555),
            ),
          ),
        ),
        title: Text(
          'Centro de Ayuda',
          style: GoogleFonts.syne(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF2A1A45), const Color(0xFF1A0A2E)]
                      : [const Color(0xFFFFA726), const Color(0xFFFF7043)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.help_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '¿En qué podemos ayudarte?',
                          style: GoogleFonts.syne(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Encuentra respuestas rápidas aquí',
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Quick guide
            Text(
              'Guía rápida de inicio',
              style: GoogleFonts.syne(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: _steps
                    .map((s) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF9C27B0),
                                      Color(0xFF6A1B9A),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    s.$1,
                                    style: GoogleFonts.syne(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      s.$2,
                                      style: GoogleFonts.syne(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      s.$3,
                                      style: GoogleFonts.dmSans(
                                        fontSize: 12,
                                        color: textSecondary,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),

            const SizedBox(height: 28),

            Text(
              'Preguntas frecuentes',
              style: GoogleFonts.syne(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 14),

            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  children: _faqs.asMap().entries.map((entry) {
                    final i = entry.key;
                    final faq = entry.value;
                    return Column(
                      children: [
                        Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor: Colors.transparent,
                          ),
                          child: ExpansionTile(
                            tilePadding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 4,
                            ),
                            childrenPadding: const EdgeInsets.fromLTRB(
                                18, 0, 18, 16),
                            leading: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFF9C27B0)
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.question_mark_rounded,
                                color: Color(0xFF9C27B0),
                                size: 16,
                              ),
                            ),
                            title: Text(
                              faq.q,
                              style: GoogleFonts.syne(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: textPrimary,
                              ),
                            ),
                            iconColor: const Color(0xFF9C27B0),
                            collapsedIconColor: textSecondary,
                            children: [
                              Text(
                                faq.a,
                                style: GoogleFonts.dmSans(
                                  fontSize: 13,
                                  color: textSecondary,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (i < _faqs.length - 1)
                          Divider(
                            height: 1,
                            color: borderColor,
                            indent: 18,
                            endIndent: 18,
                          ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Support contact
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.support_agent_rounded,
                        color: Color(0xFF42A5F5),
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Soporte técnico',
                        style: GoogleFonts.syne(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '¿No encontraste lo que buscabas? Nuestro equipo está disponible para ayudarte.',
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF42A5F5).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            const Color(0xFF42A5F5).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.mail_outline_rounded,
                            color: Color(0xFF42A5F5), size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'soporte@moodly.app',
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF42A5F5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
