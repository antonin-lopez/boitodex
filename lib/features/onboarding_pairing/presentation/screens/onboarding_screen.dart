import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:boitodex/core/constants/app_constants.dart';
import 'package:boitodex/features/onboarding_pairing/data/providers/onboarding_pairing_providers.dart';
import 'package:boitodex/features/onboarding_pairing/presentation/controllers/onboarding_pairing_controller.dart';
import 'package:boitodex/features/onboarding_pairing/presentation/screens/join_collection_screen.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(onboardingPairingControllerProvider).isLoading;

    Future<void> createCollection() async {
      await ref
          .read(onboardingPairingControllerProvider.notifier)
          .createCollection();
      if (!context.mounted) return;

      ref
          .read(onboardingPairingControllerProvider)
          .when(
            data: (collection) =>
                _showPairingCodeDialog(context, ref, collection!.pairingCode),
            error: (error, _) => ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('$error'))),
            loading: () {},
          );
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: isLoading ? null : createCollection,
                child: const Text('Créer une collection'),
              ),
              const SizedBox(height: 12),
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
              if (isLoading) ...[
                const SizedBox(height: 24),
                const CircularProgressIndicator(),
              ],
            ],
          ),
        ),
      ),
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
}
