class ActivityModel {
  final int id;
  final String name;
  final String? iconUrl;
  final String colorCode;

  const ActivityModel({
    required this.id,
    required this.name,
    this.iconUrl,
    required this.colorCode,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
    id: json['id'] as int,
    name: json['name'] as String,
    iconUrl: json['icon_url'] as String?,
    colorCode: json['color_code'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'icon_url': iconUrl,
    'color_code': colorCode,
  };
}
