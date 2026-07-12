import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:boitodex/core/ml/embedding_engine.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('EmbeddingEngine', () {
    late EmbeddingEngine engine;

    setUpAll(() async {
      engine = EmbeddingEngine();
      await engine.initialize();
    });

    tearDownAll(() async {
      await engine.dispose();
    });

    group('encodeText', () {
      test(
        'should generate a 384-dimension vector when input is valid',
        () async {
          const input = 'red truck';

          final result = await engine.encodeText(input);

          expect(result.length, equals(EmbeddingEngine.vectorDimension));
        },
      );

      test('should return a zero vector when input is empty', () async {
        const input = '';

        final result = await engine.encodeText(input);

        expect(result.length, equals(EmbeddingEngine.vectorDimension));
        expect(result.every((val) => val == 0.0), isTrue);
      });

      test(
        'should return an L2 normalized vector with magnitude close to 1.0',
        () async {
          const input = 'red truck';

          final embedding = await engine.encodeText(input);
          final magnitude = embedding.fold<double>(
            0.0,
            (sum, val) => sum + (val * val),
          );

          expect(magnitude, closeTo(1.0, 0.0001));
        },
      );
    });

    group('computeSimilarity', () {
      test(
        'should return score above 0.5 when texts are semantically close',
        () async {
          final emb1 = await engine.encodeText('red truck');
          final emb2 = await engine.encodeText('red pickup');

          final result = engine.computeSimilarity(emb1, emb2);

          expect(result, greaterThan(0.5));
        },
      );

      test(
        'should return score below 0.5 when texts are semantically unrelated',
        () async {
          final emb1 = await engine.encodeText('red truck');
          final emb2 = await engine.encodeText('pizza recipe');

          final result = engine.computeSimilarity(emb1, emb2);

          expect(result, lessThan(0.5));
        },
      );

      test('should return 1.0 when comparing identical embeddings', () async {
        final emb = await engine.encodeText('red truck');

        final result = engine.computeSimilarity(emb, emb);

        expect(result, closeTo(1.0, 0.0001));
      });

      test(
        'should throw ArgumentError when vector dimensions do not match',
        () {
          final v1 = List<double>.filled(EmbeddingEngine.vectorDimension, 0.0);
          final v2 = List<double>.filled(128, 0.0);

          expect(() => engine.computeSimilarity(v1, v2), throwsArgumentError);
        },
      );
    });
  });
}
