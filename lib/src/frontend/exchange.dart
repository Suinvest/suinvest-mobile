import 'package:flutter/material.dart';
import 'package:sui/sui_account.dart';
import 'package:suiinvest/src/frontend/widgets/num_pad.dart';

class ExchangePage extends StatefulWidget {
  final SuiAccount userAccount;

  // Constructor
  ExchangePage({required this.userAccount});

  @override
  _ExchangePageState createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage> {
  final TextEditingController _myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Exchange',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(
              'Account ${widget.userAccount.getAddress()}'), // Use the userAccount from the state
          SizedBox(height: 30),
          // insert widget here for
          DropdownButton<String>(
            items: <String>['ETH', 'BTC', 'LTC'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (_) {
              // Handle token change
            },
          ),
          TextField(
            controller: _myController,
            textAlign: TextAlign.center,
            showCursor: false,
            style: const TextStyle(fontSize: 40),
            // Disable the default soft keybaord
            keyboardType: TextInputType.none,
          ), // Display the current input amount
          DropdownButton<String>(
            items: <String>['ETH', 'BTC', 'LTC'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (_) {
              // Handle token change
            },
          ),
          NumPad(
            buttonSize: 75,
            buttonColor: Colors.purple,
            iconColor: Colors.deepOrange,
            controller: _myController,
            delete: () {
              _myController.text = _myController.text
                  .substring(0, _myController.text.length - 1);
            },
            // do something with the input numbers
            onSubmit: () {
              debugPrint('Your code: ${_myController.text}');
              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                        content: Text(
                          "You code is ${_myController.text}",
                          style: const TextStyle(fontSize: 30),
                        ),
                      ));
            },
          ),
          // ... other widgets ...
        ],
      ),
    );
  }
}
