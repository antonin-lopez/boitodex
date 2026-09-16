import 'package:flutter/material.dart';

extension SystemInsets on BuildContext {
  /// Returns the bottom system padding (e.g. gesture bar, notch).
  /// Uses [MediaQuery.paddingOf] to prevent unnecessary rebuilds.
  double get bottomSystemPadding => MediaQuery.paddingOf(this).bottom;
}
