import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:boitodex/core/database/app_database.dart';
import 'package:boitodex/core/ml/embedding_engine.dart';
import 'package:boitodex/core/providers/core_providers.dart';
import 'package:boitodex/features/car_entry_detail/presentation/controllers/car_entry_detail_controller.dart';

class FakeEmbeddingEngine implements EmbeddingEngine {
  @override
  bool get isInitialized => true;

  @override
  Future<List<double>> encodeText(String text) async {
    if (text.isEmpty) return List.filled(384, 0.0);
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
  group('CarEntryDetailController', () {
    late AppDatabase db;
    late ProviderContainer container;

    const testCollectionId = '2b3c4d5e-1234-4567-89ab-cdef01234567';

    setUp(() async {
      db = AppDatabase(
        NativeDatabase.memory(
          setup: (rawDb) {
            rawDb.execute('PRAGMA foreign_keys = ON;');
          },
        ),
      );

      container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          embeddingEngineProvider.overrideWithValue(FakeEmbeddingEngine()),
        ],
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
      container.dispose();
      await db.close();
    });

    group('deleteCar', () {
      test(
        'should soft delete an existing car and update state to AsyncData',
        () async {
          const carId = 'f1e2d3c4-b5a6-7890-fedc-ba0987654321';

          await container
              .read(carEntryDetailControllerProvider.notifier)
              .saveCar(
                id: carId,
                collectionId: testCollectionId,
                notes: 'Voiture à supprimer',
                keywordLabels: const ['Test'],
                imagePaths: const [],
              );

          await container
              .read(carEntryDetailControllerProvider.notifier)
              .deleteCar(carId);

          final state = container.read(carEntryDetailControllerProvider);
          expect(state.hasError, isFalse);

          final car = await db.carsDao.getCarById(carId);
          expect(car, isNotNull);
          expect(car!.deletedAt, isNotNull);
        },
      );
    });
  });
}
