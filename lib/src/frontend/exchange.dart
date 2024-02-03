// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sui/sui_account.dart';
import 'package:suiinvest/src/common/constants/colors.dart';
import 'package:suiinvest/src/frontend/widgets/num_pad.dart';
import 'package:suiinvest/src/services/sui.dart';
import 'package:suiinvest/src/common/constants/coins.dart';
import 'package:url_launcher/url_launcher.dart';

class ExchangePage extends StatefulWidget {
  final SuiAccount userAccount;
  final Map<String, dynamic>? input;

  const ExchangePage({Key? key, required this.userAccount, this.input})
      : super(key: key);

  _ExchangePageState createState() => _ExchangePageState();
}

Coin getCoinBySymbol(String symbol) {
  return COINS.firstWhere(
    (coin) => coin.coinGeckoId == symbol,
    orElse: () => COINS[0], // Default to the first coin if not found
  );
}

@override
class _ExchangePageState extends State<ExchangePage> {
  final TextEditingController _myController = TextEditingController(text: '0');
  Coin swapFrom = COINS[0];
  Coin swapTo = COINS[1];
  bool backArrowCheck = false;

  @override
  void initState() {
    super.initState();
    _myController.addListener(_onNumberChanged);

    // Default values
    swapFrom = COINS.first;
    swapTo = COINS[1];

    if (widget.input != null &&
        widget.input!['action'] == 'sell' &&
        widget.input!['coinId'] != null) {
      backArrowCheck = true;
      swapFrom = getCoinBySymbol(widget.input!['coinId']);

      swapTo = COINS[0];
    } else if (widget.input != null &&
        widget.input!['action'] == 'buy' &&
        widget.input!['coinId'] != null) {
      backArrowCheck = true;
      swapFrom = COINS[0];
      swapTo = getCoinBySymbol(widget.input!['coinId']);
    }
  }

  void _onNumberChanged() {
    String text = _myController.text;
    // If the first character is '0' and the length of the text is greater than 1,
    // this means that a new number has been entered. Replace the '0' with the new number.
    if (text.startsWith('0') && text.length > 1) {
      text = text.substring(1);
      _myController.text = text;
      // Set the cursor at the end of the new input
      _myController.selection = TextSelection.fromPosition(
        TextPosition(offset: _myController.text.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: backArrowCheck
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        title: const Text(
          'Exchange',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            'Account ${_formattedAddress(widget.userAccount.getAddress())}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          _buildDropdownButton('From', swapFrom, (newValue) {
            setState(() => swapFrom = newValue!);
          }),
          _buildTextField(),
          _buildArrowDivider(),
          _buildDropdownButton('To', swapTo, (newValue) {
            setState(() => swapTo = newValue!);
          }),
          const SizedBox(height: 10),
          _buildNumPad(),
          const SizedBox(height: 30),
          _buildSwapButton(
              swapFrom == COINS[0] ? swapTo : swapFrom, swapFrom == COINS[0]),
        ],
      ),
    );
  }

  String _formattedAddress(String address) {
    return '0x${address.substring(0, 7)}....${address.substring(address.length - 5)}';
  }

  Widget _buildDropdownButton(
      String label, Coin value, ValueChanged<Coin?> onChanged) {
    return DropdownButton<Coin>(
      dropdownColor: AppColors.backgroundGrey,
      style: const TextStyle(
          color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
      value: value,
      items: COINS.map((Coin coin) {
        return DropdownMenuItem<Coin>(
          value: coin,
          child: Text(coin.symbol),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _myController,
      textAlign: TextAlign.center,
      showCursor: false,
      style: const TextStyle(fontSize: 40, color: Colors.white),
      keyboardType: TextInputType.none,
      decoration: const InputDecoration(border: InputBorder.none),
    );
  }

  Widget _buildArrowDivider() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(
                    left: 10.0, right: 5.0, top: 0, bottom: 0),
                child: const Divider(
                  color: Colors.white,
                  height: 20,
                  thickness: 1,
                ),
              ),
            ),
            GestureDetector(
              onTap: _swapCoins, // Method to swap coins when the icon is tapped
              child: const Icon(
                Icons.swap_vert,
                color: AppColors.buttonBlue,
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 5.0, right: 10.0),
                child: const Divider(
                  color: Colors.white,
                  height: 20,
                  thickness: 1,
                ),
              ),
            ),
          ],
        ));
  }

  void _swapCoins() {
    setState(() {
      final temp = swapFrom;
      swapFrom = swapTo;
      swapTo = temp;
    });
  }

  Widget _buildNumPad() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: AppColors.backgroundGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: NumPad(
        buttonSize: 40,
        controller: _myController,
        delete: _handleNumPadDelete,
      ),
    );
  }

  void _handleNumPadDelete() {
    if (_myController.text.isNotEmpty) {
      setState(() {
        _myController.text =
            _myController.text.substring(0, _myController.text.length - 1);
      });
    }
  }

  Widget _buildSwapButton(Coin selectedCoin, bool isSUISwapIn) {
    String result;
    String url;

    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(AppColors.buttonBlue),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      onPressed: () async => {
        result = await routeSwaps(widget.userAccount, selectedCoin, isSUISwapIn,
            _myController.text != "" ? double.parse(_myController.text) : 0),
        url = "https://suiexplorer.com/txblock/",
        print("ZZZZZZZZZZ"),
        print(result),
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text('Swap Successful!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.green)),
                content: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(text: 'View the transaction '),
                      TextSpan(
                        text: 'here.',
                        style: TextStyle(
                            color: AppColors.buttonBlue,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            handleLinkTap(url +
                                result); // Make sure to import 'package:url_launcher/url_launcher.dart';
                          },
                      ),
                    ],
                  ),
                ));
          },
        )
      },
      child: const Text(
        'SWAP',
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }

  void _handleSwap() {
    debugPrint('Your code: ${_myController.text}');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(
          "You code is ${_myController.text}",
          style: const TextStyle(fontSize: 30),
        ),
      ),
    );
  }

  void handleLinkTap(url) {
    final Uri url = Uri.parse("https://suiexplorer.com/txblock/");
    launchUrl(url);
  }
}
