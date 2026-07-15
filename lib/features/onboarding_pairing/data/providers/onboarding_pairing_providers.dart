import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:boitodex/core/providers/core_providers.dart';
import 'package:boitodex/features/onboarding_pairing/data/repositories/onboarding_pairing_repository_impl.dart';
import 'package:boitodex/features/onboarding_pairing/domain/repositories/onboarding_pairing_repository.dart';
import 'package:boitodex/features/onboarding_pairing/domain/models/collection.dart';

part 'onboarding_pairing_providers.g.dart';

@Riverpod(keepAlive: true)
OnboardingPairingRepository onboardingPairingRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return OnboardingPairingRepositoryImpl(db.collectionsDao);
}

@riverpod
Future<Collection?> activeCollection(Ref ref) {
  return ref.watch(onboardingPairingRepositoryProvider).getActiveCollection();
}
