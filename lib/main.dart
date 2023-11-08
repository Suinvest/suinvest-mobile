import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:sui/sui_account.dart';
import 'package:suiinvest/src/services/authentication.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load in all environment variables from .env
  await FlutterConfig.loadEnvVariables();

  SuiAccount? userAccount;
  String? error;

  try {
    userAccount = await fetchUserAccount();
    if (userAccount != null) {
      // Run src/app.dart with a non-null userAccount
      runApp(MyApp(userAccount: userAccount));
    }
  } catch (e) {
    error = e.toString();
    print('Failed to fetch userAccount: $error');
  }
}
