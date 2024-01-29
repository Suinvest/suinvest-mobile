import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
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
                style: const TextStyle(color: Colors.white, fontSize: 18.0),
              ),
              const SizedBox(width: 12.0),
              Image.network(
                iconUrl,
                width: 24, // Set your preferred width for the icon
                height: 24, // Set your preferred height for the icon
              ), // Placeholder icon
              const SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                  Text(
                    symbol,
                    style: const TextStyle(color: Colors.grey),
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
                style: const TextStyle(color: Colors.white, fontSize: 16.0),
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
