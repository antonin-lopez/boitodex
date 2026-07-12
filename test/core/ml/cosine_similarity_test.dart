import 'package:flutter_test/flutter_test.dart';
import 'package:boitodex/core/ml/cosine_similarity.dart';

void main() {
  group('cosineSimilarity', () {
    test('should return 1.0 when vectors are identical', () {
      final v1 = [1.0, 0.0, 0.0];
      final v2 = [1.0, 0.0, 0.0];

      final result = cosineSimilarity(v1, v2);

      expect(result, closeTo(1.0, 0.0001));
    });

    test('should return 0.0 when vectors are orthogonal', () {
      final v1 = [1.0, 0.0, 0.0];
      final v2 = [0.0, 1.0, 0.0];

      final result = cosineSimilarity(v1, v2);

      expect(result, closeTo(0.0, 0.0001));
    });

    test('should return -1.0 when vectors are opposite', () {
      final v1 = [1.0, 0.0];
      final v2 = [-1.0, 0.0];

      final result = cosineSimilarity(v1, v2);

      expect(result, closeTo(-1.0, 0.0001));
    });

    test(
      'should return 1.0 for collinear vectors with different magnitudes',
      () {
        final v1 = [3.0, 0.0];
        final v2 = [5.0, 0.0];

        final result = cosineSimilarity(v1, v2);

        expect(result, closeTo(1.0, 0.0001));
      },
    );

    test('should return 0.0 when at least one vector is a zero vector', () {
      final v1 = [0.0, 0.0, 0.0];
      final v2 = [1.0, 2.0, 3.0];

      final result = cosineSimilarity(v1, v2);

      expect(result, equals(0.0));
    });

    test('should throw ArgumentError when vector dimensions do not match', () {
      final v1 = [1.0, 0.0];
      final v2 = [1.0, 0.0, 0.0];

      expect(() => cosineSimilarity(v1, v2), throwsArgumentError);
    });
  });
}
