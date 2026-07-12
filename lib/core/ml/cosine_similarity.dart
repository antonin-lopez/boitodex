import 'dart:math' as math;

double cosineSimilarity(List<double> a, List<double> b) {
  if (a.length != b.length) {
    throw ArgumentError('Vectors must have the same dimension.');
  }

  double dotProduct = 0.0;
  double normA = 0.0;
  double normB = 0.0;

  for (var i = 0; i < a.length; i++) {
    final valA = a[i];
    final valB = b[i];

    dotProduct += valA * valB;
    normA += valA * valA;
    normB += valB * valB;
  }

  if (normA == 0.0 || normB == 0.0) {
    return 0.0;
  }

  return dotProduct / (math.sqrt(normA) * math.sqrt(normB));
}
