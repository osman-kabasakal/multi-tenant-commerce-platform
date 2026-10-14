class SliderItem {
  final Object? id;
  final String imageUrl;
  final String? title;
  final String? subtitle;
  final String? actionUrl;
  final bool showDescription;
  final String? url;
  const SliderItem({
    required this.imageUrl,
    this.showDescription = true,
    this.title,
    this.subtitle,
    this.actionUrl,
    this.id,
    this.url,
  });
}
