import 'package:flutter/material.dart';
import 'package:sui/sui.dart';
import 'package:suiinvest/src/frontend/routing.dart';
import 'package:suiinvest/src/frontend/account.dart';
import 'package:suiinvest/src/services/authentication.dart';

class MyApp extends StatelessWidget {
  final SuiAccount userAccount;

class MyApp extends StatefulWidget {
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
  MyApp({Key? key, required this.userAccount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If there is an error, return an error widget.

    return MaterialApp(
      title: 'SUI Invest',
      home: AppRouter(userAccount: userAccount),
    );
  }
}
