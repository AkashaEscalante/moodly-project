class MoodModel {
  final int id;
  final String name;
  final String emoji;
  final String colorHex;
  final String? category;

  const MoodModel({
    required this.id,
    required this.name,
    this.emoji = '🙂',
    required this.colorHex,
    this.category,
  });

  factory MoodModel.fromJson(Map<String, dynamic> json) => MoodModel(
    id: json['id'] as int,
    name: json['name'] as String,
    emoji: json['emoji'] as String? ?? '🙂',
    colorHex: json['color_hex'] as String? ?? json['color_code'] as String? ?? '#CCCCCC',
    category: json['category'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'emoji': emoji,
    'color_hex': colorHex,
    'category': category,
  };
}
