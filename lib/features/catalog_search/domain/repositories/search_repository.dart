import 'package:boitodex/features/catalog_search/domain/models/search_result.dart';

abstract class SearchRepository {
  Future<List<SearchResult>> searchCars({
    required String query,
    required String collectionId,
  });
}
