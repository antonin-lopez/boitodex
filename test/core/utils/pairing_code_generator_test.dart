import 'package:flutter_test/flutter_test.dart';
import 'package:boitodex/core/utils/pairing_code_generator.dart';

void main() {
  group('PairingCodeGenerator', () {
    group('generate', () {
      test('should return a string of exactly 8 characters', () {
        final result = PairingCodeGenerator.generate();

        expect(result, isA<String>());
        expect(result.length, equals(8));
      });

      test(
        'should contain only allowed characters and exclude ambiguous ones (0, O, 1, I, L)',
        () {
          final allowedCharsRegExp = RegExp(
            r'^[23456789ABCDEFGHJKMNPQRSTUVWXYZ]{8}$',
          );

          for (var i = 0; i < 100; i++) {
            final code = PairingCodeGenerator.generate();
            expect(
              allowedCharsRegExp.hasMatch(code),
              isTrue,
              reason: 'Code $code contains forbidden or non-allowed characters',
            );
          }
        },
      );

      test('should generate unique codes on consecutive calls', () {
        final code1 = PairingCodeGenerator.generate();
        final code2 = PairingCodeGenerator.generate();

        expect(code1, isNot(equals(code2)));
      });
    });
  });
}
