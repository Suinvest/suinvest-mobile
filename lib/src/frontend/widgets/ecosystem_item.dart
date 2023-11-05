// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sui/sui.dart';
import 'package:suiinvest/src/frontend/common/helpers/string.dart';

class EcosystemItem extends StatelessWidget {
  final String label;
  final String value;
  final String? change;
  final Widget? chart;

  EcosystemItem({
    required this.label,
    required this.value,
    this.change,
    this.chart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 8.0), // Adjust spacing between items
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Color.fromARGB(255, 47, 46, 46)!),
      ),
      child: IntrinsicHeight(
        // Ensures the container fits its content in height
        child: Row(
          children: [
            Expanded(
              // Use Expanded to fill the available horizontal space
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label,
                        style: TextStyle(
                            color: const Color.fromRGBO(187, 205, 255, 0.702),
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold)),
                    Text(value,
                        style: TextStyle(color: Colors.white, fontSize: 16.0)),
                    if (change != null) ...[
                      Text(change!,
                          style: TextStyle(color: Colors.red, fontSize: 14.0)),
                    ],
                  ],
                ),
              ),
            ),
            if (chart != null)
              chart!, // If a chart is provided, display it here
          ],
        ),
      ),
    );
  }
}

Widget buildHealth(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0), // Consistent padding with other elements
        child: Text(
          'Ecosystem Health',
          style: TextStyle(
              color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(height: 16.0),
      EcosystemItem(
        label: 'Market Cap',
        value: '\$356,104,841',
      ),
      EcosystemItem(label: 'Price', value: '\$0.418026'
          // change:
          //     '-12.4%', // Optional: only add this if you want to show the change
          ),
      EcosystemItem(
        label: '24hr Trading Vol',
        value: '\$29,026,989',
      ),
      EcosystemItem(
        label: 'Fully Diluted Valuation',
        value: '\$4,138,862,797',
      ),
      EcosystemItem(
        label: 'Circulating Supply',
        value: '\$860,392,9597',
      ),
    ],
  );
}
