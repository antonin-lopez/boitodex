import 'dart:math' as math;

/// Calculates the Cosine Similarity between two numerical vectors of equal dimension.
/// Returns a score between -1.0 and 1.0 (where 1.0 indicates identical orientation).
double cosineSimilarity(List<double> a, List<double> b) {
  if (a.length != b.length) {
    throw ArgumentError('Vectors must have the same dimension.');
  }

  double dotProduct = 0.0;
  double normA = 0.0;
  double normB = 0.0;

  // Single pass to calculate dot product and Euclidean norm components
  for (var i = 0; i < a.length; i++) {
    final valA = a[i];
    final valB = b[i];

    dotProduct += valA * valB;
    normA += valA * valA;
    normB += valB * valB;
  }

  // Prevent division by zero if either vector is a zero vector
  if (normA == 0.0 || normB == 0.0) {
    return 0.0;
  }

  // Formula: (A · B) / (||A|| * ||B||)
  return dotProduct / (math.sqrt(normA) * math.sqrt(normB));
}
