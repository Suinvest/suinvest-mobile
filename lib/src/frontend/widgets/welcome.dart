import 'package:flutter/material.dart';
import 'package:sui/sui.dart';
import 'package:suiinvest/src/common/helpers/string.dart';

Widget Welcome(BuildContext context, SuiAccount userAccount) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Welcome Back!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            const Text(
              'Hi, ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            Text(
              trimUserAddress(userAccount.getAddress(), 6, 3),
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
