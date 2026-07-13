import 'package:flutter_test/flutter_test.dart';
import 'package:boitodex/core/utils/uuid_generator.dart';

void main() {
  group('UuidGenerator', () {
    group('generate', () {
      test('should return a valid UUID v4 format string', () {
        final result = UuidGenerator.generate();

        final uuidV4RegExp = RegExp(
          r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
        );

        expect(result, isA<String>());
        expect(result.length, equals(36));
        expect(uuidV4RegExp.hasMatch(result), isTrue);
      });

      test('should generate unique UUIDs on consecutive calls', () {
        final uuid1 = UuidGenerator.generate();
        final uuid2 = UuidGenerator.generate();

        expect(uuid1, isNot(equals(uuid2)));
      });
    });
  });
}
