import 'package:flutter/material.dart';
import 'package:sui/sui.dart';
import 'package:suiinvest/src/frontend/exchange.dart';
import 'package:suiinvest/src/frontend/home.dart';

class AppRouter extends StatelessWidget {
  final SuiAccount userAccount;

  AppRouter({required this.userAccount});

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0; // Start with the first index by default

    // Define your pages here
    final List<Widget> _pages = [
      HomePage(userAccount: userAccount), // Replace with your HomePage widget
      Text('Transaction Stats Page'),
      ExchangePage(userAccount: userAccount),
      // Add more pages as needed
    ];

    // Function to handle navigation logic
    void _onItemTapped(int index) {
      // Use the Navigator to push the new page onto the navigation stack
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => _pages[index]),
      );
    }

    // Use the userAccount to build your widget tree
    return MaterialApp(
      title: 'SUI Invest',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromRGBO(14, 15, 19, 1),
      ),
      home: Scaffold(
        body: HomePage(userAccount: userAccount),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: const Color.fromRGBO(105, 143, 246, 1),
          unselectedItemColor: const Color.fromRGBO(255, 255, 255, 0.25),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          // Assuming currentIndex is managed by HomePage or another component.
          currentIndex: 0, // Default to the first tab
          backgroundColor: const Color.fromRGBO(27, 28, 29, 1),
          items: const [
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
            _selectedIndex = index;
            _onItemTapped(_selectedIndex);
          },
        ),
      ),
    );
  }
}
