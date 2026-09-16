import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

abstract final class ImageCompressor {
  /// Compresses [file] and returns the resulting [XFile] in the temporary cache.
  static Future<XFile?> compress(
    XFile file, {
    int maxWidth = 1600,
    int maxHeight = 1600,
    int quality = 80,
  }) async {
    final tempDir = await getTemporaryDirectory();
    final targetPath = p.join(
      tempDir.path,
      '${DateTime.now().microsecondsSinceEpoch}.jpg',
    );

    return FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      minWidth: maxWidth,
      minHeight: maxHeight,
      quality: quality,
      format: CompressFormat.jpeg,
    );
  }
}