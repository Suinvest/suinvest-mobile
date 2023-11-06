import 'dart:convert';
import 'package:sui/sui.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;

import 'package:suiinvest/src/common/constants/addresses.dart';
 

final client = SuiClient(Constants.mainnetAPI);
final testnetClient = SuiClient(Constants.testnetAPI);

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

// fetch user account data from address and construct a Coins object
Future<List<CoinBalance>?> fetchCoinData(address) async {
  try {
    // TODO: make dynamic when we have an account with coins
    final coins = await client.getAllBalance("0x02a212de6a9dfa3a69e22387acfbafbb1a9e591bd9d636e7895dcfc8de05f331");

    return coins;
  } on Exception catch (exception) {
    print(exception);
    return null;
  }
}

Future<String> swap(SuiAccount? userAccount, String poolA, String poolB, bool byAmountIn, int amount, int amountLimit) async {
  // this is the package ID address of the integrate contract on testnet
  const sqrt_price_limit = 4295048016;
  print ('HERE');
  var cetusResponse = await http.get(Uri.parse(CETUS_SWAP_COUNT_URL));
  print ("HERE@22");
  if (cetusResponse.statusCode != 200) {
    throw Exception('Failed to load data');
  }
  var cetusResponseBody = await json.decode(cetusResponse.body);
  // find correct pool - example of pool name: "USDT-USDC"
  var pools = cetusResponseBody["data"]["pools"];
  print (pools);
  dynamic desiredPool;
  pools.forEach((pool) {
    if (pool["symbol"] == "$poolA-$poolB") {
      desiredPool = pool;
    }
  });
  if (desiredPool == null) {
    throw Exception('Could not find pool');
  }
  print (desiredPool);
  // get pool object
  /* var poolObject = getMoveObject({
    "id": desiredPool.swap_account,
    "options": {
      "showContent": true,
      "showType": true
    }
  }); */

  // get coin vector
  final tx = TransactionBlock();
  var coinsAVec = tx.makeMoveVec(objects: {});

  tx.setGasBudget(BigInt.from(20000000));
  tx.object(desiredPool["swap_account"]);

  // TODO: support swapping from b to a, handle logic of byAmountIn too  
  tx.moveCall("$CETUS_INTEGRATE_PACKAGE_ID::pool_script::swap_a2b", arguments: [
    tx.object(CETUS_GLOBAL_CONFIG_ID), // config: &GlobalConfig,
    tx.object(desiredPool["swap_account"]), // pool: &mut Pool<CoinTypeA, CoinTypeB>,
    coinsAVec, // coins_a: vector<Coin<CoinTypeA>>,
    tx.pureBool(byAmountIn), // by_amount_in: bool,
    tx.pureInt(amount), // amount: u64,
    tx.pureInt(amountLimit), // amount_limit: u64,
    tx.pureInt(sqrt_price_limit), // sqrt_price_limit: u128,
    tx.object(SUI_CLOCK) // clock: &Clock
    // do we need to include ctx: &mut TxContext here?
    // it is not a variable on https://suiexplorer.com/object/0x8627c5cdcd8b63bc3daa09a6ab7ed81a829a90cafce6003ae13372d611fbb1a9?module=pool_script&network=testnet
    // but it is a variable on https://github.com/CetusProtocol/cetus-clmm-interface/blob/577fd059bdf9c7d7c1787e1ff233cda5a8b63c44/README.md?plain=1#L904
  ]);
  print (tx);
  if (userAccount == null) {
    throw Exception('Failed to fetch userAccount');
  }
  print ('HERE1');
  final result = await testnetClient.signAndExecuteTransactionBlock(userAccount, tx);
  print (result.digest);
  return result.digest;
}
