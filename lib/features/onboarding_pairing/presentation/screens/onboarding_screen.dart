import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:boitodex/core/constants/app_constants.dart';
import 'package:boitodex/core/theme/app_spacing.dart';
import 'package:boitodex/core/widgets/async_result_handler.dart';
import 'package:boitodex/core/widgets/primary_loading_button.dart';
import 'package:boitodex/features/onboarding_pairing/data/providers/onboarding_pairing_providers.dart';
import 'package:boitodex/features/onboarding_pairing/presentation/controllers/onboarding_pairing_controller.dart';
import 'package:boitodex/features/onboarding_pairing/presentation/screens/join_collection_screen.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  Future<void> _createCollection(BuildContext context, WidgetRef ref) async {
    await ref
        .read(onboardingPairingControllerProvider.notifier)
        .createCollection();
    if (!context.mounted) return;

    handleAsyncActionResult(
      context,
      ref.read(onboardingPairingControllerProvider),
      onSuccess: (collection) =>
          _showPairingCodeDialog(context, ref, collection!.pairingCode),
    );
  }

  void _showPairingCodeDialog(
    BuildContext context,
    WidgetRef ref,
    String pairingCode,
  ) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Collection créée'),
        content: Text('Code à partager avec ta famille :\n$pairingCode'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              ref.invalidate(activeCollectionProvider);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(onboardingPairingControllerProvider).isLoading;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryLoadingButton(
                label: 'Créer une collection',
                isLoading: isLoading,
                onPressed: () => _createCollection(context, ref),
              ),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton(
                onPressed: isLoading
                    ? null
                    : () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const JoinCollectionScreen(),
                        ),
                      ),
                child: const Text('Rejoindre une collection'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
