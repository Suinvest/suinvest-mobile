// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sui/sui.dart';
// import 'package:suiinvest/src/frontend/common/helpers/string.dart';
import 'widgets/ecosystem_item.dart';
import 'widgets/welcome.dart';
import 'widgets/buildPortfolio.dart';

class HomePage extends StatefulWidget {
  final SuiAccount userAccount;
  final List<CoinBalance> userBalances;

  HomePage({required this.userAccount, required this.userBalances});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<String> userBalance;
  late Future<Map<String, dynamic>> ecosystemHealth;

  @override
  void initState() {
    super.initState();
    userBalance = fetchUserBalance(); // Fetch user balance on init
    ecosystemHealth = fetchEcosystemHealth(); // Fetch ecosystem health on init
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
        child: Column(
          children: [
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  Welcome(context, widget.userAccount),
                  SizedBox(height: 30.0),
                  FutureBuilder<String>(
                    future: userBalance,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        // Pass the fetched balance to the buildPortfolio widget
                        return buildPortfolio(context, snapshot.data!);
                      }
                    },
                  ),
                  SizedBox(height: 40.0),
                  FutureBuilder<Map<String, dynamic>>(
                    future: ecosystemHealth,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        // Pass the fetched ecosystem health to the buildHealth widget
                        return buildHealth(context, snapshot.data!);
                      }
                    },
                  ),
                  SizedBox(height: 40.0),
                  listCoins(context, widget.userBalances),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String> fetchUserBalance() async {
  // make the async function call here
  await Future.delayed(Duration(seconds: 2));
  // Assume this returns a string representation of the user balance
  return '\$1,800.00';
}

Future<Map<String, dynamic>> fetchEcosystemHealth() async {
  // make the async function call here
  await Future.delayed(Duration(seconds: 2));
  // Assume this returns a map containing various pieces of data about the ecosystem health
  return {
    'Market Cap': '\$390,104,841',
    'Price': '\$0.418026',
    'Price Change': '7.38%',
    '24hr Trading Vol': '\$29,026,989',
    'Fully Diluted Valuation': '\$4,138,862,797',
    'Circulating Supply': '\$860,392,9597',
  };
}

// example of how to use user fetched coins in front end
Widget listCoins(BuildContext context, List<CoinBalance> userBalances) {
  return Container(
    padding: EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.0),
      color: Color(0xFF1A1A1A),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: userBalances.map((coin) {
        return Text(coin.totalBalance.toString(),
            style: TextStyle(fontSize: 16));
      }).toList(),
    ),
  );
}
