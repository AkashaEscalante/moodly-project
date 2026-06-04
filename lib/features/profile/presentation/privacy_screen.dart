import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

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
          onTap: () => Navigator.of(context).pop(),
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
          'Privacidad',
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
            // Header gradient card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
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
                      Icons.lock_rounded,
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
                          'Tu privacidad importa',
                          style: GoogleFonts.syne(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Última actualización: Junio 2025',
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

            _SectionCard(
              icon: Icons.info_outline_rounded,
              iconColor: const Color(0xFF42A5F5),
              title: 'Información que recopilamos',
              cardColor: cardColor,
              borderColor: borderColor,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              items: const [
                _Item('📧', 'Correo electrónico y nombre de cuenta'),
                _Item('😊', 'Registros de estado de ánimo e intensidad'),
                _Item('📔', 'Entradas de tu diario personal'),
                _Item('📊', 'Actividades y hábitos registrados'),
                _Item('🔥', 'Estadísticas de racha y consistencia'),
              ],
            ),

            const SizedBox(height: 16),

            _SectionCard(
              icon: Icons.shield_outlined,
              iconColor: const Color(0xFF66BB6A),
              title: 'Cómo usamos tus datos',
              cardColor: cardColor,
              borderColor: borderColor,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              items: const [
                _Item('✅', 'Personalizar tu experiencia dentro de la app'),
                _Item('📈', 'Generar tus estadísticas y reportes de bienestar'),
                _Item('🤖', 'Mejorar las respuestas de Maya, tu asistente'),
                _Item('🚫', 'Tus datos NUNCA se venden a terceros'),
                _Item('🔒', 'No se comparten con anunciantes ni empresas externas'),
              ],
            ),

            const SizedBox(height: 16),

            _SectionCard(
              icon: Icons.person_outline_rounded,
              iconColor: const Color(0xFFFFA726),
              title: 'Tus derechos',
              cardColor: cardColor,
              borderColor: borderColor,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              items: const [
                _Item('🗑️', 'Eliminar tu cuenta y todos tus datos en cualquier momento'),
                _Item('✏️', 'Actualizar o corregir tu información personal'),
                _Item('📤', 'Solicitar exportación de tus datos registrados'),
                _Item('🚫', 'Revocar el consentimiento de uso de datos'),
              ],
            ),

            const SizedBox(height: 16),

            _SectionCard(
              icon: Icons.security_rounded,
              iconColor: const Color(0xFFAB47BC),
              title: 'Seguridad de tus datos',
              cardColor: cardColor,
              borderColor: borderColor,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              items: const [
                _Item('🔐', 'Almacenamiento seguro en Supabase con cifrado AES-256'),
                _Item('🌐', 'Transmisión protegida mediante HTTPS/TLS'),
                _Item('🔑', 'Contraseñas almacenadas con hash bcrypt (nunca en texto plano)'),
                _Item('👤', 'Acceso limitado solo al usuario autenticado'),
              ],
            ),

            const SizedBox(height: 16),

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
                      const Icon(Icons.mail_outline_rounded,
                          color: Color(0xFFF48FB1), size: 22),
                      const SizedBox(width: 10),
                      Text(
                        'Contacto',
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
                    '¿Tienes preguntas sobre tu privacidad? Escríbenos a:',
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'privacidad@moodly.app',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF9C27B0),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Center(
              child: Text(
                'Moodly © 2025 · Todos los derechos reservados',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  color: textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Item {
  final String emoji;
  final String text;
  const _Item(this.emoji, this.text);
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Color cardColor;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;
  final List<_Item> items;

  const _SectionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.cardColor,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Icon(icon, color: iconColor, size: 22),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.syne(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.emoji,
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.text,
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
