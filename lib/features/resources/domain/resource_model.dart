class Resource {
  final int id;
  final String category;
  final String title;
  final String content;
  final String? iconName;
  final int displayOrder;

  const Resource({
    required this.id,
    required this.category,
    required this.title,
    required this.content,
    this.iconName,
    required this.displayOrder,
  });

  factory Resource.fromJson(Map<String, dynamic> json) => Resource(
    id: json['id'] as int,
    category: (json['category'] as String?) ?? '',
    title: (json['title'] as String?) ?? '',
    content: (json['content'] as String?) ?? '',
    iconName: json['icon_name'] as String?,
    displayOrder: (json['display_order'] as int?) ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category,
    'title': title,
    'content': content,
    'icon_name': iconName,
    'display_order': displayOrder,
  };
}
