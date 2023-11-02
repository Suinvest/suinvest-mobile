import 'package:flutter/material.dart';
import 'package:sui/sui.dart';
import 'package:suiinvest/src/frontend/common/helpers/string.dart';
class HomePage extends StatelessWidget {
  // props
  final SuiAccount userAccount;
  final List<CoinBalance> userBalances;
  //constructor
  HomePage({required this.userAccount, required this.userBalances});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 16),
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              padding:
                  const EdgeInsets.only(top: 70.0, left: 16.0, right: 16.0),
              children: [
                Welcome(context, userAccount),
                SizedBox(height: 30.0),
                buildPortfolio(context),
                SizedBox(height: 40.0),
                // _buildCard(context, "card 1", "show"),
                buildHealth(context),
                SizedBox(height: 40.0),
                listCoins(context, userBalances)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPortfolio(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color.fromRGBO(38, 83, 204, 1),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Portfolio',
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <InlineSpan>[
                  TextSpan(
                    text: '\$1,732.00 ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'USD',
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget Welcome(BuildContext context, SuiAccount userAccount) {
  return Container(
    padding: EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome Back!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        Row(
          children: [
            Text(
              'Hi, ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            Text(
              trimUserAddress(userAccount.getAddress(), 6, 3),
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildCard(BuildContext context, String title, String value) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    height: 60,
    child: Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title),
          SizedBox(height: 8),
          Text(value),
        ],
      ),
    ),
  );
}

class EcosystemItem extends StatelessWidget {
  final String label;
  final String value;
  final String? change;

  EcosystemItem({required this.label, required this.value, this.change});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white, fontSize: 16.0)),
          Row(
            children: [
              Text(value,
                  style: TextStyle(color: Colors.white, fontSize: 16.0)),
              if (change != null) SizedBox(width: 8.0),
              if (change != null)
                Text(change!,
                    style: TextStyle(color: Colors.red, fontSize: 16.0)),
            ],
          ),
        ],
      ),
    );
  }
}

Widget buildHealth(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.0),
      color: Color(0xFF1A1A1A),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ecosystem Health',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 16.0),
        EcosystemItem(label: 'Market Cap', value: '\$356,104,841'),
        EcosystemItem(label: 'Price', value: '\$0.418026', change: '-12.4%'),
        EcosystemItem(label: '24hr Trading Vol', value: '\$29,026,989'),
        EcosystemItem(
            label: 'Fully Diluted Valuation', value: '\$4,138,862,797'),
        EcosystemItem(label: 'Circulating Supply', value: '\$860,392,9597'),
      ],
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
      children: 
        userBalances.map((coin) {
          return Text(coin.totalBalance.toString(),
              style: TextStyle(fontSize: 16));
        }).toList(),
    ),
  );
}
