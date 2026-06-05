// lib/main.dart  ← Single entry point for all environments.
//                  Run with: flutter run --dart-define-from-file=env/<flavor>.json
//
// Environment values are loaded at compile time through AppEnv.

import 'package:flutter/material.dart';
import 'app.dart';
import 'config/app_config.dart';
import 'injection/container.dart';

void main() {
  setupLocator();
  runApp(const MyApp(config: AppConfig.current));
}
