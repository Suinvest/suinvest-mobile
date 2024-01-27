import 'package:flutter/material.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  bool _showPrivateKey = false;
  String _name = 'John Doe';

  void _togglePrivateKeyVisibility() {
    setState(() {
      _showPrivateKey = !_showPrivateKey;
    });
  }

  void _changeName(String newName) {
    setState(() {
      _name = newName;
    });
  }

  void _logout() {
    // TODO: Implement logout functionality
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter your name',
              ),
              onChanged: _changeName,
              controller: TextEditingController(text: _name),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Private Key',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: _showPrivateKey
                      ? TextField(
                          decoration: const InputDecoration(
                            hintText: 'Enter your private key',
                          ),
                          obscureText: false,
                          // TODO: Replace with actual private key
                          controller: TextEditingController(text: '123456'),
                        )
                      : const TextField(
                          decoration: InputDecoration(
                            hintText: '**********',
                          ),
                          obscureText: true,
                        ),
                ),
                IconButton(
                  icon: Icon(
                    _showPrivateKey ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: _togglePrivateKeyVisibility,
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            Center(
              child: ElevatedButton(
                onPressed: _logout,
                child: const Text('Log Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
