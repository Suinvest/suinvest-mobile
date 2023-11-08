import 'package:flutter/material.dart';
import 'package:sui/sui.dart';
import 'package:suiinvest/src/frontend/routing.dart';

class MyApp extends StatelessWidget {
  final SuiAccount userAccount;

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
