class ProjectItem {
  const ProjectItem({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.tags,
    required this.image,
  });

  final String id;
  final String title;
  final String description;
  final String type;
  final List<String> tags;
  final String image;

  factory ProjectItem.fromJson(Map<String, dynamic> json) {
    return ProjectItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: json['type'] as String? ?? 'Personal',
      tags: (json['tags'] as List<dynamic>? ?? const [])
          .map((tag) => tag.toString())
          .toList(growable: false),
      image: json['image'] as String? ?? '',
    );
  }
}
