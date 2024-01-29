import 'package:flutter/material.dart';
import 'package:sui/sui.dart';
import 'package:suiinvest/src/frontend/coinPage.dart';
import 'package:suiinvest/src/frontend/exchange.dart';
import 'package:suiinvest/src/frontend/home.dart';

class AppRouter extends StatefulWidget {
  final SuiAccount? userAccount;

  const AppRouter({super.key, required this.userAccount});

  @override
  _AppRouterState createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  int _selectedIndex = 0; // Start with the first index by default
  late final PageController _pageController;

  SuiAccount?
      userAccount; // This is the variable we'll reference as the propagated userAccount object

  @override
  void initState() {
    super.initState();
    userAccount = widget.userAccount; // Initialize userAccount in initState
    if (userAccount == null) {
      // MAKE THIS SET THE INDEX TO THE SIGN IN PAGE
      // sign in page then will jump to home once the userAccount object is properly fetched
    }
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index); // Jump without animation
    // or _pageController.animateToPage(index, duration: Duration(milliseconds: 200), curve: Curves.easeIn); for animation
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SUI Invest',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromRGBO(14, 15, 19, 1),
      ),
      home: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _selectedIndex = index);
          },
          physics: const NeverScrollableScrollPhysics(),
          children: [
            //TODO: include more pages here
            HomePage(userAccount: widget.userAccount!, userBalances: const []),
            const CoinPage(),
            // MyApp(),
            // PriceLineChart(prices: [5.3, 6.4, 8.2, 5.1, 5.6, 7.8]),
            ExchangePage(userAccount: widget.userAccount!),
          ], // Disable page swiping
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: const Color.fromRGBO(105, 143, 246, 1),
          unselectedItemColor: const Color.fromRGBO(255, 255, 255, 0.25),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          backgroundColor: const Color.fromRGBO(27, 28, 29, 1),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 30.0),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.query_stats, size: 30.0),
              label: 'Stats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.swap_horiz, size: 30.0),
              label: 'Exchange',
            ),
          ],
          onTap: onItemTapped,
        ),
      ),
    );
  }
}
