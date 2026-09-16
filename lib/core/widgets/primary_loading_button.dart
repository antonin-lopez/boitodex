import 'package:flutter/material.dart';

/// A primary button that displays a spinner while performing an async action.
class PrimaryLoadingButton extends StatelessWidget {
  const PrimaryLoadingButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
    super.key,
  });

  static const double _spinnerSize = 20;
  static const double _spinnerStrokeWidth = 2;

  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              width: _spinnerSize,
              height: _spinnerSize,
              child: CircularProgressIndicator(
                strokeWidth: _spinnerStrokeWidth,
                strokeCap: StrokeCap.round,
              ),
            )
          : Text(label),
    );
  }
}
