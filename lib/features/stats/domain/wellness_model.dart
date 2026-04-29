class WellnessData {
  final double sleepHours;
  final double energyPct;
  final double meditationMin;
  final double hydrationL;

  const WellnessData({
    required this.sleepHours,
    required this.energyPct,
    required this.meditationMin,
    required this.hydrationL,
  });

  factory WellnessData.fromJson(Map<String, dynamic> json) => WellnessData(
    sleepHours: json['sleep_hours'] as double,
    energyPct: json['energy_pct'] as double,
    meditationMin: json['meditation_min'] as double,
    hydrationL: json['hydration_l'] as double,
  );

  Map<String, dynamic> toJson() => {
    'sleep_hours': sleepHours,
    'energy_pct': energyPct,
    'meditation_min': meditationMin,
    'hydration_l': hydrationL,
  };
}
