// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.black, // Sets the background color of the Scaffold
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment
                .center, // Centers the column in the available space vertically
            crossAxisAlignment: CrossAxisAlignment
                .stretch, // Stretches the children across the horizontal axis
            children: [
              Text(
                'Welcome to Sui-Invest',
                textAlign: TextAlign.center, // Centers the text horizontally
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0, // Sets the font size of the text
                  fontWeight:
                      FontWeight.bold, // Sets the font weight of the text
                ),
              ),
              SizedBox(
                  height: 32.0), // Adds space between the text and the button
              Text(
                'Face ID failed, login with private key',
                textAlign: TextAlign.center, // Centers the text horizontally
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16.0, // Sets the font size of the text
                ),
              ),
              SizedBox(
                  height: 32.0), // Adds space between the text and the button
              SizedBox(height: 16.0), // Adds space between the buttons
              TextField(
                style: TextStyle(
                    color: Colors
                        .white), // Sets the text color inside the text field
                decoration: InputDecoration(
                  hintText: 'Enter Private Key',
                  hintStyle: TextStyle(
                      color: Colors.grey, fontStyle: FontStyle.italic),
                  filled: true,
                  fillColor:
                      Colors.grey[850], // Sets the fill color of the text field
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide
                        .none, // Removes the border around the text field
                  ),
                ),
              ),
              SizedBox(
                  height:
                      16.0), // Adds space between the text field and the button
              TextButton(
                onPressed: () {
                  // Implement navigation logic to create account screen
                },
                child: Text('Login'),
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF698FF6),
                  foregroundColor: Colors
                      .white, // Sets the color of the text inside the button
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
