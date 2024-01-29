import 'package:flutter/material.dart';

// KeyPad widget for token exchange page
class NumPad extends StatelessWidget {
  final double buttonSize;
  final TextEditingController controller;
  final Function delete;

  const NumPad({
    Key? key,
    this.buttonSize = 70,
    required this.delete,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // implement the number keys (from 0 to 9) with the NumberButton widget
            // the NumberButton widget is defined in the bottom of this file
            children: [
              NumberButton(
                number: '1',
                size: buttonSize,
                controller: controller,
                onPressed: () {
                  controller.text += '1';
                },
              ),
              NumberButton(
                number: '2',
                size: buttonSize,
                controller: controller,
                onPressed: () {
                  controller.text += '2';
                },
              ),
              NumberButton(
                number: '3',
                size: buttonSize,
                controller: controller,
                onPressed: () {
                  controller.text += '3';
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NumberButton(
                number: '4',
                size: buttonSize,
                controller: controller,
                onPressed: () {
                  controller.text += '4';
                },
              ),
              NumberButton(
                number: '5',
                size: buttonSize,
                controller: controller,
                onPressed: () {
                  controller.text += '5';
                },
              ),
              NumberButton(
                number: '6',
                size: buttonSize,
                controller: controller,
                onPressed: () {
                  controller.text += '6';
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NumberButton(
                number: '7',
                size: buttonSize,
                controller: controller,
                onPressed: () {
                  controller.text += '7';
                },
              ),
              NumberButton(
                number: '8',
                size: buttonSize,
                controller: controller,
                onPressed: () {
                  controller.text += '8';
                },
              ),
              NumberButton(
                number: '9',
                size: buttonSize,
                controller: controller,
                onPressed: () {
                  controller.text += '9';
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // this button is used to delete the last number
              NumberButton(
                number:
                    '.', // Pass in a String type instead, and modify NumberButton to accept it
                size: buttonSize,
                controller: controller,
                onPressed: addDecimal, // Pass the addDecimal method
              ),
              NumberButton(
                number: '0',
                size: buttonSize,
                controller: controller,
                onPressed: () {
                  controller.text += '0';
                },
              ),
              // this button is used to submit the entered value

              IconButton(
                onPressed: () => delete(),
                icon: const Icon(
                  Icons.backspace_outlined,
                  size: 28,
                  color: Colors.white,
                ),
                iconSize: buttonSize,
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  void addDecimal() {
    String currentText = controller.text;
    if (!currentText.contains('.')) {
      // Append decimal point only if there isn't one already
      if (currentText.isEmpty) {
        // If the current text is empty, add '0.' to it
        controller.text = '0.';
      } else {
        // If the current text is not empty, just append '.'
        controller.text += '.';
      }
    }
  }
}

class NumberButton extends StatelessWidget {
  final String number; // Changed to String to accommodate numbers and '.'
  final double size;
  final TextEditingController controller;
  final VoidCallback
      onPressed; // Add this to handle custom actions like the decimal

  const NumberButton({
    Key? key,
    required this.number,
    required this.size,
    required this.controller,
    required this.onPressed, // Add this parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: TextButton(
        style: TextButton.styleFrom(
          // Remove minimum size constraints
          minimumSize: Size.zero,
          // Remove padding
          padding: EdgeInsets.zero,
          // Make background color transparent
          backgroundColor: Colors.transparent,
          // Make tap splash color transparent
          splashFactory: NoSplash.splashFactory,
          // Make overlay color (highlight color) transparent
        ),
        onPressed: () {
          onPressed(); // Call the onPressed callback
        },
        child: Text(
          number.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // or any other color you want for the text
            fontSize: 23,
          ),
        ),
      ),
    );
  }
}
