import 'package:flutter/services.dart' show rootBundle;

/// Tokenizer de texte compatible avec XLM-RoBERTa / SentencePiece
class TextTokenizer {
  final Map<String, int> _vocab = {};
  bool _isInitialized = false;

  static const String bosToken = '<s>';
  static const String padToken = '<pad>';
  static const String eosToken = '</s>';
  static const String unkToken = '<unk>';

  static const String spaceSymbol = '\u2581';

  int _bosId = 0;
  int _padId = 1;
  int _eosId = 2;
  int _unkId = 3;

  static final RegExp _whitespaceRegExp = RegExp(r'\s+');
  static final RegExp _punctuationRegExp = RegExp(
    r'([\p{P}\p{S}])',
    unicode: true,
  );

  bool get isInitialized => _isInitialized;

  Future<void> initialize({
    String vocabPath = 'assets/tokenizer/vocab.txt',
  }) async {
    if (_isInitialized) return;

    final content = await rootBundle.loadString(vocabPath);
    final lines = content.split('\n');

    for (var i = 0; i < lines.length; i++) {
      // ⚠️ Ne PAS utiliser .trim() ici car cela détruit les espaces SentencePiece
      final token = lines[i].replaceAll('\r', '');
      if (token.isNotEmpty) {
        _vocab[token] = i;
      }
    }

    _bosId = _vocab[bosToken] ?? 0;
    _padId = _vocab[padToken] ?? 1;
    _eosId = _vocab[eosToken] ?? 2;
    _unkId = _vocab[unkToken] ?? 3;

    _isInitialized = true;
  }

  ({List<int> inputIds, List<int> attentionMask}) tokenize(
    String text, {
    int maxSeqLength = 128,
  }) {
    if (!_isInitialized) {
      throw StateError('TextTokenizer must be initialized before use.');
    }

    // Garder la casse originale (XLM-RoBERTa est cased)
    final normalizedText = text.replaceAllMapped(
      _punctuationRegExp,
      (match) => ' ${match[1]} ',
    );

    final words = normalizedText.trim().split(_whitespaceRegExp);

    final tokenIds = <int>[_bosId];
    final maxWordTokens = maxSeqLength - 2;

    for (final word in words) {
      if (word.isEmpty) continue;

      final sentencePieceWord = '$spaceSymbol$word';
      final subtokens = _sentencePieceTokenize(sentencePieceWord);

      for (final subtoken in subtokens) {
        if (tokenIds.length >= maxWordTokens + 1) break;
        tokenIds.add(_vocab[subtoken] ?? _unkId);
      }

      if (tokenIds.length >= maxWordTokens + 1) break;
    }

    tokenIds.add(_eosId);

    final padLength = maxSeqLength - tokenIds.length;

    final inputIds = [...tokenIds, ...List<int>.filled(padLength, _padId)];

    final attentionMask = [
      ...List<int>.filled(tokenIds.length, 1),
      ...List<int>.filled(padLength, 0),
    ];

    return (inputIds: inputIds, attentionMask: attentionMask);
  }

  List<String> _sentencePieceTokenize(String wordWithSpace) {
    if (_vocab.containsKey(wordWithSpace)) return [wordWithSpace];

    final subtokens = <String>[];
    var start = 0;

    while (start < wordWithSpace.length) {
      var end = wordWithSpace.length;
      String? curSubword;

      while (start < end) {
        final substring = wordWithSpace.substring(start, end);
        if (_vocab.containsKey(substring)) {
          curSubword = substring;
          break;
        }
        end--;
      }

      if (curSubword == null) {
        subtokens.add(unkToken);
        start++;
      } else {
        subtokens.add(curSubword);
        start = end;
      }
    }

    return subtokens;
  }
}
