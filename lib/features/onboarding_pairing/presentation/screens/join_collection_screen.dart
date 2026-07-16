import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:boitodex/core/theme/app_spacing.dart';
import 'package:boitodex/core/utils/pairing_code_generator.dart';
import 'package:boitodex/core/widgets/async_result_handler.dart';
import 'package:boitodex/core/widgets/primary_loading_button.dart';
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

    handleAsyncActionResult(
      context,
      ref.read(onboardingPairingControllerProvider),
      onSuccess: (_) => Navigator.of(context).pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(onboardingPairingControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Rejoindre une collection')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _pairingCodeController,
              textCapitalization: TextCapitalization.characters,
              maxLength: PairingCodeGenerator.codeLength,
              decoration: const InputDecoration(
                labelText: 'Code de la collection',
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryLoadingButton(
              label: 'Rejoindre',
              isLoading: isLoading,
              onPressed: _joinCollection,
            ),
          ],
        ),
      ),
    );
  }
}
