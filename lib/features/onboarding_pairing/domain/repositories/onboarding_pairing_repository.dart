import 'package:boitodex/features/onboarding_pairing/domain/models/collection.dart';

abstract class OnboardingPairingRepository {
  Future<Collection> createCollection();

  Future<Collection?> getCollectionByPairingCode(String pairingCode);

  Future<Collection?> getActiveCollection();

  Future<void> deleteCollection(String collectionId);
}
