import 'package:flutter/material.dart';
import 'package:suiinvest/src/frontend/routing.dart';

import 'services/sui_example.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppRouter();
  }
}
