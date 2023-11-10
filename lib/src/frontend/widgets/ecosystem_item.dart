// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sui/sui.dart';

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
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label,
                        style: TextStyle(
                          color: const Color.fromRGBO(187, 205, 255, 100),
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        )),
                    Text(value,
                        style: TextStyle(color: Colors.white, fontSize: 16.0)),
                  ],
                ),
              ),
            ),
            if (change != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  change!,
                  style: TextStyle(color: Colors.red, fontSize: 16.0),
                ),
              ),
            if (chart != null)
              chart!, // This assumes your chart is already sized appropriately.
          ],
        ),
      ),
    );
  }
}

Widget buildHealth(BuildContext context, Map<String, dynamic> healthData) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          'Ecosystem Health',
          style: TextStyle(
              color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(height: 16.0),
      EcosystemItem(
        label: 'Market Cap',
        value:
            healthData['Market Cap'] ?? 'N/A', // Use data from healthData map
        // chart: buildGreenChart(), // Commented out, assuming this is built elsewhere or not included
      ),
      EcosystemItem(
        label: 'Price',
        value: healthData['Price'] ?? 'N/A',
        change: healthData['Price Change'] ??
            'N/A', // Adjust key as per your API response
      ),
      EcosystemItem(
        label: '24hr Trading Vol',
        value: healthData['24hr Trading Vol'] ?? 'N/A',
      ),
      EcosystemItem(
        label: 'Fully Diluted Valuation',
        value: healthData['Fully Diluted Valuation'] ?? 'N/A',
      ),
      EcosystemItem(
        label: 'Circulating Supply',
        value: healthData['Circulating Supply'] ?? 'N/A',
      ),
    ],
  );
}
