class ProjectItem {
  const ProjectItem({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.tags,
    required this.images,
    this.link,
  });

  final String id;
  final String title;
  final String description;
  final String type;
  final List<String> tags;
  final List<String> images;
  final String? link;

  /// Mantido por conveniência: primeira imagem da lista.
  String get image => images.isNotEmpty ? images.first : '';

  factory ProjectItem.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'] as List<dynamic>?;
    final images = rawImages != null
        ? rawImages.map((e) => e.toString()).toList(growable: false)
        : (json['image'] != null
            ? [json['image'].toString()]
            : const <String>[]);

    return ProjectItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: json['type'] as String? ?? 'Personal',
      tags: (json['tags'] as List<dynamic>? ?? const [])
          .map((tag) => tag.toString())
          .toList(growable: false),
      images: images,
      link: json['link'] as String?,
    );
  }
}
