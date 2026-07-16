import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:boitodex/core/widgets/error_snackbar.dart';

void handleAsyncActionResult<T>(
  BuildContext context,
  AsyncValue<T> state, {
  required void Function(T data) onSuccess,
}) {
  state.when(
    data: onSuccess,
    error: (error, _) => showErrorSnackBar(context, error),
    loading: () {},
  );
}
