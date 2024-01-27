import 'package:flutter/material.dart';

Widget buildPortfolio(BuildContext context, String portfolioValue) {
  return Center(
    child: Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(50, 99, 234, 1),
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
          const SizedBox(height: 8.0),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: '$portfolioValue ', // Dynamic portfolio value
                  style: const TextStyle(
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
