import 'package:moodly/features/mood/domain/mood_model.dart';

class MoodEntryModel {
  final String id;
  final String userId;
  final MoodModel mood;
  final List<String> activities;
  final String? note;
  final int intensity;
  final DateTime createdAt;

  const MoodEntryModel({
    required this.id,
    required this.userId,
    required this.mood,
    required this.activities,
    this.note,
    this.intensity = 3,
    required this.createdAt,
  });

  factory MoodEntryModel.fromJson(Map<String, dynamic> json) => MoodEntryModel(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    mood: MoodModel.fromJson(json['emotion'] as Map<String, dynamic>),
    activities: (json['activities'] as List<dynamic>?)?.cast<String>() ?? [],
    note: json['note'] as String?,
    intensity: (json['intensity'] as int?) ?? 3,
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'emotion': mood.toJson(),
    'activities': activities,
    'note': note,
    'intensity': intensity,
    'created_at': createdAt.toIso8601String(),
  };
}
