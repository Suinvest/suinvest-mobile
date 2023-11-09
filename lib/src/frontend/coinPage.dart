// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:suiinvest/src/services/defillama.dart';

class CryptoListItem extends StatelessWidget {
  final int rank;
  final String name;
  final String symbol;
  final String price;
  final String change;
  final String iconUrl;

  const CryptoListItem({
    Key? key,
    required this.rank,
    required this.name,
    required this.symbol,
    required this.price,
    required this.change,
    required this.iconUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                width: 24, // Set your preferred width for the icon
                height: 24, // Set your preferred height for the icon
              ), // Placeholder icon
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
    );
  }
}

Future<List<CryptoListItem>> fetchCoins() async {
  final res = await fetchSUIData();
  final response = await http.get(Uri.parse(
      'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1&sparkline=false'));
  if (response.statusCode == 200) {
    List<dynamic> coinsJson = json.decode(response.body);
    return coinsJson.map((json) {
      final change = json['price_change_percentage_24h'] ?? 0.0;
      return CryptoListItem(
        rank: json['market_cap_rank'],
        name: json['name'],
        symbol: json['symbol'].toUpperCase(),
        price: '\$${json['current_price']}',
        change: '${change.toStringAsFixed(2)}%',
        iconUrl: json['image'],
      );
    }).toList();
  } else if (response.statusCode == 429) {
    print("Coingecko rate limited");
    throw Exception('Coingecko rate limited');
  } else {
    throw Exception('Failed to load coins');
  }
}

class CoinPage extends StatelessWidget {
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
                textAlign: TextAlign.center, // Center the text
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0, // Adjust the font size as needed
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 20),
              TextField(
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
                child: FutureBuilder<List<CryptoListItem>>(
                  future: fetchCoins(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      List<CryptoListItem> coins = snapshot.data!;
                      return ListView(
                        children: coins,
                      );
                    } else {
                      return Center(child: Text('No coins found.'));
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
