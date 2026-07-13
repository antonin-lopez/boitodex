import 'package:boitodex/core/database/app_database.dart';
import 'package:boitodex/core/database/daos/collections_dao.dart';
import 'package:boitodex/core/utils/pairing_code_generator.dart';
import 'package:boitodex/core/utils/uuid_generator.dart';
import 'package:boitodex/features/onboarding_pairing/domain/models/collection.dart';
import 'package:boitodex/features/onboarding_pairing/domain/repositories/onboarding_pairing_repository.dart';

class OnboardingPairingRepositoryImpl implements OnboardingPairingRepository {
  final CollectionsDao _collectionsDao;

  OnboardingPairingRepositoryImpl(this._collectionsDao);

  @override
  Future<Collection> createCollection() async {
    final id = UuidGenerator.generate();
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
    if (data == null) return null;

    return Collection(
      id: data.id,
      pairingCode: data.pairingCode,
      createdAt: data.createdAt,
    );
  }

  @override
  Future<Collection?> getActiveCollection() async {
    final data = await _collectionsDao.getActiveCollection();
    if (data == null) return null;

    return Collection(
      id: data.id,
      pairingCode: data.pairingCode,
      createdAt: data.createdAt,
    );
  }

  @override
  Future<void> deleteCollection(String collectionId) async {
    await _collectionsDao.deleteCollection(collectionId);
  }
}
