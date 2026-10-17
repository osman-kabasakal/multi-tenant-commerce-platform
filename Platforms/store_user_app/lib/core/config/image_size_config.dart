class ImageSizeConfig {
  final double width;
  final double height;
  final bool useHighRes;

  const ImageSizeConfig({
    required this.width,
    required this.height,
    this.useHighRes = false,
  });

  String getOptimizedUrl(String originalUrl) {
    final uri = Uri.parse(originalUrl);
    return uri
        .replace(
          queryParameters: {
            ...uri.queryParameters,
            if (width.isFinite && width > 0) 'width': width.toInt().toString(),
            if (height.isFinite && height > 0)
              'height': height.toInt().toString(),
            'useHighRes': useHighRes.toString(),
          },
        )
        .toString();
  }
}
