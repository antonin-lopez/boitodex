import 'package:boitodex/features/car_entry_detail/domain/models/car.dart';

class SearchResult {
  final Car car;
  final double score;
  final bool isSemanticMatch;

  const SearchResult({
    required this.car,
    required this.score,
    required this.isSemanticMatch,
  });
}
