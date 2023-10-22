import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 16),
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                _buildCard(context, 'Card 1', '123'),
                _buildCard(context, 'Card 2', '456'),
                _buildCard(context, 'Card 3', '789'),
                _buildCard(context, 'Card 4', '101'),
                _buildCard(context, 'Card 5', '112'),
                _buildCard(context, 'Card 6', '131'),
              ],
            ),
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
}
