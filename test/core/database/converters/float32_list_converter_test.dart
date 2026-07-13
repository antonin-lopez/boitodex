import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:boitodex/core/database/converters/float32_list_converter.dart';

void main() {
  group('Float32ListConverter', () {
    late Float32ListConverter converter;

    setUp(() {
      converter = const Float32ListConverter();
    });

    group('toSql', () {
      test('should convert Float32List into Uint8List bytes correctly', () {
        final input = Float32List.fromList([1.0, -0.5, 0.25]);

        final result = converter.toSql(input);

        expect(result, isA<Uint8List>());
        expect(result.length, equals(12)); // 3 float32 = 12 octets
      });
    });

    group('fromSql', () {
      test('should convert aligned Uint8List bytes back to Float32List', () {
        final original = Float32List.fromList([1.0, 2.5, -3.14]);
        final bytes = converter.toSql(original);

        final result = converter.fromSql(bytes);

        expect(result, isA<Float32List>());
        expect(result.length, equals(3));
        expect(result[0], closeTo(1.0, 0.0001));
        expect(result[1], closeTo(2.5, 0.0001));
        expect(result[2], closeTo(-3.14, 0.0001));
      });

      test(
        'should handle unaligned Uint8List bytes without throwing ArgumentError',
        () {
          final originalBytes = Uint8List.fromList([
            0, // 1 octet de décalage pour casser l'alignement multiple de 4
            0, 0, 128, 63, // float32 = 1.0 en Little Endian
            0, 0, 32, 64, // float32 = 2.5 en Little Endian
          ]);

          final unalignedBytes = Uint8List.sublistView(originalBytes, 1);

          expect(unalignedBytes.offsetInBytes % 4, isNot(equals(0)));

          final result = converter.fromSql(unalignedBytes);

          expect(result.length, equals(2));
          expect(result[0], closeTo(1.0, 0.0001));
          expect(result[1], closeTo(2.5, 0.0001));
        },
      );
    });
  });
}
