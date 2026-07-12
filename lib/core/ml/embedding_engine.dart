import 'dart:math' as math;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'text_tokenizer.dart';

class EmbeddingEngine {
  Interpreter? _interpreter;
  final TextTokenizer _tokenizer = TextTokenizer();
  bool _isInitialized = false;

  static const int vectorDimension = 384;
  static const int maxSeqLength = 128;

  bool get isInitialized => _isInitialized;

  Future<void> initialize({
    String modelPath = 'assets/models/paraphrase_multilingual_minilm.tflite',
    String vocabPath = 'assets/tokenizer/vocab.txt',
  }) async {
    if (_isInitialized) return;

    final options = InterpreterOptions()..threads = 2;
    _interpreter = await Interpreter.fromAsset(modelPath, options: options);
    await _tokenizer.initialize(vocabPath: vocabPath);

    _isInitialized = true;
  }

  Future<List<double>> encodeText(String text) async {
    final interpreter = _interpreter;
    if (!_isInitialized || interpreter == null) {
      throw StateError('EmbeddingEngine must be initialized before use.');
    }

    if (text.trim().isEmpty) {
      return List<double>.filled(vectorDimension, 0.0);
    }

    final tokenized = _tokenizer.tokenize(text, maxSeqLength: maxSeqLength);

    // 🎯 Mapping dynamique des entrées selon la métadonnée du modèle TFLite
    final inputTensors = interpreter.getInputTensors();
    final List<Object> inputs = [];
    final tokenTypeIds = List<int>.filled(maxSeqLength, 0);

    for (final tensor in inputTensors) {
      final name = tensor.name.toLowerCase();
      if (name.contains('mask')) {
        inputs.add([tokenized.attentionMask]);
      } else if (name.contains('type') || name.contains('segment')) {
        inputs.add([tokenTypeIds]);
      } else {
        inputs.add([tokenized.inputIds]);
      }
    }

    // Inspection de la forme du tenseur de sortie
    final outputShape = interpreter.getOutputTensor(0).shape;

    // CAS A : Le modèle inclut déjà le Mean Pooling (Sortie : [1, 384])
    if (outputShape.length == 2 && outputShape[1] == vectorDimension) {
      final output = List.filled(
        1 * vectorDimension,
        0.0,
      ).reshape([1, vectorDimension]);

      interpreter.runForMultipleInputs(inputs, {0: output});

      final rawVector = (output as List)[0].cast<double>();
      return _normalize(rawVector);
    }

    // CAS B : Le modèle renvoie les embeddings de tous les tokens (Sortie : [1, 128, 384])
    final rawOutput = List.filled(
      1 * maxSeqLength * vectorDimension,
      0.0,
    ).reshape([1, maxSeqLength, vectorDimension]);

    interpreter.runForMultipleInputs(inputs, {0: rawOutput});

    // Mean Pooling : moyenne des vecteurs de tokens valides (hors padding)
    final tokenEmbeddings = (rawOutput as List)[0] as List;
    final pooled = List<double>.filled(vectorDimension, 0.0);

    var validTokenCount = 0;
    for (var i = 0; i < maxSeqLength; i++) {
      if (tokenized.attentionMask[i] == 1) {
        validTokenCount++;
        final tokenVec = (tokenEmbeddings[i] as List).cast<double>();
        for (var d = 0; d < vectorDimension; d++) {
          pooled[d] += tokenVec[d];
        }
      }
    }

    if (validTokenCount > 0) {
      for (var d = 0; d < vectorDimension; d++) {
        pooled[d] /= validTokenCount;
      }
    }

    return _normalize(pooled);
  }

  double computeSimilarity(List<double> v1, List<double> v2) {
    if (v1.length != vectorDimension || v2.length != vectorDimension) {
      throw ArgumentError(
        'Vectors must have dimension $vectorDimension (v1: ${v1.length}, v2: ${v2.length})',
      );
    }

    double dotProduct = 0.0;
    for (var i = 0; i < vectorDimension; i++) {
      dotProduct += v1[i] * v2[i];
    }

    return dotProduct;
  }

  List<double> _normalize(List<double> vector) {
    double sumOfSquares = 0.0;
    for (final val in vector) {
      sumOfSquares += val * val;
    }
    final norm = math.sqrt(sumOfSquares);

    if (norm == 0.0) return vector;
    return vector.map((val) => val / norm).toList();
  }

  Future<void> dispose() async {
    _interpreter?.close();
    _interpreter = null;
    _isInitialized = false;
  }
}
