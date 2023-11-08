import 'package:flutter/material.dart';
import 'package:sui/sui.dart';
// import 'package:suiinvest/src/frontend/common/helpers/string.dart';
import 'widgets/ecosystem_item.dart';
import 'widgets/welcome.dart';
import 'widgets/buildPortfolio.dart';

class HomePage extends StatelessWidget {
  // props
  final SuiAccount userAccount;
  final List<CoinBalance> userBalances;
  //constructor
  HomePage({required this.userAccount, required this.userBalances});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        // Padding moved here to wrap the entire ListView
        padding: const EdgeInsets.only(top: 50.0, left: 16.0, right: 16),
        child: Column(
          children: [
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  Welcome(context, userAccount),
                  SizedBox(height: 30.0),
                  buildPortfolio(context),
                  SizedBox(height: 40.0),
                  buildHealth(
                      context), // Assuming buildHealth requires these parameters
                  SizedBox(height: 40.0),
                  listCoins(context, userBalances)
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
}
