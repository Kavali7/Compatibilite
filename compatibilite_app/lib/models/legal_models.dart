class LegalPage {
  final String id;
  final String slug;
  final String title;
  final String content;
  final bool isActive;
  final int displayOrder;

  LegalPage({
    required this.id,
    required this.slug,
    required this.title,
    required this.content,
    required this.isActive,
    required this.displayOrder,
  });

  factory LegalPage.fromJson(Map<String, dynamic> json) {
    return LegalPage(
      id: json['id'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      isActive: json['is_active'] as bool? ?? false,
      displayOrder: json['display_order'] as int? ?? 0,
    );
  }
}
