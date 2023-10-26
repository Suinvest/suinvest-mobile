// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class PriceHistoryPage extends StatefulWidget {
//   @override
//   _PriceHistoryPageState createState() => _PriceHistoryPageState();
// }

// class _PriceHistoryPageState extends State<PriceHistoryPage> {
//   String _selectedTimeframe = '1D';
//   List<Map<String, dynamic>> _assets = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchAssets();
//   }

//   Future<void> _fetchAssets() async {
//     final response = await http.get(Uri.parse('https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd'));
//     final data = jsonDecode(response.body);
//     setState(() {
//       _assets = List<Map<String, dynamic>>.from(data.map((asset) => {
//         'name': asset['name'],
//         'symbol': asset['symbol'],
//         'price': asset['current_price'],
//         'change': asset['price_change_percentage_24h'],
//       }));
//     });
//   }

//   List<DropdownMenuItem<String>> _buildTimeframeDropdownItems() {
//     return ['1D', '1W', '1M', '1Y'].map((timeframe) {
//       return DropdownMenuItem<String>(
//         value: timeframe,
//         child: Text(timeframe),
//       );
//     }).toList();
//   }

//   Widget _buildPriceGraph() {
//     // TODO: Implement price graph
//     return Container();
//   }

//   Widget _buildAssetList() {
//     return ListView.builder(
//       itemCount: _assets.length,
//       itemBuilder: (context, index) {
//         final asset = _assets[index];
//         return ListTile(
//           title: Text('${asset['name']} (${asset['symbol'].toUpperCase()})'),
//           subtitle: Text('\$${asset['price']}'),
//           trailing: Text('${asset['change'].toStringAsFixed(2)}%'),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('On-Chain'),
//       ),
//       body: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Price Graph'),
//               DropdownButton<String>(
//                 value: _selectedTimeframe,
//                 items: _buildTimeframeDropdownItems(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedTimeframe = value!;
//                   });
//                 },
//               ),
//             ],
//           ),
//           Expanded(
//             child: _buildPriceGraph(),
//           ),
//           SizedBox(height: 16),
//           Text('Assets'),
//           Expanded(
//             child: _buildAssetList(),
//           ),
//         ],
//       ),
//     );
//   }
// }
