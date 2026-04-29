class MoodStats {
  final String mostFrequentMood;
  final int streak;
  final List<Map<String, dynamic>> weekData;

  const MoodStats({
    required this.mostFrequentMood,
    required this.streak,
    required this.weekData,
  });

  factory MoodStats.fromJson(Map<String, dynamic> json) => MoodStats(
    mostFrequentMood: json['most_frequent_mood'] as String,
    streak: json['streak'] as int,
    weekData: (json['week_data'] as List<dynamic>).cast<Map<String, dynamic>>(),
  );

  Map<String, dynamic> toJson() => {
    'most_frequent_mood': mostFrequentMood,
    'streak': streak,
    'week_data': weekData,
  };
}
