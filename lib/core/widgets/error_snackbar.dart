import 'package:flutter/material.dart';

/// Displays a floating Material 3 error snackbar with immediate visual feedback.
void showErrorSnackBar(
  BuildContext context,
  Object error, {
  String? fallbackMessage,
}) {
  final messenger = ScaffoldMessenger.of(context);
  final colorScheme = Theme.of(context).colorScheme;

  final message =
      _extractMessage(error) ?? fallbackMessage ?? 'Une erreur est survenue';

  // Dismiss any active snackbars to prevent queued delays.
  messenger.clearSnackBars();

  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: colorScheme.errorContainer,
      content: Text(
        message,
        style: TextStyle(color: colorScheme.onErrorContainer),
      ),
    ),
  );
}

/// Extracts a human-readable message from [error], if recognized.
String? _extractMessage(Object error) {
  if (error is String) return error;
  // Can handle custom domain exceptions here:
  // if (error is AppException) return error.message;
  return null;
}
