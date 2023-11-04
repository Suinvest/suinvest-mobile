import 'dart:convert';
import 'package:sui/sui.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;

final client = SuiClient(Constants.mainnetAPI);

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

Future<String> swap(userAccount, poolA, poolB, byAmountIn, amount, amountLimit) async {
  // this is the package ID address of the integrate contract on testnet
  var packageObjectId = FlutterConfig.get("CETUS_INTEGRATE_PACKAGE_ID");
  var globalConfigId = FlutterConfig.get("CETUS_GLOBAL_CONFIG_ID");
  var swapCountUrl = FlutterConfig.get("CETUS_SWAP_COUNT_URL");

  var cetusResponse = await http.get(Uri.parse(swapCountUrl));
  if (cetusResponse.statusCode != 200) {
    throw Exception('Failed to load data');
  }
  var cetusResponseBody = json.decode(cetusResponse.body);

  // find correct pool - example of pool name: "USDT-USDC"
  var pools = cetusResponseBody.data.pools;
  dynamic desiredPool;
  pools.forEach((pool) {
    if (pool.symbol == "$poolA-$poolB") {
      desiredPool = pool;
    }
  });
  if (desiredPool == null) {
    throw Exception('Could not find pool');
  }

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

  // TODO: support swapping from b to a, handle logic of byAmountIn too  
  tx.moveCall("$packageObjectId::pool_script::swap_a2b", arguments: [
    tx.pure(globalConfigId), // config: &GlobalConfig,
    tx.pure(desiredPool.swap_account), // pool: &mut Pool<CoinTypeA, CoinTypeB>,
    coinsAVec, // coins_a: vector<Coin<CoinTypeA>>,
    tx.pure(byAmountIn), // by_amount_in: bool,
    tx.pure(amount), // amount: u64,
    tx.pure(amountLimit), // amount_limit: u64,
    tx.pure(4295048016), // sqrt_price_limit: u128,
    tx.pure("0x6") // clock: &Clock
    // do we need to include ctx: &mut TxContext here?
    // it is not a variable on https://suiexplorer.com/object/0x8627c5cdcd8b63bc3daa09a6ab7ed81a829a90cafce6003ae13372d611fbb1a9?module=pool_script&network=testnet
    // but it is a variable on https://github.com/CetusProtocol/cetus-clmm-interface/blob/577fd059bdf9c7d7c1787e1ff233cda5a8b63c44/README.md?plain=1#L904
  ]);

  final result = await client.signAndExecuteTransactionBlock(userAccount, tx);
  return result.digest;
}
