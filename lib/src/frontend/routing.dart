import 'package:flutter/material.dart';
import 'package:suiinvest/src/frontend/account.dart';
import 'package:suiinvest/src/frontend/home.dart';

class AppRouter extends StatefulWidget {
  @override
  _AppRouterState createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  final List<Widget> pages = [
    HomePage(),
    HomePage(),
    HomePage(),
    // ListPage(),
    // ExchangePage(),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SUI Invest',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color.fromRGBO(14, 15, 19, 1),
      ),
      home: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: pages,
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
