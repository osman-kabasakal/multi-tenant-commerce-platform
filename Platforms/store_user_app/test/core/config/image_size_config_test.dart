import 'package:flutter_test/flutter_test.dart';
import 'package:store_user_app/core/config/image_size_config.dart';

void main() {
  test('unbounded drawer width never becomes an image resize parameter', () {
    final uri = Uri.parse(
      const ImageSizeConfig(
        width: double.infinity,
        height: 60,
      ).getOptimizedUrl('https://shop.example.test/logo.png?version=2'),
    );
    expect(uri.queryParameters, {
      'version': '2',
      'height': '60',
      'useHighRes': 'false',
    });
  });
  test('finite image dimensions preserve existing image query parameters', () {
    final uri = Uri.parse(
      const ImageSizeConfig(
        width: 120,
        height: 60,
      ).getOptimizedUrl('https://shop.example.test/logo.png?version=2'),
    );
    expect(uri.queryParameters, {
      'version': '2',
      'width': '120',
      'height': '60',
      'useHighRes': 'false',
    });
  });
  test('invalid resize dimensions are omitted', () {
    final uri = Uri.parse(
      const ImageSizeConfig(
        width: double.nan,
        height: 0,
      ).getOptimizedUrl('https://shop.example.test/logo.png'),
    );
    expect(uri.queryParameters, {'useHighRes': 'false'});
  });
}
