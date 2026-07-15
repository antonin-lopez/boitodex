import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:boitodex/features/onboarding_pairing/presentation/controllers/onboarding_pairing_controller.dart';

class JoinCollectionScreen extends ConsumerStatefulWidget {
  const JoinCollectionScreen({super.key});

  @override
  ConsumerState<JoinCollectionScreen> createState() =>
      _JoinCollectionScreenState();
}

class _JoinCollectionScreenState extends ConsumerState<JoinCollectionScreen> {
  final _pairingCodeController = TextEditingController();

  @override
  void dispose() {
    _pairingCodeController.dispose();
    super.dispose();
  }

  Future<void> _joinCollection() async {
    final code = _pairingCodeController.text.trim().toUpperCase();
    await ref
        .read(onboardingPairingControllerProvider.notifier)
        .joinCollection(code);
    if (!mounted) return;

    ref
        .read(onboardingPairingControllerProvider)
        .when(
          data: (_) => Navigator.of(context).pop(),
          error: (error, _) => ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$error'))),
          loading: () {},
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(onboardingPairingControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Rejoindre une collection')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _pairingCodeController,
              textCapitalization: TextCapitalization.characters,
              maxLength: 8,
              decoration: const InputDecoration(
                labelText: 'Code de la collection',
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: isLoading ? null : _joinCollection,
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Rejoindre'),
            ),
          ],
        ),
      ),
    );
  }
}
