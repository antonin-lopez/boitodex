import 'dart:math' as math;
import 'dart:typed_data';
import 'package:dart_sentencepiece_tokenizer/dart_sentencepiece_tokenizer.dart';
import 'package:flutter/services.dart';
import 'package:onnxruntime_v2/onnxruntime_v2.dart';

/// On-device machine learning engine that generates text embeddings using an ONNX model
/// and a SentencePiece tokenizer.
class EmbeddingEngine {
  OrtSession? _session;
  SentencePieceTokenizer? _tokenizer;
  bool _isInitialized = false;

  // Model input/output dimensions
  static const int vectorDimension = 384; // Sentence-MiniLM vector size
  static const int maxSeqLength = 128; // Maximum token sequence length

  // SentencePiece special token IDs
  static const int bosId = 0; // Beginning of Sentence <s>
  static const int padId = 1; // Padding token <pad>
  static const int eosId = 2; // End of Sentence </s>

  // SentencePiece uses the metaspace symbol ' ' (\u2581) to denote whitespace
  static const String spaceSymbol = '\u2581';

  /// Indicates whether the ONNX session and tokenizer are ready to use.
  bool get isInitialized => _isInitialized;

  /// Loads the ONNX model and tokenizer JSON file from Flutter assets and initializes native ONNX environment.
  Future<void> initialize({
    String modelAssetPath =
        'assets/models/paraphrase_multilingual_minilm_l12_v2_qint8_arm64.onnx',
    String tokenizerAssetPath = 'assets/tokenizer/tokenizer.json',
  }) async {
    if (_isInitialized) return;

    // Initialize the ONNX Runtime C++ environment
    OrtEnv.instance.init();

    // Load model binary buffer from Flutter assets
    final modelBytes = await rootBundle.load(modelAssetPath);
    _session = OrtSession.fromBuffer(
      modelBytes.buffer.asUint8List(),
      OrtSessionOptions()..appendDefaultProviders(),
    );

    // Load SentencePiece tokenizer configuration
    final tokenizerJson = await rootBundle.loadString(tokenizerAssetPath);
    _tokenizer = TokenizerJsonLoader.fromJsonString(tokenizerJson);

    _isInitialized = true;
  }

  /// Encodes input string into a 384-dimensional L2-normalized float vector.
  Future<List<double>> encodeText(String text) async {
    final session = _session;
    final tokenizer = _tokenizer;
    if (!_isInitialized || session == null || tokenizer == null) {
      throw StateError('EmbeddingEngine must be initialized before use.');
    }

    final trimmed = text.trim();
    // Return a zero vector if input text is empty
    if (trimmed.isEmpty) return List<double>.filled(vectorDimension, 0.0);

    // 1. Tokenize, format, and pad input text
    final (ids, mask, types) = _tokenizeAndPad(tokenizer, trimmed);

    final List<OrtValueTensor> tensors = [];
    OrtRunOptions? runOptions;
    List<OrtValue?>? outputs;

    try {
      // 2. Safely instantiate ONNX Tensors inside the try block for guaranteed memory cleanup
      final shape = [1, maxSeqLength];
      tensors.addAll([
        OrtValueTensor.createTensorWithDataList(Int64List.fromList(ids), shape),
        OrtValueTensor.createTensorWithDataList(
          Int64List.fromList(mask),
          shape,
        ),
        OrtValueTensor.createTensorWithDataList(
          Int64List.fromList(types),
          shape,
        ),
      ]);

      final inputs = {
        'input_ids': tensors[0],
        'attention_mask': tensors[1],
        'token_type_ids': tensors[2],
      };

      // 3. Run model inference
      runOptions = OrtRunOptions();
      outputs = session.run(runOptions, inputs);

      final rawOutput = outputs[0]?.value;
      if (rawOutput == null || rawOutput is! List) {
        throw StateError('Invalid output from ONNX model.');
      }

      // 4. Apply Mean Pooling to condense token embeddings into a single sentence vector
      final pooled = _poolOutput(rawOutput, mask);

      // 5. Apply L2 normalization
      return _normalize(pooled);
    } finally {
      // 6. Always release C++ native ONNX pointers to prevent memory leaks
      for (final t in tensors) {
        t.release();
      }
      runOptions?.release();
      if (outputs != null) {
        for (final e in outputs) {
          e?.release();
        }
      }
    }
  }

  /// Formats text for SentencePiece, encodes token IDs, adds BOS/EOS tokens,
  /// pads sequence to [maxSeqLength], and returns required tensor input lists.
  (List<int>, List<int>, List<int>) _tokenizeAndPad(
    SentencePieceTokenizer tokenizer,
    String text,
  ) {
    // SentencePiece requires word prefixes to use the metaspace symbol (\u2581)
    final formatted = text.startsWith(spaceSymbol)
        ? text
        : '$spaceSymbol${text.replaceAll(' ', spaceSymbol)}';

    var ids = tokenizer.encode(formatted).ids.toList();

    // Ensure Beginning-of-Sentence <s> token is present at index 0
    if (ids.isEmpty || ids.first != bosId) ids.insert(0, bosId);
    // Ensure End-of-Sentence </s> token is present at the end
    if (ids.last != eosId) ids.add(eosId);

    // Truncate sequence if it exceeds the max sequence length
    if (ids.length >= maxSeqLength) {
      ids = ids.sublist(0, maxSeqLength)..[maxSeqLength - 1] = eosId;
    }

    // Calculate padding length
    final padLen = maxSeqLength - ids.length;
    final paddedIds = [...ids, ...List<int>.filled(padLen, padId)];

    // Attention mask: 1 for actual tokens, 0 for padding tokens
    final mask = [
      ...List<int>.filled(ids.length, 1),
      ...List<int>.filled(padLen, 0),
    ];

    // Token type IDs: filled with 0s (single sentence classification)
    final types = List<int>.filled(maxSeqLength, 0);

    return (paddedIds, mask, types);
  }

  /// Performs Mean Pooling: averages token embedding vectors while ignoring padding tokens.
  List<double> _poolOutput(List rawOutput, List<int> mask) {
    // Fallback if model output is already pooled
    if (rawOutput.isNotEmpty && rawOutput[0] is double) {
      return rawOutput.cast<double>();
    }

    final tokenEmbeddings = rawOutput[0] as List;
    final pooled = Float32List(vectorDimension);
    var count = 0;

    // Sum embeddings for valid non-padded tokens
    for (var i = 0; i < maxSeqLength; i++) {
      if (mask[i] == 1) {
        count++;
        final vec = (tokenEmbeddings[i] as List).cast<double>();
        for (var d = 0; d < vectorDimension; d++) {
          pooled[d] += vec[d];
        }
      }
    }

    // Average sums across token count
    if (count > 0) {
      for (var d = 0; d < vectorDimension; d++) {
        pooled[d] /= count;
      }
    }
    return pooled.toList();
  }

  /// Normalizes the vector to unit length (Euclidean L2 norm = 1.0).
  List<double> _normalize(List<double> vector) {
    final sumOfSquares = vector.fold<double>(
      0.0,
      (sum, val) => sum + (val * val),
    );
    final norm = math.sqrt(sumOfSquares);
    if (norm == 0.0) return vector;
    return vector.map((val) => val / norm).toList();
  }

  /// Releases all native resources and session references.
  void dispose() {
    _session?.release();
    _session = null;
    _tokenizer = null;
    if (_isInitialized) {
      OrtEnv.instance.release();
    }
    _isInitialized = false;
  }
}
