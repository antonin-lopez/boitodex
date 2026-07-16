import 'package:flutter/material.dart';

extension SystemInsets on BuildContext {
  double get bottomSystemInset => MediaQuery.of(this).padding.bottom;
}
