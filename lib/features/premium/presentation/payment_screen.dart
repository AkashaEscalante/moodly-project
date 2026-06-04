import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moodly/features/premium/application/premium_provider.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final String planName;
  final String price;
  final String period;

  const PaymentScreen({
    super.key,
    required this.planName,
    required this.price,
    required this.period,
  });

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  int _method = 0; // 0=tarjeta, 1=oxxo
  bool _processing = false;

  final _cardNumberCtrl = TextEditingController();
  final _cardNameCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();

  late final String _oxxoRef;

  @override
  void initState() {
    super.initState();
    final rand = Random();
    _oxxoRef = List.generate(18, (_) => rand.nextInt(10)).join();
  }

  @override
  void dispose() {
    _cardNumberCtrl.dispose();
    _cardNameCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  Future<void> _onPay() async {
    setState(() => _processing = true);
    // Simular procesamiento de 1.5s
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    ref.read(isPremiumProvider.notifier).state = true;
    setState(() => _processing = false);

    // Mostrar snackbar de éxito y cerrar ambas pantallas
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '🐱 ¡Bienvenida a Premium ${widget.planName}!',
          style: GoogleFonts.dmSans(fontWeight: FontWeight.w700),
        ),
        backgroundColor: const Color(0xFF9C27B0),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
    // Salir de payment Y premium screen
    context.pop(); // payment -> premium
    context.pop(); // premium -> donde vino
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF04040F),
      body: Stack(
        children: [
          Positioned(
            top: -50, right: -70,
            child: _blob(const Color(0xFF9C27B0), 220),
          ),
          Positioned(
            bottom: -40, left: -40,
            child: _blob(const Color(0xFFAD1457), 170),
          ),

          SafeArea(
            child: Column(
              children: [
                // AppBar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.12)),
                          ),
                          child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 16),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        'Finalizar compra',
                        style: GoogleFonts.syne(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      // SSL badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.green.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.lock_rounded,
                                color: Colors.green, size: 11),
                            const SizedBox(width: 4),
                            Text(
                              'SSL',
                              style: GoogleFonts.dmSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Resumen del plan
                        _GlassBox(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFF80AB),
                                      Color(0xFF9C27B0)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Text('🐱',
                                    style: TextStyle(fontSize: 22)),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Moodly Premium ${widget.planName}',
                                      style: GoogleFonts.syne(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      widget.period,
                                      style: GoogleFonts.dmSans(
                                          fontSize: 12,
                                          color: Colors.white54),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '\$${widget.price}',
                                style: GoogleFonts.syne(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 350.ms),

                        const SizedBox(height: 24),

                        // Selector de método
                        Text(
                          'Método de pago',
                          style: GoogleFonts.syne(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ).animate().fadeIn(delay: 80.ms),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: _MethodChip(
                                icon: Icons.credit_card_rounded,
                                label: 'Tarjeta',
                                selected: _method == 0,
                                onTap: () =>
                                    setState(() => _method = 0),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _MethodChip(
                                icon: Icons.store_rounded,
                                label: 'OXXO',
                                selected: _method == 1,
                                onTap: () =>
                                    setState(() => _method = 1),
                              ),
                            ),
                          ],
                        ).animate().fadeIn(delay: 120.ms),

                        const SizedBox(height: 20),

                        // Formulario animado
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 280),
                          transitionBuilder: (child, anim) =>
                              FadeTransition(
                                  opacity: anim,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, 0.04),
                                      end: Offset.zero,
                                    ).animate(anim),
                                    child: child,
                                  )),
                          child: _method == 0
                              ? _CardForm(
                                  key: const ValueKey('card'),
                                  numberCtrl: _cardNumberCtrl,
                                  nameCtrl: _cardNameCtrl,
                                  expiryCtrl: _expiryCtrl,
                                  cvvCtrl: _cvvCtrl,
                                )
                              : _OxxoForm(
                                  key: const ValueKey('oxxo'),
                                  reference: _oxxoRef,
                                  amount: '\$${widget.price} MXN',
                                ),
                        ),

                        const SizedBox(height: 32),

                        // Botón pagar
                        GestureDetector(
                          onTap: _processing ? null : _onPay,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: double.infinity,
                            padding:
                                const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              gradient: _processing
                                  ? null
                                  : const LinearGradient(
                                      colors: [
                                        Color(0xFFFF80AB),
                                        Color(0xFF9C27B0)
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                              color: _processing
                                  ? Colors.white.withValues(alpha: 0.1)
                                  : null,
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: _processing
                                  ? []
                                  : [
                                      BoxShadow(
                                        color: const Color(0xFF9C27B0)
                                            .withValues(alpha: 0.5),
                                        blurRadius: 28,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                            ),
                            child: _processing
                                ? const SizedBox(
                                    height: 22,
                                    child: Center(
                                      child: SizedBox(
                                        width: 22, height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                : Text(
                                    _method == 0
                                        ? 'Pagar  \$${widget.price} MXN'
                                        : 'Generar referencia OXXO',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.syne(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 400.ms, duration: 350.ms)
                            .scale(
                              begin: const Offset(0.95, 0.95),
                              duration: 350.ms,
                              curve: Curves.easeOut,
                            ),
                      ],
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

  Widget _blob(Color color, double size) => Container(
    width: size, height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color.withValues(alpha: 0.09),
      boxShadow: [
        BoxShadow(
          color: color.withValues(alpha: 0.22),
          blurRadius: size * 0.9,
          spreadRadius: size * 0.3,
        ),
      ],
    ),
  );
}

// ─── Widgets compartidos ──────────────────────────────────────────────────────

class _GlassBox extends StatelessWidget {
  final Widget child;
  const _GlassBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.11),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _MethodChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _MethodChip({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  colors: [Color(0xFF5E1A8A), Color(0xFF9C27B0)],
                )
              : null,
          color: selected ? null : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? const Color(0xFFCE93D8).withValues(alpha: 0.8)
                : Colors.white.withValues(alpha: 0.1),
            width: selected ? 1.5 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFF9C27B0).withValues(alpha: 0.3),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: selected ? Colors.white : Colors.white54,
                size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.syne(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: selected ? Colors.white : Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Formulario tarjeta ───────────────────────────────────────────────────────

class _CardForm extends StatelessWidget {
  final TextEditingController numberCtrl;
  final TextEditingController nameCtrl;
  final TextEditingController expiryCtrl;
  final TextEditingController cvvCtrl;

  const _CardForm({
    super.key,
    required this.numberCtrl,
    required this.nameCtrl,
    required this.expiryCtrl,
    required this.cvvCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mini card visual preview
        _CardPreview(
          numberCtrl: numberCtrl,
          nameCtrl: nameCtrl,
          expiryCtrl: expiryCtrl,
        ),
        const SizedBox(height: 20),

        _fieldLabel('Número de tarjeta'),
        const SizedBox(height: 8),
        _GlassField(
          controller: numberCtrl,
          hint: '1234  5678  9012  3456',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
            _CardNumberFormatter(),
          ],
          prefixIcon: Icons.credit_card_rounded,
        ),
        const SizedBox(height: 16),

        _fieldLabel('Nombre en la tarjeta'),
        const SizedBox(height: 8),
        _GlassField(
          controller: nameCtrl,
          hint: 'Como aparece en la tarjeta',
          textCapitalization: TextCapitalization.characters,
          prefixIcon: Icons.person_outline_rounded,
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel('Vencimiento'),
                  const SizedBox(height: 8),
                  _GlassField(
                    controller: expiryCtrl,
                    hint: 'MM/AA',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                      _ExpiryFormatter(),
                    ],
                    prefixIcon: Icons.date_range_rounded,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel('CVV'),
                  const SizedBox(height: 8),
                  _GlassField(
                    controller: cvvCtrl,
                    hint: '•••',
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    prefixIcon: Icons.lock_outline_rounded,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _fieldLabel(String text) => Text(
    text,
    style: GoogleFonts.dmSans(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Colors.white60,
    ),
  );
}

// Mini previsualización de tarjeta
class _CardPreview extends StatefulWidget {
  final TextEditingController numberCtrl;
  final TextEditingController nameCtrl;
  final TextEditingController expiryCtrl;

  const _CardPreview({
    required this.numberCtrl,
    required this.nameCtrl,
    required this.expiryCtrl,
  });

  @override
  State<_CardPreview> createState() => _CardPreviewState();
}

class _CardPreviewState extends State<_CardPreview> {
  @override
  void initState() {
    super.initState();
    widget.numberCtrl.addListener(() => setState(() {}));
    widget.nameCtrl.addListener(() => setState(() {}));
    widget.expiryCtrl.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final num = widget.numberCtrl.text.padRight(16, '•');
    final displayNum = [
      num.substring(0, 4),
      num.substring(4, 8),
      num.substring(8, 12),
      num.substring(12, 16),
    ].join('  ');
    final name = widget.nameCtrl.text.isEmpty
        ? 'NOMBRE APELLIDO'
        : widget.nameCtrl.text;
    final exp =
        widget.expiryCtrl.text.isEmpty ? '••/••' : widget.expiryCtrl.text;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6A1B9A), Color(0xFFAD1457)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9C27B0).withValues(alpha: 0.4),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Moodly Pay',
                    style: GoogleFonts.syne(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  Container(
                    width: 38, height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                    child: const Center(
                      child: Icon(Icons.credit_card,
                          color: Colors.white70, size: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                displayNum,
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name.toUpperCase(),
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: Colors.white70,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    exp,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: Colors.white70,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Formulario OXXO ──────────────────────────────────────────────────────────

class _OxxoForm extends StatelessWidget {
  final String reference;
  final String amount;

  const _OxxoForm({
    super.key,
    required this.reference,
    required this.amount,
  });

  String get _formatted {
    final groups = <String>[];
    for (var i = 0; i < reference.length; i += 4) {
      final end = (i + 4).clamp(0, reference.length);
      groups.add(reference.substring(i, end));
    }
    return groups.join('  ');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _GlassBox(
          child: Column(
            children: [
              // Cabecera OXXO
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE91E00),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'OXXO',
                      style: GoogleFonts.syne(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Paga en cualquier tienda OXXO del país',
                      style: GoogleFonts.dmSans(
                          fontSize: 12, color: Colors.white54),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // Código de barras simulado
              _BarcodeWidget(seed: reference.hashCode),
              const SizedBox(height: 16),

              // Número de referencia
              Text(
                _formatted,
                style: GoogleFonts.dmSans(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Número de referencia',
                style: GoogleFonts.dmSans(
                    fontSize: 11, color: Colors.white38),
              ),
              const SizedBox(height: 18),

              // Total
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: Column(
                  children: [
                    Text('Total a pagar',
                        style: GoogleFonts.dmSans(
                            fontSize: 11, color: Colors.white38)),
                    const SizedBox(height: 4),
                    Text(
                      amount,
                      style: GoogleFonts.syne(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        _GlassBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Instrucciones',
                style: GoogleFonts.syne(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              for (final step in [
                '1. Ve a tu tienda OXXO más cercana.',
                '2. Indica que deseas hacer un pago de servicios.',
                '3. Muestra este código de referencia al cajero.',
                '4. Paga el monto exacto en efectivo.',
                '5. Guarda tu ticket como comprobante.',
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.circle,
                          color: Color(0xFFCE93D8), size: 6),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          step,
                          style: GoogleFonts.dmSans(
                              fontSize: 12,
                              color: Colors.white60,
                              height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Código de barras simulado ────────────────────────────────────────────────

class _BarcodeWidget extends StatelessWidget {
  final int seed;
  const _BarcodeWidget({required this.seed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      width: double.infinity,
      child: CustomPaint(painter: _BarcodePainter(seed: seed)),
    );
  }
}

class _BarcodePainter extends CustomPainter {
  final int seed;
  _BarcodePainter({required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final rand = Random(seed);
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    var x = 0.0;
    while (x < size.width) {
      final barW = 1.2 + rand.nextDouble() * 3.0;
      final gapW = 0.8 + rand.nextDouble() * 2.5;
      final heightFactor = rand.nextDouble() > 0.12 ? 1.0 : 0.65;
      final h = size.height * heightFactor;
      final top = (size.height - h) / 2;
      canvas.drawRect(Rect.fromLTWH(x, top, barW, h), paint);
      x += barW + gapW;
    }
  }

  @override
  bool shouldRepaint(covariant _BarcodePainter old) => old.seed != seed;
}

// ─── TextField glassmorphic ───────────────────────────────────────────────────

class _GlassField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final IconData? prefixIcon;

  const _GlassField({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.14),
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            textCapitalization: textCapitalization,
            inputFormatters: inputFormatters,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: Colors.white,
              letterSpacing: 0.8,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.dmSans(
                  fontSize: 14, color: Colors.white30),
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon,
                      color: Colors.white38, size: 18)
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Input formatters ─────────────────────────────────────────────────────────

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write('  ');
      buffer.write(digits[i]);
    }
    final text = buffer.toString();
    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length && i < 4; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(digits[i]);
    }
    final text = buffer.toString();
    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
