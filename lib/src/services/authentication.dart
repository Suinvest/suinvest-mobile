import 'package:flutter_locker/flutter_locker.dart';
import 'package:suiinvest/src/services/sui.dart';
import 'package:sui/sui.dart';

// return type is bool of if device can authenticate
Future<bool> canAuthenticate() async {
  try {
    final canAuthenticate = await FlutterLocker.canAuthenticate();

    print('Can authenticate: $canAuthenticate');
    return canAuthenticate ?? false;
  } on Exception catch (exception) {
    print(exception);
    return false;
  }
}

// return type is bool of success when we store a key -> secret pair
Future<bool> saveSecret(key, secret) async {
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
    return true;
  } on Exception catch (exception) {
    print(exception);
    return false;
  }
}

// return type is string of secret when we fetch via key, or null if key not found
Future<String> retrieveSecret(key) async {
  try {
    final retrieved = await FlutterLocker.retrieve(RetrieveSecretRequest(
        key: key,
        androidPrompt: AndroidPrompt(
            title: 'Authenticate',
            cancelLabel: 'Cancel',
            descriptionLabel: 'Please authenticate'),
        iOsPrompt: IOsPrompt(touchIdText: 'Authenticate')));

    // print('Secret retrieved, secret: $retrieved');
    return retrieved;
  } on Exception catch (exception) {
    print(exception);
    return "";
  }
}

// fetches user account from keystore and constructs a SuiAccount object
Future<SuiAccount?> fetchUserAccount() async {
  try {
    final privKey = await retrieveSecret("private_key");
    if (privKey.isNotEmpty) {
      // Build the user account from the private key
      return buildUserFromPrivKey(privKey);
    } else {
      // If the private key is empty, return null to indicate no account
      return null;
    }
  } on Exception catch (exception) {
    print(exception);
    return null;
  }
}
