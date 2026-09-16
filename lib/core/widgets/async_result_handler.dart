import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:boitodex/core/widgets/error_snackbar.dart';

/// Extension to safely handle asynchronous action outcomes (mutations) in the UI.
extension AsyncValueActionResult<T> on AsyncValue<T> {
  /// Executes [onSuccess] on completion or shows an error snackbar on failure.

  /// Safely ignores in-flight loading states and guards against unmounted contexts.
  void handleResult(
    BuildContext context, {
    required void Function(T data) onSuccess,
    void Function(Object error, StackTrace stackTrace)? onError,
  }) {
    if (!context.mounted) return;
    if (isLoading) return;

    whenOrNull(
      data: onSuccess,
      error: (error, stackTrace) {
        onError?.call(error, stackTrace);
        showErrorSnackBar(context, error);
      },
    );
  }
}
