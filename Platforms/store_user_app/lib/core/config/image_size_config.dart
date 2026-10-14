import 'package:path/path.dart' as path;

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
    var fileName = path.basenameWithoutExtension(originalUrl);
    var splitFileName = fileName.split('_');

    if (splitFileName.length == 3) {
      splitFileName[2] = width.toInt().toString();
    } else {
      splitFileName.add(width.toInt().toString());
    }
    var mergedFileName = splitFileName.join("_");

    var uri = Uri.parse(originalUrl);
    uri = uri.replace(
      queryParameters: {
        'width': width.toInt().toString(),
        'height': height.toInt().toString(),
        'useHighRes': useHighRes.toString(),
      },
    );
    // return originalUrl.replaceAll(fileName, mergedFileName);
    return uri.toString();
  }
}
