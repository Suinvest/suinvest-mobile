import 'package:flutter/material.dart';
import 'package:sui/sui.dart';
import 'package:suiinvest/src/frontend/routing.dart';
import 'package:suiinvest/src/services/authentication.dart';
import 'package:suiinvest/src/services/sui.dart';

class AccountCreationPage extends StatefulWidget {
  @override
  _AccountCreationPageState createState() => _AccountCreationPageState();
}

class _AccountCreationPageState extends State<AccountCreationPage> {
  final TextEditingController _privateKeyController = TextEditingController();
  TextEditingController _generatedPrivateKey = TextEditingController();

  @override
  void dispose() {
    _privateKeyController.dispose();
    super.dispose();
  }

  void _generateNewPrivateKey() async {
    // Generate a new Sui account using the ED25519 scheme
    final SuiAccount newAccount = SuiAccount.ed25519Account();
    final String privateKeyHex = newAccount.privateKeyHex();

    // Use the saveSecret function to securely save the private key
    bool isSaved = await saveSecret('private_key', privateKeyHex);

    if (isSaved) {
      // If the key is saved successfully, update the UI to show the private key
      setState(() {
        _generatedPrivateKey.text = privateKeyHex;
      });

      // Navigate to the main app
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => AppRouter(userAccount: newAccount)),
        (Route<dynamic> route) => false,
      );
    } else {
      // Handle the error if the key wasn't saved properly
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save the private key securely.')));
      print('Failed to save the private key securely.');
    }
  }

  void _createAccountFromPrivateKey() async {
    // Get the private key from the text field
    final String privateKeyHex = _privateKeyController.text;

    // Validate the private key format?

    // Create a new Sui account using the provided private key
    SuiAccount? newAccount;
    try {
      newAccount = await buildUserFromPrivKey(privateKeyHex);
    } catch (e) {
      // Handle invalid private key format
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Invalid private key format. Please check and try again.')));
      return;
    }

    // Use the saveSecret function to securely save the private key
    bool isSaved = await saveSecret('private_key', privateKeyHex);

    if (isSaved && newAccount != null) {
      // If the key is saved successfully, navigate to the main app page
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => AppRouter(userAccount: newAccount)),
        (Route<dynamic> route) => false,
      );
    } else {
      // Handle the error if the key wasn't saved properly
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save the private key securely.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Sui-Invest',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32),
            Text(
              'Create a new account by either generating a new private key or by entering an existing private key.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generateNewPrivateKey,
              child: Text('Generate new private key to get started'),
            ),
            SizedBox(height: 16),

            // Flow if user enters a private key
            TextField(
              controller: _privateKeyController,
              decoration: InputDecoration(
                hintText: 'Enter Private Key',
              ),
            ),
            SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: ,
            //   child: Text('Create Account using inputted Private Key'),
            // ),
          ],
        ),
      ),
    );
  }
}
