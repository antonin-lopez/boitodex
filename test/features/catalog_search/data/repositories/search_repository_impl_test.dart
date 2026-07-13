import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:boitodex/core/database/app_database.dart';
import 'package:boitodex/core/ml/embedding_engine.dart';
import 'package:boitodex/features/car_entry_detail/data/repositories/car_repository_impl.dart';
import 'package:boitodex/features/catalog_search/data/repositories/search_repository_impl.dart';

class FakeEmbeddingEngine implements EmbeddingEngine {
  @override
  bool get isInitialized => true;

  @override
  Future<List<double>> encodeText(String text) async {
    if (text.isEmpty) return List.filled(384, 0.0);
    if (text.contains('camion') || text.contains('pickup')) {
      return List.filled(384, 0.8);
    }
    return List.filled(384, 0.1);
  }

  @override
  Future<void> initialize({
    String? modelAssetPath,
    String? tokenizerAssetPath,
  }) async {}

  @override
  void dispose() {}
}

void main() {
  group('SearchRepositoryImpl', () {
    late AppDatabase db;
    late CarRepositoryImpl carRepository;
    late SearchRepositoryImpl searchRepository;

    const testCollectionId = '9a8b7c6d-5432-1098-fe01-234567890abc';

    setUp(() async {
      db = AppDatabase(
        NativeDatabase.memory(
          setup: (rawDb) {
            rawDb.execute('PRAGMA foreign_keys = ON;');
          },
        ),
      );

      final fakeEngine = FakeEmbeddingEngine();
      carRepository = CarRepositoryImpl(db.carsDao, db.keywordsDao, fakeEngine);

      searchRepository = SearchRepositoryImpl(
        db.carsDao,
        carRepository,
        fakeEngine,
      );

      await db.collectionsDao.insertOrUpdateCollection(
        CollectionsTableCompanion.insert(
          id: testCollectionId,
          pairingCode: 'K7M2QX9P',
          createdAt: DateTime.now(),
        ),
      );
    });

    tearDown(() async {
      await db.close();
    });

    group('searchCars', () {
      test('should return empty list when query is empty or blank', () async {
        final results = await searchRepository.searchCars(
          query: '   ',
          collectionId: testCollectionId,
        );

        expect(results, isEmpty);
      });

      test('should return exact match via FTS5 with score 1.0', () async {
        await carRepository.saveCar(
          collectionId: testCollectionId,
          notes: 'Pinder ambulance vintage',
          keywordLabels: ['Ambulance', 'Rouge'],
          imagePaths: [],
        );

        final results = await searchRepository.searchCars(
          query: 'Ambulance',
          collectionId: testCollectionId,
        );

        expect(results.length, equals(1));
        expect(results.first.score, equals(1.0));
        expect(results.first.isSemanticMatch, isFalse);
      });

      test(
        'should fallback to semantic match when FTS miss but similarity > 0.5',
        () async {
          await carRepository.saveCar(
            collectionId: testCollectionId,
            notes: 'Grand pickup rouge',
            keywordLabels: ['Pickup'],
            imagePaths: [],
          );

          final results = await searchRepository.searchCars(
            query: 'camion',
            collectionId: testCollectionId,
          );

          expect(results.isNotEmpty, isTrue);
          expect(results.first.isSemanticMatch, isTrue);
          expect(results.first.score, greaterThanOrEqualTo(0.5));
        },
      );
    });
  });
}
