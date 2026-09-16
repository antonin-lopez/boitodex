import 'package:boitodex/features/item/domain/models/item.dart';

class SearchResult {
  final Item item;
  final double score;
  final bool isSemanticMatch;

  const SearchResult({
    required this.item,
    required this.score,
    required this.isSemanticMatch,
  });
}
