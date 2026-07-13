import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:boitodex/core/database/app_database.dart';
import 'package:boitodex/features/onboarding_pairing/data/repositories/onboarding_pairing_repository_impl.dart';

void main() {
  group('PairingRepositoryImpl', () {
    late AppDatabase db;
    late OnboardingPairingRepositoryImpl repository;

    setUp(() async {
      db = AppDatabase(
        NativeDatabase.memory(
          setup: (rawDb) {
            rawDb.execute('PRAGMA foreign_keys = ON;');
          },
        ),
      );
      repository = OnboardingPairingRepositoryImpl(db.collectionsDao);
    });

    tearDown(() async {
      await db.close();
    });

    group('createCollection', () {
      test(
        'should create, persist and return a new collection model',
        () async {
          final collection = await repository.createCollection();

          expect(collection.id, isNotEmpty);
          expect(collection.id.length, equals(36)); // UUID v4
          expect(collection.pairingCode.length, equals(8));
          expect(collection.createdAt, isNotNull);

          final active = await repository.getActiveCollection();
          expect(active, isNotNull);
          expect(active!.id, equals(collection.id));
          expect(active.pairingCode, equals(collection.pairingCode));
        },
      );
    });

    group('getCollectionByPairingCode', () {
      test('should return collection model when code matches', () async {
        final created = await repository.createCollection();

        final found = await repository.getCollectionByPairingCode(
          created.pairingCode,
        );

        expect(found, isNotNull);
        expect(found!.id, equals(created.id));
        expect(found.pairingCode, equals(created.pairingCode));
      });

      test('should return null when pairing code does not exist', () async {
        final result = await repository.getCollectionByPairingCode('UNKNOWN8');

        expect(result, isNull);
      });
    });

    group('getActiveCollection', () {
      test(
        'should return active collection when a collection exists in database',
        () async {
          final created = await repository.createCollection();

          final active = await repository.getActiveCollection();

          expect(active, isNotNull);
          expect(active!.id, equals(created.id));
        },
      );

      test('should return null when database is empty', () async {
        final active = await repository.getActiveCollection();

        expect(active, isNull);
      });
    });

    group('deleteCollection', () {
      test('should remove collection from database', () async {
        final created = await repository.createCollection();

        await repository.deleteCollection(created.id);

        final active = await repository.getActiveCollection();
        expect(active, isNull);
      });
    });
  });
}
