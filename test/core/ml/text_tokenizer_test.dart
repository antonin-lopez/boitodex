import 'package:flutter_test/flutter_test.dart';
import 'package:boitodex/core/ml/text_tokenizer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TextTokenizer', () {
    late TextTokenizer tokenizer;

    setUp(() async {
      tokenizer = TextTokenizer();
      await tokenizer.initialize();
    });

    group('tokenize', () {
      test('should throw StateError when tokenizing before initialization', () {
        final uninitializedTokenizer = TextTokenizer();

        expect(
          () => uninitializedTokenizer.tokenize('hello'),
          throwsStateError,
        );
      });

      test(
        'should return inputIds and attentionMask with exact maxSeqLength size',
        () {
          const text = 'camionnette rouge';
          const maxSeqLength = 128;

          final result = tokenizer.tokenize(text, maxSeqLength: maxSeqLength);

          expect(result.inputIds.length, equals(maxSeqLength));
          expect(result.attentionMask.length, equals(maxSeqLength));
        },
      );

      test(
        'should start sequence with BOS (<s>) and end active sequence with EOS (</s>)',
        () {
          const text = 'camionnette';
          const maxSeqLength = 16;

          final result = tokenizer.tokenize(text, maxSeqLength: maxSeqLength);

          // ID 0 correspond à <s> dans SentencePiece
          expect(result.inputIds.first, equals(0));

          final activeCount = result.attentionMask
              .where((mask) => mask == 1)
              .length;

          // ID 2 correspond à </s> dans SentencePiece
          expect(result.inputIds[activeCount - 1], equals(2));
        },
      );

      test(
        'should set attentionMask to 1 for real tokens and 0 for padding',
        () {
          const text = 'test';
          const maxSeqLength = 32;

          final result = tokenizer.tokenize(text, maxSeqLength: maxSeqLength);

          final onesCount = result.attentionMask
              .where((mask) => mask == 1)
              .length;
          final zerosCount = result.attentionMask
              .where((mask) => mask == 0)
              .length;

          expect(onesCount + zerosCount, equals(maxSeqLength));
          expect(zerosCount, greaterThan(0));
        },
      );

      test('should handle empty text without throwing', () {
        const text = '';
        const maxSeqLength = 16;

        final result = tokenizer.tokenize(text, maxSeqLength: maxSeqLength);

        expect(result.inputIds.length, equals(maxSeqLength));
        expect(result.attentionMask.length, equals(maxSeqLength));
      });
    });
  });
}
