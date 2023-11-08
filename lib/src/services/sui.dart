import 'dart:convert';
import 'dart:math';
import 'package:sui/sui.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import 'package:suiinvest/src/common/constants/addresses.dart';
import 'package:suiinvest/src/common/constants/coins.dart' as Coins;

final SuiClient client = testnet ? SuiClient(Constants.testnetAPI) : SuiClient(Constants.mainnetAPI);

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

Future<dynamic> getPool(Coins.Coin coin1, Coins.Coin coin2) async {
  var cetusResponse = await http.get(Uri.parse(CETUS_SWAP_COUNT_URL));
  if (cetusResponse.statusCode != 200) {
    throw Exception('Failed to load data');
  }
  var cetusResponseBody = await json.decode(cetusResponse.body);
  var pools = cetusResponseBody["data"]["pools"];
  dynamic desiredPool;
  double maxTVL = 0.0;
  pools.forEach((pool) {
    if (pool["token_a_address"] == coin1.address && pool["token_b_address"] == coin2.address) {
      double TVL = double.parse(pool["tvl_in_usd"]);
      if (TVL > maxTVL) {
        desiredPool = pool;
        maxTVL = TVL;
      }
    }
  });
  if (desiredPool == null) {
    throw Exception('Failed to find pool');
  }
  return desiredPool;
}

Future<double> getOtherAmount(Coins.Coin coin, bool buying, double amount) async {
  double output = 0.0;
  if (buying) {
    // SUI -> coin
  } else {
    // coin -> SUI
  }
  return output;
}

Future<String> swap(SuiAccount? userAccount, Coins.Coin coin1, Coins.Coin coin2, bool a2b, int amount) async {
  if (userAccount == null) {
    throw Exception('Failed to fetch userAccount');
  }

  dynamic pool = await getPool(coin1, coin2);
  
  final tx = TransactionBlock();
  tx.setGasBudget(BigInt.from(20000000));

  // Get coin vector (if a2b we need coin1, otherwise coin2)
  var coinsAVec = tx.makeMoveVec(objects: {});

  tx.moveCall("$CETUS_INTEGRATE_PACKAGE_ID::pool_script::swap_${a2b?'a2b':'b2a'}", arguments: [
    tx.object(CETUS_GLOBAL_CONFIG_ID),    // config: &GlobalConfig,
    tx.object(pool["swap_account"]),      // pool: &mut Pool<CoinTypeA, CoinTypeB>,
    coinsAVec,                            // coins_a: vector<Coin<CoinTypeA>>,
    tx.pureBool(true),                    // by_amount_in: bool,
    tx.pureInt(amount),                   // amount: u64,
    tx.pureInt(amount * 1000),            // amount_limit: u64,
    tx.pureInt(SQRT_PRICE_LIMIT),         // sqrt_price_limit: u128,
    tx.object(SUI_CLOCK)                  // clock: &Clock
  ]);

  final result = await client.signAndExecuteTransactionBlock(userAccount, tx);
  return result.digest;
}

Future<List<String>> routeSwaps(SuiAccount? userAccount, Coins.Coin coin, bool buying, double amountIn) async{
  List<String> digests = [];
  String digest1;

  if (buying) {
    // SUI to requested coin, b2a (XXX-SUI pool)
    int trueAmount = (amountIn * pow(10, Coins.SUI.decimals)).toInt();
    digest1 = await swap(userAccount, coin, Coins.SUI, false, trueAmount);
    digests.add(digest1);
  } else {
    // Requested coin to SUI, a2b (XXX-SUI pool)
    int trueAmount = (amountIn * pow(10, coin.decimals)).toInt();
    digest1 = await swap(userAccount, coin, Coins.SUI, true, trueAmount);
    digests.add(digest1);
  }
  
  return digests;
}
