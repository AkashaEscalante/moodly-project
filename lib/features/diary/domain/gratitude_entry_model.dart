class GratitudeEntry {
  final String id;
  final String userId;
  final String content;
  final String? moodIcon;
  final DateTime entryDate;

  const GratitudeEntry({
    required this.id,
    required this.userId,
    required this.content,
    this.moodIcon,
    required this.entryDate,
  });

  factory GratitudeEntry.fromJson(Map<String, dynamic> json) => GratitudeEntry(
    id: json['id'] as String,
    userId: (json['user_id'] as String?) ?? '',
    content: json['content'] as String,
    moodIcon: json['mood_icon'] as String?,
    entryDate: DateTime.parse(json['entry_date'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'content': content,
    'mood_icon': moodIcon,
    'entry_date': entryDate.toIso8601String().split('T')[0],
  };
}
