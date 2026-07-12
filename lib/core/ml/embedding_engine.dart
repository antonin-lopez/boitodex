import 'dart:math' as math;
import 'dart:typed_data';
import 'package:dart_sentencepiece_tokenizer/dart_sentencepiece_tokenizer.dart';
import 'package:flutter/services.dart';
import 'package:onnxruntime_v2/onnxruntime_v2.dart';

class EmbeddingEngine {
  OrtSession? _session;
  SentencePieceTokenizer? _tokenizer;
  bool _isInitialized = false;

  static const int vectorDimension = 384;
  static const int maxSeqLength = 128;

  static const int bosId = 0; // <s>
  static const int padId = 1; // <pad>
  static const int eosId = 2; // </s>
  static const String spaceSymbol = '\u2581';

  bool get isInitialized => _isInitialized;

  Future<void> initialize({
    String modelAssetPath =
        'assets/models/paraphrase_multilingual_minilm_l12_v2_qint8_arm64.onnx',
    String tokenizerAssetPath = 'assets/tokenizer/tokenizer.json',
  }) async {
    if (_isInitialized) return;

    OrtEnv.instance.init();
    final modelBytes = await rootBundle.load(modelAssetPath);
    _session = OrtSession.fromBuffer(
      modelBytes.buffer.asUint8List(),
      OrtSessionOptions()..appendDefaultProviders(),
    );

    final tokenizerJson = await rootBundle.loadString(tokenizerAssetPath);
    _tokenizer = await TokenizerJsonLoader.fromJsonString(tokenizerJson);

    _isInitialized = true;
  }

  Future<List<double>> encodeText(String text) async {
    final session = _session;
    final tokenizer = _tokenizer;
    if (!_isInitialized || session == null || tokenizer == null) {
      throw StateError(
        'EmbeddingEngine doit être initialisé avant utilisation.',
      );
    }

    final trimmed = text.trim();
    if (trimmed.isEmpty) return List<double>.filled(vectorDimension, 0.0);

    // 1. Tokenisation & Padding
    final (ids, mask, types) = _tokenizeAndPad(tokenizer, trimmed);

    // 2. Préparation des Tensors ONNX
    final shape = [1, maxSeqLength];
    final tensors = [
      OrtValueTensor.createTensorWithDataList(Int64List.fromList(ids), shape),
      OrtValueTensor.createTensorWithDataList(Int64List.fromList(mask), shape),
      OrtValueTensor.createTensorWithDataList(Int64List.fromList(types), shape),
    ];

    final inputs = {
      'input_ids': tensors[0],
      'attention_mask': tensors[1],
      'token_type_ids': tensors[2],
    };

    // 3. Inférence & Pooling
    final runOptions = OrtRunOptions();
    final outputs = session.run(runOptions, inputs);
    final pooled = _poolOutput(outputs[0]?.value as List, mask);

    // 4. Nettoyage mémoire C++
    for (final t in tensors) {
      t.release();
    }
    runOptions.release();
    outputs.forEach((e) => e?.release());

    // 5. Normalisation L2
    return _normalize(pooled);
  }

  /// Prépare la phrase et génère le triplet (input_ids, attention_mask, token_type_ids)
  (List<int>, List<int>, List<int>) _tokenizeAndPad(
    SentencePieceTokenizer tokenizer,
    String text,
  ) {
    final formatted = text.startsWith(spaceSymbol)
        ? text
        : '$spaceSymbol${text.replaceAll(' ', spaceSymbol)}';

    var ids = tokenizer.encode(formatted).ids.toList();

    if (ids.isEmpty || ids.first != bosId) ids.insert(0, bosId);
    if (ids.last != eosId) ids.add(eosId);

    if (ids.length >= maxSeqLength) {
      ids = ids.sublist(0, maxSeqLength)..[maxSeqLength - 1] = eosId;
    }

    final padLen = maxSeqLength - ids.length;
    final paddedIds = [...ids, ...List<int>.filled(padLen, padId)];
    final mask = [
      ...List<int>.filled(ids.length, 1),
      ...List<int>.filled(padLen, 0),
    ];
    final types = List<int>.filled(maxSeqLength, 0);

    return (paddedIds, mask, types);
  }

  /// Applique le Mean Pooling sur les embeddings
  List<double> _poolOutput(List rawOutput, List<int> mask) {
    if (rawOutput.isNotEmpty && rawOutput[0] is double) {
      return (rawOutput as List).cast<double>();
    }

    final tokenEmbeddings = rawOutput[0] as List;
    final pooled = Float32List(vectorDimension);
    var count = 0;

    for (var i = 0; i < maxSeqLength; i++) {
      if (mask[i] == 1) {
        count++;
        final vec = (tokenEmbeddings[i] as List).cast<double>();
        for (var d = 0; d < vectorDimension; d++) {
          pooled[d] += vec[d];
        }
      }
    }

    if (count > 0) {
      for (var d = 0; d < vectorDimension; d++) {
        pooled[d] /= count;
      }
    }
    return pooled.toList();
  }

  /// Normalisation L2 du vecteur
  List<double> _normalize(List<double> vector) {
    final sumOfSquares = vector.fold<double>(
      0.0,
      (sum, val) => sum + (val * val),
    );
    final norm = math.sqrt(sumOfSquares);
    if (norm == 0.0) return vector;
    return vector.map((val) => val / norm).toList();
  }

  void dispose() {
    _session?.release();
    _session = null;
    OrtEnv.instance.release();
    _isInitialized = false;
  }
}
