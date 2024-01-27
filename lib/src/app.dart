import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:sui/sui.dart';
import 'package:suiinvest/src/frontend/routing.dart';
import 'package:suiinvest/src/services/authentication.dart';


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  late Future<SuiAccount?> userAccount; // Declare userAccount as a Future
  @override
  void initState() {
    super.initState();
    saveSecret("private_key", FlutterConfig.get("SUI_PRIVATE_KEY")); // Save a secret (for testing purposes)
  }

  Future<SuiAccount?> fetchUserAccountObject() async {
    final userAccount = await fetchUserAccount(); // Initialize userAccount in initState
    if (userAccount == null) {
      print('Failed to fetch userAccount');
    } 
    return userAccount;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SuiAccount?>(
      future: fetchUserAccountObject(), // Use data Future
      builder: (context, snapshot) {
        return AppRouter(userAccount: snapshot.data);
      },
    );
  }
}