import 'dart:typed_data';

import 'package:boitodex/core/database/daos/items_dao.dart';
import 'package:boitodex/core/ml/cosine_similarity.dart';
import 'package:boitodex/core/ml/embedding_engine.dart';
import 'package:boitodex/features/item/domain/models/item.dart';
import 'package:boitodex/features/item/domain/repositories/item_repository.dart';
import 'package:boitodex/features/catalog_search/domain/constants/catalog_search_constants.dart';
import 'package:boitodex/features/catalog_search/domain/models/search_result.dart';
import 'package:boitodex/features/catalog_search/domain/repositories/catalog_search_repository.dart';

class CatalogSearchRepositoryImpl implements CatalogSearchRepository {
  final ItemsDao _itemsDao;
  final ItemRepository _itemRepository;
  final EmbeddingEngine _embeddingEngine;

  final Map<String, Float32List> _queryEmbeddingCache = {};

  CatalogSearchRepositoryImpl(
    this._itemsDao,
    this._itemRepository,
    this._embeddingEngine,
  );

  @override
  Future<List<SearchResult>> searchItems({
    required String query,
    required String collectionId,
  }) async {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) return [];

    final hasSearchableContent = cleanQuery
        .replaceAll(RegExp(r'[^\w\s]', unicode: true), '')
        .trim()
        .isNotEmpty;
    if (!hasSearchableContent) return [];

    final queryTerms = cleanQuery
        .split(RegExp(r'\s+'))
        .where((term) => term.isNotEmpty)
        .map(_normalizeForMatching)
        .toList();

    final ftsTask = _itemsDao.searchItemIdsByFts(cleanQuery, collectionId);
    final domainItemsTask = _itemRepository
        .watchItemsByCollection(collectionId)
        .first;
    final queryVectorTask = _getOrComputeQueryEmbedding(cleanQuery);

    final results = await Future.wait([
      ftsTask,
      domainItemsTask,
      queryVectorTask,
    ]);

    final ftsItemIds = (results[0] as List<String>).toSet();
    final domainItemsList = results[1] as List<Item>;
    final queryFloat32 = results[2] as Float32List;

    final resultsMap = <String, SearchResult>{};

    for (final item in domainItemsList) {
      final double? ftsScore = ftsItemIds.contains(item.id)
          ? _matchedTermRatio(item, queryTerms)
          : null;

      double? semanticScore;
      final itemEmbedding = item.embedding;
      if (itemEmbedding != null) {
        semanticScore = cosineSimilarity(queryFloat32, itemEmbedding);
      }

      final semanticIsBetter =
          semanticScore != null &&
          semanticScore >= CatalogSearchConstants.semanticSearchThreshold &&
          (ftsScore == null || semanticScore > ftsScore);

      if (semanticIsBetter) {
        resultsMap[item.id] = SearchResult(
          item: item,
          score: semanticScore,
          isSemanticMatch: true,
        );
      } else if (ftsScore != null) {
        resultsMap[item.id] = SearchResult(
          item: item,
          score: ftsScore,
          isSemanticMatch: false,
        );
      }
      // Sinon : ni FTS ni seuil sémantique atteint -> voiture exclue.
    }

    final sortedResults = resultsMap.values.toList()
      ..sort((a, b) => b.score.compareTo(a.score));

    return sortedResults;
  }

  double _matchedTermRatio(Item item, List<String> queryTerms) {
    if (queryTerms.isEmpty) return 0.0;

    final notesWords = (item.notes ?? '')
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .map(_normalizeForMatching)
        .toList();

    final keywordWords = item.keywords
        .expand((k) => k.label.toLowerCase().split(RegExp(r'\s+')))
        .map(_normalizeForMatching)
        .toList();

    var matchedCount = 0;
    for (final term in queryTerms) {
      final matches =
          notesWords.any((w) => w.startsWith(term)) ||
          keywordWords.any((w) => w.startsWith(term));
      if (matches) matchedCount++;
    }

    return matchedCount / queryTerms.length;
  }

  String _normalizeForMatching(String input) {
    const withDiacritics =
        'àáâãäåòóôõöøèéêëçðìíîïùúûüñšÿýžÀÁÂÃÄÅÒÓÔÕÖØÈÉÊËÇÐÌÍÎÏÙÚÛÜÑŠŸÝŽ';
    const withoutDiacritics =
        'aaaaaaooooooeeeecdiiiiuuuunsyyzAAAAAAOOOOOOEEEECDIIIIUUUUNSYYZ';

    final buffer = StringBuffer();
    for (final rune in input.runes) {
      final char = String.fromCharCode(rune);
      final index = withDiacritics.indexOf(char);
      buffer.write(index == -1 ? char : withoutDiacritics[index]);
    }
    return buffer.toString();
  }

  Future<Float32List> _getOrComputeQueryEmbedding(String query) async {
    final cached = _queryEmbeddingCache[query];
    if (cached != null) return cached;

    final queryVector = await _embeddingEngine.encodeText(query);
    final float32Vector = Float32List.fromList(queryVector);

    if (_queryEmbeddingCache.length >= CatalogSearchConstants.maxCacheSize) {
      _queryEmbeddingCache.remove(_queryEmbeddingCache.keys.first);
    }
    _queryEmbeddingCache[query] = float32Vector;

    return float32Vector;
  }
}
