import 'dart:math';

abstract class PairingCodeGenerator {
  static const _allowedChars = '23456789ABCDEFGHJKMNPQRSTUVWXYZ';
  static const _codeLength = 8;

  static String generate() {
    final random = Random.secure();
    final buffer = StringBuffer();

    for (var i = 0; i < _codeLength; i++) {
      final randomIndex = random.nextInt(_allowedChars.length);
      buffer.write(_allowedChars[randomIndex]);
    }

    return buffer.toString();
  }
}
