import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

// Misiones agrupadas por momento del día
const _missionsByHour = <(String, String, String)>[
  // (emoji, título, descripción)
  ('🧘', 'Respira profundo', '3 respiraciones lentas antes de continuar'),
  ('💧', 'Hidratación', 'Toma un vaso de agua ahora mismo'),
  ('✍️', 'Gratitud exprés', 'Escribe una cosa buena que pasó hoy'),
  ('🚶', 'Mueve el cuerpo', '5 minutos de caminata o estiramiento'),
  ('📵', 'Descanso digital', '10 minutos sin pantallas en la próxima hora'),
  ('🌙', 'Reflexión nocturna', '¿Qué aprendiste hoy de ti mismo/a?'),
  ('🎯', 'Intención del día', 'Define una meta pequeña y alcanzable hoy'),
  ('🤗', 'Conexión social', 'Manda un mensaje a alguien que quieras'),
  ('🌿', 'Momento natural', 'Mira por la ventana 2 minutos sin pensar'),
];

class MicroMissionsCard extends StatefulWidget {
  const MicroMissionsCard({super.key});

  @override
  State<MicroMissionsCard> createState() => _MicroMissionsCardState();
}

class _MicroMissionsCardState extends State<MicroMissionsCard> {
  late final List<(String, String, String)> _missions;
  final Set<int> _completed = {};

  @override
  void initState() {
    super.initState();
    // Rota las misiones por día para que cambien diariamente
    final seed = DateTime.now().day;
    final offset = seed % (_missionsByHour.length - 2);
    _missions = [
      _missionsByHour[offset % _missionsByHour.length],
      _missionsByHour[(offset + 1) % _missionsByHour.length],
      _missionsByHour[(offset + 2) % _missionsByHour.length],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final completedAll = _completed.length == _missions.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Encabezado de sección
        Row(
          children: [
            Text(
              'Micro-Misiones de hoy',
              style: GoogleFonts.syne(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF222222),
              ),
            ),
            const Spacer(),
            if (completedAll)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Colors.green.withValues(alpha: 0.4)),
                ),
                child: Text(
                  '¡Completadas!',
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.green,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 300.ms)
                  .scale(begin: const Offset(0.8, 0.8)),
          ],
        ),
        const SizedBox(height: 12),

        // Tarjetas glassmorphic de cada misión
        for (var i = 0; i < _missions.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _MissionTile(
              emoji: _missions[i].$1,
              title: _missions[i].$2,
              description: _missions[i].$3,
              isDone: _completed.contains(i),
              isDark: isDark,
              onTap: () => setState(() {
                if (_completed.contains(i)) {
                  _completed.remove(i);
                } else {
                  _completed.add(i);
                }
              }),
            )
                .animate()
                .fadeIn(delay: Duration(milliseconds: i * 80), duration: 350.ms)
                .slideX(begin: 0.04, duration: 350.ms, curve: Curves.easeOut),
          ),
      ],
    );
  }
}

class _MissionTile extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;
  final bool isDone;
  final bool isDark;
  final VoidCallback onTap;

  const _MissionTile({
    required this.emoji,
    required this.title,
    required this.description,
    required this.isDone,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: isDone
                  ? LinearGradient(
                      colors: isDark
                          ? [
                              const Color(0xFF4A148C).withValues(alpha: 0.6),
                              const Color(0xFF6A1B9A).withValues(alpha: 0.6),
                            ]
                          : [
                              const Color(0xFFEDE7F6),
                              const Color(0xFFE1BEE7),
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isDone
                  ? null
                  : (isDark
                      ? const Color(0xFF1E1E2E)
                      : Colors.white),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDone
                    ? Colors.purpleAccent.withValues(alpha: 0.5)
                    : (isDark
                        ? const Color(0xFF2A2A3E)
                        : const Color(0xFFF0F0F0)),
                width: isDone ? 1.5 : 1,
              ),
              boxShadow: isDone
                  ? [
                      BoxShadow(
                        color: Colors.purpleAccent.withValues(alpha: 0.18),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(
                            alpha: isDark ? 0.15 : 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Row(
              children: [
                // Emoji en círculo con neon glow cuando está activo
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone
                        ? Colors.purpleAccent.withValues(alpha: 0.2)
                        : (isDark
                            ? const Color(0xFF2A2A3E)
                            : const Color(0xFFF5F0FF)),
                    border: isDone
                        ? Border.all(
                            color:
                                Colors.purpleAccent.withValues(alpha: 0.5),
                            width: 1.5,
                          )
                        : null,
                  ),
                  child: Center(
                    child: Text(emoji,
                        style: const TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(width: 14),

                // Texto
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.syne(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDone
                              ? Colors.purpleAccent
                              : (isDark
                                  ? Colors.white
                                  : const Color(0xFF222222)),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        description,
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          color: isDark
                              ? const Color(0xFF9E9E9E)
                              : const Color(0xFF888888),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),

                // Indicador check
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone
                        ? Colors.purpleAccent
                        : Colors.transparent,
                    border: Border.all(
                      color: isDone
                          ? Colors.purpleAccent
                          : (isDark
                              ? const Color(0xFF3A3A4E)
                              : const Color(0xFFDDDDDD)),
                      width: 2,
                    ),
                  ),
                  child: isDone
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 14)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
