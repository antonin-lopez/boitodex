import 'package:flutter/material.dart';

import 'package:boitodex/core/theme/app_sizes.dart';

class PrimaryLoadingButton extends StatelessWidget {
  const PrimaryLoadingButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
    super.key,
  });

  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              width: AppSizes.spinner,
              height: AppSizes.spinner,
              child: CircularProgressIndicator(
                strokeWidth: AppSizes.spinnerStrokeWidth,
              ),
            )
          : Text(label),
    );
  }
}
