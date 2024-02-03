// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sui/sui.dart';
import 'package:suiinvest/src/frontend/price_history.dart';
import 'package:suiinvest/src/common/constants/coins.dart';
import 'package:suiinvest/src/services/authentication.dart';
import 'package:suiinvest/src/services/coingecko.dart';

class CryptoListItem extends StatelessWidget {
  final int rank;
  final String name;
  final String symbol;
  final String price;
  final String change;
  final String iconUrl;
  final SuiAccount userAccount;

  const CryptoListItem(
      {Key? key,
      required this.rank,
      required this.name,
      required this.symbol,
      required this.price,
      required this.change,
      required this.iconUrl,
      required this.userAccount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CoinDetailPage(
              coinId: name,
              price: price,
              change: change,
              userAccount: userAccount,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        margin: EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  '$rank',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
                SizedBox(width: 12.0),
                Image.network(
                  iconUrl,
                  width: 24,
                  height: 24,
                ),
                SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                    Text(
                      symbol,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
                Text(
                  change,
                  style: TextStyle(
                      color: change.startsWith('-') ? Colors.red : Colors.green,
                      fontSize: 16.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<CryptoListItem>> fetchCoins() async {
  final coinMarketData = await fetchCoinPrices(
      COINS.map((coin) => coin.coinGeckoId).toList(), "usd");
  final userAccount = await fetchUserAccount();
  if (coinMarketData != null && userAccount != null) {
    return coinMarketData.map((coin) {
      {
        return CryptoListItem(
          rank: coin.marketCapRank ?? 0,
          name: coin.name,
          symbol: coin.symbol,
          price: coin.currentPrice?.toStringAsFixed(2) ?? "0.00",
          change:
              "${coin.priceChangePercentage24h?.toStringAsFixed(2) ?? "-"}%",
          iconUrl: coin.image ?? "",
          userAccount: userAccount,
        );
      }
    }).toList();
  } else {
    throw Exception('Failed to load coins');
  }
}

class CoinPage extends StatefulWidget {
  const CoinPage({super.key});
  @override
  _CoinPageState createState() => _CoinPageState();
}

class _CoinPageState extends State<CoinPage> {
  List<CryptoListItem>? _allCoins;
  List<CryptoListItem>? _filteredCoins;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadCoins();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _loadCoins() async {
    var coins = await fetchCoins();
    setState(() {
      _allCoins = coins;
      _filteredCoins = coins;
    });
  }

  void _onSearchChanged() {
    setState(() {
      _filteredCoins = _allCoins?.where((coin) {
        return coin.name
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            coin.symbol
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Track Coins',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _searchController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: _filteredCoins == null
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: _filteredCoins!.length,
                        itemBuilder: (context, index) {
                          return _filteredCoins![index];
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
