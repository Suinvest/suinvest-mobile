import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:candlesticks/candlesticks.dart';

class CoinDetailPage extends StatefulWidget {
  final String coinId;
  final String price;

  const CoinDetailPage({Key? key, required this.coinId, required this.price})
      : super(key: key);

  @override
  State<CoinDetailPage> createState() => _CoinDetailPageState();
}

class _CoinDetailPageState extends State<CoinDetailPage> {
  late Future<List<Candle>> ohlcDataFuture;

  @override
  void initState() {
    super.initState();
    ohlcDataFuture = fetchCoinCandles(widget.coinId);
  }

  Future<List<Candle>> fetchCoinCandles(String coinId) async {
    coinId = coinId.toLowerCase();
    final uri = Uri.parse(
        'https://api.coingecko.com/api/v3/coins/$coinId/ohlc?vs_currency=usd&days=7');
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final ohlcData = json.decode(response.body) as List;
        return ohlcData.map((ohlcEntry) {
          return Candle(
            date: DateTime.fromMillisecondsSinceEpoch(ohlcEntry[0]),
            open: (ohlcEntry[1] as num).toDouble(),
            high: (ohlcEntry[2] as num).toDouble(),
            low: (ohlcEntry[3] as num).toDouble(),
            close: (ohlcEntry[4] as num).toDouble(),
            volume: 1, // Volume is not provided in this example
          );
        }).toList();
      } else {
        print(
            'Request to $uri failed with status ${response.statusCode}: ${response.body}');
        throw Exception(
            'Failed to load candle data with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception when calling $uri: $e');
      throw Exception('Failed to load candle data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.coinId,
          style: TextStyle(color: Colors.white),
        ), // Display coin ID as title
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: <Widget>[
          // Placeholder for the candlestick chart
          Container(
            height: 30,
            color: Colors.black,
            child: Center(
              child: Text(
                'Price ${widget.price}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
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
                for (final candle in snapshot.data!) {
                  print(
                      '${candle.date}: ${candle.open} ${candle.high} ${candle.low} ${candle.close}');
                }
                print(snapshot.data!);
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        height: 250,
                        child: Candlesticks(
                          candles: snapshot.data!,
                        ),
                      ),
                      SizedBox(height: 30),
                      // Displaying OHLC statistics
                      StatisticsRow(
                          title: 'Open',
                          value: '\$${latestData.open.toStringAsFixed(2)}'),
                      StatisticsRow(
                          title: 'High',
                          value: '\$${latestData.high.toStringAsFixed(2)}'),
                      StatisticsRow(
                          title: 'Low',
                          value: '\$${latestData.low.toStringAsFixed(2)}'),
                      StatisticsRow(
                          title: 'Close',
                          value: '\$${latestData.close.toStringAsFixed(2)}'),
                      // Placeholder for other statistics
                      StatisticsRow(title: 'Volume', value: '---'),
                      StatisticsRow(title: 'Market Cap', value: '---'),
                      SizedBox(height: 24),
                      // BUY and SELL action buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ActionButton(
                              title: 'SELL',
                              color: Colors.red,
                              onPressed: () {
                                // Implement sell functionality
                              }),
                          ActionButton(
                              title: 'BUY',
                              color: Colors.green,
                              onPressed: () {
                                // Implement buy functionality
                              }),
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
    );
  }
}

class StatisticsRow extends StatelessWidget {
  final String title;
  final String value;

  const StatisticsRow({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(color: Colors.white, fontSize: 18)),
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
        backgroundColor: color,
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
