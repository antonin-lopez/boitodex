import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:boitodex/core/ml/embedding_engine.dart';
import 'package:boitodex/core/ml/cosine_similarity.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('EmbeddingEngine', () {
    late EmbeddingEngine engine;

    setUpAll(() async {
      engine = EmbeddingEngine();
      await engine.initialize();
    });

    tearDownAll(() {
      engine.dispose();
    });

    group('encodeText', () {
      test(
        'should generate a 384-dimension vector when input is valid',
        () async {
          const input = 'camionnette rouge';

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
          const input = 'camionnette rouge';

          final embedding = await engine.encodeText(input);
          final magnitude = embedding.fold<double>(
            0.0,
            (sum, val) => sum + (val * val),
          );

          expect(magnitude, closeTo(1.0, 0.01));
        },
      );

      test(
        'should return similarity above 0.5 when texts are semantically close',
        () async {
          final emb1 = await engine.encodeText('camionnette rouge');
          final emb2 = await engine.encodeText('pickup pourpre');

          final result = cosineSimilarity(emb1, emb2);

          expect(result, greaterThan(0.5));
        },
      );

      test(
        'should return similarity below 0.5 when texts are semantically unrelated',
        () async {
          final emb1 = await engine.encodeText('camionnette rouge');
          final emb2 = await engine.encodeText('recette de pizza');

          final result = cosineSimilarity(emb1, emb2);

          expect(result, lessThan(0.5));
        },
      );

      test('should return 1.0 when comparing identical embeddings', () async {
        final emb = await engine.encodeText('camionnette rouge');

        final result = cosineSimilarity(emb, emb);

        expect(result, closeTo(1.0, 0.001));
      });
    });
  });
}
