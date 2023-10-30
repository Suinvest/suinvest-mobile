import 'package:flutter/material.dart';
import 'package:sui/sui.dart';
import 'package:sui/cryptography/signature.dart';
import 'package:flutter_config/flutter_config.dart';

// return type is bool of success when we store a key -> secret pair
Future<SuiAccount?> buildUserFromPrivKey(privateKey) async {
  try {
    late SuiAccount account = SuiAccount.fromPrivateKey(privateKey, SignatureScheme.ED25519);
    return account;
  } on Exception catch (exception) {
    print(exception);
    return null;
  }
}

class SuiTest extends StatefulWidget {
  const SuiTest({Key? key, required this.title}): super(key: key);

  final String title;

  @override
  State<SuiTest> createState() => _SuiTestState();
}

class _SuiTestState extends State<SuiTest> {
  BigInt _balance = BigInt.zero;
  late SuiAccount account = SuiAccount.fromPrivateKey(FlutterConfig.get("SUI_PRIVATE_KEY"), SignatureScheme.ED25519);
  late SuiClient suiClient = SuiClient(Constants.mainnetAPI, account: account);
  void _getBalance() async {
    var resp = await suiClient.getBalance(account.getAddress());
    print(account.getAddress());

    _balance = resp.totalBalance;
    await Future.delayed(const Duration(seconds: 2));

    resp = await suiClient.getBalance(account.getAddress());
    _balance = resp.totalBalance;

    setState(() {
      _balance = _balance;
    });
  }

  // void _navigateToTokenManage() {
  //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => TokenMenu(client: suiClient)));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Column(
            children: <Widget>[
              Text(
                '${_balance.toString()} SUI',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _getBalance, child: const Text("Faucet")),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: SelectableText(account.getAddress()),
              )
            ],
          ),
        ),
      ),
    );
  }
}