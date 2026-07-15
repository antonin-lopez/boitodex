import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:boitodex/features/onboarding_pairing/data/providers/onboarding_pairing_providers.dart';
import 'package:boitodex/features/onboarding_pairing/domain/models/collection.dart';

part 'onboarding_pairing_controller.g.dart';

@riverpod
class OnboardingPairingController extends _$OnboardingPairingController {
  @override
  FutureOr<Collection?> build() => null;

  Future<void> createCollection() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(onboardingPairingRepositoryProvider).createCollection(),
    );
  }

  Future<void> joinCollection(String pairingCode) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final collection = await ref
          .read(onboardingPairingRepositoryProvider)
          .getCollectionByPairingCode(pairingCode);

      if (collection == null) {
        throw StateError('Aucune collection ne correspond à ce code.');
      }
      return collection;
    });
    if (state.hasValue) ref.invalidate(activeCollectionProvider);
  }
}
