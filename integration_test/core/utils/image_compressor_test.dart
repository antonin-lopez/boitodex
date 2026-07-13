import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:boitodex/core/utils/image_compressor.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('ImageCompressor', () {
    late File rawImageFile;

    setUpAll(() async {
      final tempDir = await getTemporaryDirectory();
      final filePath = p.join(tempDir.path, 'test_raw_image.png');

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, 2000, 2000));
      final paint = Paint()..color = Colors.red;
      canvas.drawRect(const Rect.fromLTWH(0, 0, 2000, 2000), paint);

      final picture = recorder.endRecording();
      final img = await picture.toImage(2000, 2000);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

      rawImageFile = File(filePath);
      await rawImageFile.writeAsBytes(byteData!.buffer.asUint8List());
    });

    tearDownAll(() async {
      if (await rawImageFile.exists()) {
        await rawImageFile.delete();
      }
    });

    group('compressImage', () {
      test('should compress image and return a valid non-null file', () async {
        final compressedFile = await ImageCompressor.compressImage(
          rawImageFile,
        );

        expect(compressedFile, isNotNull);
        expect(await compressedFile!.exists(), isTrue);
      });

      test('should save compressed file as JPEG format', () async {
        final compressedFile = await ImageCompressor.compressImage(
          rawImageFile,
        );

        expect(compressedFile!.path.endsWith('.jpg'), isTrue);
      });

      test(
        'should significantly reduce file size compared to raw uncompressed image',
        () async {
          final originalSize = await rawImageFile.length();
          final compressedFile = await ImageCompressor.compressImage(
            rawImageFile,
          );
          final compressedSize = await compressedFile!.length();

          expect(compressedSize, lessThan(originalSize));
        },
      );
    });
  });
}
