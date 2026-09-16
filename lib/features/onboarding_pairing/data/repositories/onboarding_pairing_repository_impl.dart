import 'package:uuid/uuid.dart';

import 'package:boitodex/core/database/app_database.dart';
import 'package:boitodex/core/database/daos/collections_dao.dart';
import 'package:boitodex/core/utils/pairing_code_generator.dart';
import 'package:boitodex/features/onboarding_pairing/domain/models/collection.dart';
import 'package:boitodex/features/onboarding_pairing/domain/repositories/onboarding_pairing_repository.dart';

/// Implementation of [OnboardingPairingRepository] managing collection setup and pairing.
class OnboardingPairingRepositoryImpl implements OnboardingPairingRepository {
  final CollectionsDao _collectionsDao;

  OnboardingPairingRepositoryImpl(this._collectionsDao);

  @override
  Future<Collection> createCollection() async {
    final id = const Uuid().v4();
    final code = PairingCodeGenerator.generate();
    final now = DateTime.now();

    final companion = CollectionsTableCompanion.insert(
      id: id,
      pairingCode: code,
      createdAt: now,
    );

    await _collectionsDao.insertOrUpdateCollection(companion);

    return Collection(id: id, pairingCode: code, createdAt: now);
  }

  @override
  Future<Collection?> getCollectionByPairingCode(String pairingCode) async {
    final data = await _collectionsDao.getCollectionByPairingCode(pairingCode);
    return data != null ? _toDomain(data) : null;
  }

  @override
  Future<Collection?> getActiveCollection() async {
    final data = await _collectionsDao.getActiveCollection();
    return data != null ? _toDomain(data) : null;
  }

  @override
  Future<void> deleteCollection(String collectionId) async {
    await _collectionsDao.deleteCollection(collectionId);
  }

  Collection _toDomain(CollectionData data) {
    return Collection(
      id: data.id,
      pairingCode: data.pairingCode,
      createdAt: data.createdAt,
    );
  }
}
