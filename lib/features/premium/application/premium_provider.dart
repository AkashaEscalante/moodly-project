import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Estado premium del usuario (true = sin límites).
final isPremiumProvider = StateProvider<bool>((ref) => false);

/// Mensajes gratuitos permitidos por día en el plan Gratis.
const int kFreeChatLimit = 5;

// ─── Límite diario de mensajes ────────────────────────────────────────────────

class _DailyLimitState {
  final int count;
  final String date; // formato 'YYYY-MM-DD'
  const _DailyLimitState({required this.count, required this.date});
}

class DailyLimitNotifier extends StateNotifier<_DailyLimitState> {
  DailyLimitNotifier()
      : super(_DailyLimitState(count: 0, date: _todayStr()));

  static String _todayStr() =>
      DateTime.now().toIso8601String().split('T')[0];

  /// Cuántos mensajes se han enviado hoy (0 si es un día nuevo).
  int get todayCount {
    if (state.date != _todayStr()) return 0;
    return state.count;
  }

  /// Cuántos mensajes quedan disponibles hoy.
  int get remaining => (kFreeChatLimit - todayCount).clamp(0, kFreeChatLimit);

  /// True si el usuario ya agotó los 5 mensajes de hoy.
  bool get hasReachedLimit => todayCount >= kFreeChatLimit;

  /// Registra un mensaje enviado.
  void increment() {
    final today = _todayStr();
    if (state.date != today) {
      // Nuevo día → reiniciar contador
      state = _DailyLimitState(count: 1, date: today);
    } else {
      state = _DailyLimitState(count: state.count + 1, date: today);
    }
  }

  /// Fuerza el reset (útil para pruebas / modo dev).
  void reset() =>
      state = _DailyLimitState(count: 0, date: _todayStr());
}

final dailyLimitProvider =
    StateNotifierProvider<DailyLimitNotifier, _DailyLimitState>(
  (ref) => DailyLimitNotifier(),
);

// Compatibilidad con código antiguo que usaba chatMessageCountProvider
final chatMessageCountProvider = StateProvider<int>((ref) => 0);
