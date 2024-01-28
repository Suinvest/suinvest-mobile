import 'package:flutter/material.dart';
import 'package:sui/sui_account.dart';
import 'package:suiinvest/src/common/constants/colors.dart';
import 'package:suiinvest/src/frontend/widgets/num_pad.dart';
import 'package:suiinvest/src/services/sui.dart';
import 'package:suiinvest/src/common/constants/coins.dart';

class ExchangePage extends StatefulWidget {
  final SuiAccount userAccount;
  final Map<String, dynamic>? input;

  const ExchangePage({Key? key, required this.userAccount, this.input})
      : super(key: key);

  _ExchangePageState createState() => _ExchangePageState();
}

Coin getCoinBySymbol(String symbol) {
  return COINS.firstWhere(
    (coin) => coin.symbol == symbol,
    orElse: () => COINS[0], // Default to the first coin if not found
  );
}

@override
class _ExchangePageState extends State<ExchangePage> {
  final TextEditingController _myController = TextEditingController();
  Coin swapFrom = COINS[0];
  Coin swapTo = COINS[1];

  @override
  void initState() {
    super.initState();

    // Default values
    swapFrom = COINS.first;
    swapTo = COINS[1];

    if (widget.input != null &&
        widget.input!['action'] == 'sell' &&
        widget.input!['coinId'] != null) {
      swapFrom = getCoinBySymbol(widget.input!['coinId']);

      swapTo = COINS[0];
    } else if (widget.input != null &&
        widget.input!['action'] == 'buy' &&
        widget.input!['coinId'] != null) {
      swapFrom = COINS[0];
      swapTo = getCoinBySymbol(widget.input!['coinId']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Exchange',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black, // Or any color you want for the AppBar
      ),
      body: Column(
        children: [
          // const Text(
          //   'Exchange',
          //   style: TextStyle(
          //     fontSize: 24,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.white,
          //   ),
          // ),
          const SizedBox(height: 10),
          Text(
            'Account ${_formattedAddress(widget.userAccount.getAddress())}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
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
              swapFrom == COINS[0] ? swapTo : swapFrom,
              swapFrom ==
                  COINS[0]), // last arg tells us if SUI is the source token
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 10.0, right: 5.0),
            child: const Divider(
              color: Colors.white,
              height: 1.5,
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
        const Icon(
          Icons.arrow_downward,
          color: AppColors.buttonBlue,
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 5.0, right: 10.0),
            child: const Divider(
              color: Colors.white,
              height: 1.5,
              thickness: 1,
            ),
          ),
        ),
      ],
    );
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
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(AppColors.buttonBlue),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      onPressed: () => {
        routeSwaps(
            widget.userAccount,
            selectedCoin,
            isSUISwapIn,
            _myController.text != ""
                ? double.parse(_myController.text)
                : 0) // last value is the amount to swap
      },
      child: const Text(
        'SWAP',
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }

  void _handleSwap() {
    // Implement your swap logic here
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
}
