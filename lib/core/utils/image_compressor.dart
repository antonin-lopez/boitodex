import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

abstract class ImageCompressor {
  static Future<File?> compressImage(
    File file, {
    int maxWidth = 1600,
    int maxHeight = 1600,
    int quality = 80,
  }) async {
    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(p.join(documentsDir.path, 'car_images'));
      await imagesDir.create(recursive: true);

      final targetPath = p.join(
        imagesDir.path,
        '${DateTime.now().microsecondsSinceEpoch}.jpg',
      );

      final XFile? compressedXFile =
          await FlutterImageCompress.compressAndGetFile(
            file.absolute.path,
            targetPath,
            minWidth: maxWidth,
            minHeight: maxHeight,
            quality: quality,
            format: CompressFormat.jpeg,
          );

      if (compressedXFile == null) return null;
      return File(compressedXFile.path);
    } catch (e, st) {
      debugPrint('ImageCompressor failed: $e\n$st');
      return file;
    }
  }
}
