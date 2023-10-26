import 'package:flutter/material.dart';
import 'package:flutter_locker/flutter_locker.dart';
import 'package:suiinvest/src/frontend/routing.dart';

import 'services/sui_example.dart';

Future<void> canAuthenticate() async {
  try {
    final canAuthenticate = await FlutterLocker.canAuthenticate();

    print('Can authenticate: $canAuthenticate');
  } on Exception catch (exception) {
    print(exception);
  }
}

Future<void> saveSecret(key, secret) async {
  try {
    await FlutterLocker.save(
      SaveSecretRequest(
          key: key,
          secret: secret,
          androidPrompt: AndroidPrompt(
              title: 'Authenticate',
              cancelLabel: 'Cancel',
              descriptionLabel: 'Please authenticate')),
    );

    print('Secret saved, secret: $secret');
  } on Exception catch (exception) {
    print(exception);
  }
}

Future<void> retrieveSecret(key) async {
  try {
    final retrieved = await FlutterLocker.retrieve(RetrieveSecretRequest(
        key: key,
        androidPrompt: AndroidPrompt(
            title: 'Authenticate',
            cancelLabel: 'Cancel',
            descriptionLabel: 'Please authenticate'),
        iOsPrompt: IOsPrompt(touchIdText: 'Authenticate')));

    print('Secret retrieved, secret: $retrieved');
  } on Exception catch (exception) {
    print(exception);
  }
}

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppRouter();
  }
}
