import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load in all environment variables from .env
  await FlutterConfig.loadEnvVariables();

  // Run src/app.dart
  runApp(MyApp());
}
