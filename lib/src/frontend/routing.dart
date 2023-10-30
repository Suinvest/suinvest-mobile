import 'package:flutter/material.dart';
import 'package:flutter_locker/flutter_locker.dart';
import 'package:sui/sui.dart';
import 'package:suiinvest/src/frontend/account.dart';
import 'package:suiinvest/src/services/authentication.dart';
import 'package:flutter_config/flutter_config.dart';

import 'package:suiinvest/src/frontend/home.dart';

class AppRouter extends StatefulWidget {
  @override
  _AppRouterState createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  // final List<Widget> pages = [
  //   HomePage(userAccount: userAccount),
  //   HomePage(userAccount: userAccount),
  //   HomePage(userAccount: userAccount),
  // ];
  int _currentIndex = 0;
  late Future<SuiAccount?> userAccount; // Declare userAccount as a Future
  @override
  void initState() {
    super.initState();
    saveSecret("private_key", FlutterConfig.get("SUI_PRIVATE_KEY")); // Save a secret (for testing purposes)
    userAccount = fetchUserAccount(); // Initialize userAccount in initState
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SUI Invest',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color.fromRGBO(14, 15, 19, 1),
      ),
      home: Scaffold(
        body: FutureBuilder<SuiAccount?>(
          future: userAccount, // Use userAccount Future
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While the future is running, display a loading indicator or placeholder.
              return CircularProgressIndicator(); // Replace with your loading widget.
            } else if (snapshot.hasError) {
              print('Error: ${snapshot.error}');
              // If the future encounters an error, display an error message.
              return Text('Error: ${snapshot.error}');
            } else {
              // If the future completes successfully, build your widget based on the result.
              SuiAccount? userAccount = snapshot.data; // Default value if null
              print(userAccount);
              // if (userAccount == null) then we prompt user to sign in
              if (userAccount == null) {
                return IndexedStack(
                  index: _currentIndex,
                  children: [],
                );
              }
              // Use the userAccount in your widget.
              return HomePage(userAccount: userAccount);
            }
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Color.fromRGBO(105, 143, 246, 1),
          unselectedItemColor: Color.fromRGBO(255, 255, 255, 0.25),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _currentIndex,
          backgroundColor: Color.fromRGBO(27, 28, 29, 1),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 30.0),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.query_stats, size: 30.0),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.swap_horiz, size: 30.0),
              label: '',
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
