import 'package:flutter/services.dart';

abstract class SystemUi {
  static void enableEdgeToEdge() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
}
