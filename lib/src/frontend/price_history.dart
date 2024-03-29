// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:candlesticks/candlesticks.dart';
import 'package:suiinvest/src/common/constants/colors.dart';
import 'package:suiinvest/src/frontend/exchange.dart';
import 'package:sui/sui.dart';

class CoinDetailPage extends StatefulWidget {
  final String coinId;
  final String price;
  final String change;
  final SuiAccount userAccount;

  const CoinDetailPage({
    Key? key,
    required this.coinId,
    required this.price,
    required this.change,
    required this.userAccount,
  }) : super(key: key);

  @override
  State<CoinDetailPage> createState() => _CoinDetailPageState();
}

class _CoinDetailPageState extends State<CoinDetailPage> {
  late Future<List<Candle>> ohlcDataFuture;
  double? marketCap;
  double? totalVolume;
  void _goToExchange(input) {
    if (widget.userAccount != null) {
      // Only navigate if userAccount is not null
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ExchangePage(userAccount: widget.userAccount, input: input),
        ),
      );
    } else {
      // Handle the case when userAccount is null
      // e.g., show an error, prompt for login, etc.
    }
  }

  @override
  void initState() {
    super.initState();
    ohlcDataFuture = fetchCoinCandles(widget.coinId);
  }

  String formatNumberAsWord(num value) {
    if (value >= 1e9) {
      return '${(value / 1e9).toStringAsFixed(3)} billion';
    } else if (value >= 1e6) {
      return '${(value / 1e6).toStringAsFixed(3)} million';
    } else {
      return value.toStringAsFixed(3);
    }
  }

  Future<List<Candle>> fetchCoinCandles(String coinId) async {
    coinId = coinId.toLowerCase();
    final ohlcUri = Uri.parse(
        'https://api.coingecko.com/api/v3/coins/$coinId/ohlc?vs_currency=usd&days=7');
    final marketCapUri = Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=$coinId');

    try {
      // Fetch OHLC data
      final ohlcResponse = await http.get(ohlcUri);
      // Fetch market cap and volume data
      final marketCapResponse = await http.get(marketCapUri);

      if (ohlcResponse.statusCode == 200 &&
          marketCapResponse.statusCode == 200) {
        final ohlcData = json.decode(ohlcResponse.body) as List;
        final marketData = json.decode(marketCapResponse.body) as List;

        // Check if market data is not empty and assign the values
        if (marketData.isNotEmpty) {
          final data = marketData.first;
          marketCap = (data['market_cap'] as num).toDouble();
          totalVolume = (data['total_volume'] as num).toDouble();
        }

        // Parse the OHLC data
        return ohlcData.map((ohlcEntry) {
          return Candle(
            date: DateTime.fromMillisecondsSinceEpoch(ohlcEntry[0]),
            open: (ohlcEntry[1] as num).toDouble(),
            high: (ohlcEntry[2] as num).toDouble(),
            low: (ohlcEntry[3] as num).toDouble(),
            close: (ohlcEntry[4] as num).toDouble(),
            volume: (totalVolume as num).toDouble(),
          );
        }).toList();
      } else {
        // Handle error responses
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          backgroundColor: Colors.black,
          titleSpacing: 0,
          flexibleSpace: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.black,
              child: Padding(
                padding: EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  '${widget.coinId} price',
                  style: TextStyle(
                    color: Color.fromARGB(255, 187, 185, 185),
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.black,
              child: Padding(
                padding: EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  '\$ ${widget.price}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.black,
              child: Padding(
                padding: EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  widget.change,
                  style: TextStyle(
                      color: widget.change.startsWith('-')
                          ? Colors.red
                          : Colors.green,
                      fontSize: 16.0),
                ),
              ),
            ),

            // Statistics section
            FutureBuilder<List<Candle>>(
              future: ohlcDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError || snapshot.data == null) {
                  return const Center(
                      child: Text(
                    'Error loading OHLC data',
                    style: TextStyle(color: Colors.white),
                  ));
                } else {
                  // Assuming we are interested in the latest OHLC data
                  final latestData = snapshot.data!.last;
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 320,
                          decoration: BoxDecoration(
                            color: Colors.black,
                          ),
                          child: Theme(
                            data: ThemeData.dark(),
                            child: Candlesticks(
                              candles: snapshot.data!,
                              backgroundColor: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        // Displaying OHLC statistics
                        Text("Market Statistics",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Center(
                          child: Container(
                            // padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                StatisticsRow(
                                  title: 'Market Cap',
                                  value:
                                      '\$${formatNumberAsWord(marketCap ?? 0)}',
                                  iconData: Icons.insights,
                                ),
                                StatisticsRow(
                                  title: 'Volume',
                                  value:
                                      '\$${formatNumberAsWord(latestData.volume)}',
                                  iconData: Icons.leaderboard,
                                ),

                                // Two statistics rows
                                StatisticsRow(
                                  title: 'Open',
                                  value: formatNumberAsWord(latestData.open),
                                  iconData: Icons.brightness_1,
                                ),
                                StatisticsRow(
                                  title: 'Close',
                                  value: formatNumberAsWord(latestData.close),
                                  iconData: Icons.panorama_fisheye,
                                ),
                                StatisticsRow(
                                  title: 'High',
                                  value: formatNumberAsWord(latestData.high),
                                  iconData: Icons.arrow_upward,
                                ),
                                StatisticsRow(
                                  title: 'Low',
                                  value: formatNumberAsWord(latestData.low),
                                  iconData: Icons.arrow_downward,
                                ),
                                Divider(color: Colors.white54),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 24),
                        // BUY and SELL action buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // SELL Button
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: ElevatedButton(
                                onPressed: () {
                                  print("DEBUGGING");
                                  print(widget.coinId);
                                  var input = {
                                    "action": "sell",
                                    "coinId": widget.coinId.toLowerCase()
                                  };
                                  _goToExchange(input);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: AppColors.buttonBlue,
                                  side: BorderSide(
                                      color: AppColors.buttonBlue, width: 2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 15),
                                ),
                                child: Text('SELL'),
                              ),
                            ),
                            // BUY Button
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 8),
                              child: ElevatedButton(
                                onPressed: () {
                                  // BUY logic here
                                  var input = {
                                    "action": "buy",
                                    "coinId": widget.coinId.toLowerCase()
                                  };
                                  _goToExchange(input);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.buttonBlue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 15),
                                ),
                                child: Text('BUY'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class StatisticsRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData iconData;

  const StatisticsRow({
    Key? key,
    required this.title,
    required this.value,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(iconData, color: AppColors.buttonBlue, size: 20),
            SizedBox(width: 8),
            Text(title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.normal)),
          ],
        ),
        Text(value, style: TextStyle(color: Colors.white, fontSize: 18)),
      ],
    );
  }
}

class ActionButton extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onPressed;

  const ActionButton({
    Key? key,
    required this.title,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: color,
        backgroundColor: color,
        side: BorderSide(),
        shape: StadiumBorder(),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Text(title, style: TextStyle(fontSize: 18)),
      ),
    );
  }
}

final candle = Candle(
    date: DateTime.now(),
    open: 1780.36,
    high: 1873.93,
    low: 1755.34,
    close: 1848.56,
    volume: 0);
