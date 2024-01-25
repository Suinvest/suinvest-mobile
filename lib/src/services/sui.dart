import 'dart:convert';
import 'dart:math';
import 'package:sui/sui.dart';
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
  print("pools");
  print(pools);
  dynamic desiredPool;
  double maxTVL = 0.0;
  pools.forEach((pool) {
    if (pool["token_a_address"] == coin1.address && pool["token_b_address"] == coin2.address) { // TODO: change to mainnet
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

Future<List<dynamic>> getCoinObjectIds(String address, Coins.Coin coin) async {
  final objects = await client.getAllCoins(address);
  final coinIds = objects
    .data
    .where((c) => c.coinType == coin.truncatedAddress)
    .map((y) => y.coinObjectId);

  print("CoinIDs");
  print(coinIds);
  return coinIds.toList();
}

Future<String> swap(SuiAccount? userAccount, Coins.Coin coin1, Coins.Coin coin2, bool isSUISwapIn, int amount) async {
  if (userAccount == null) {
    throw Exception('Failed to fetch userAccount');
  }

  dynamic pool = await getPool(coin1, coin2);
  
  final tx = TransactionBlock();
  print (isSUISwapIn);
  print ("isSUISwapIn");
  var coinsAVec;
  if (isSUISwapIn) { // if SUI is the input, we can leverage tx.gas to get the amount of SUI to swap
    final amountToSwap = tx.splitCoins(tx.gas, [tx.pure(amount)]);
    // print (amountToSwap);
    print ('amountToSwap');
    coinsAVec = tx.makeMoveVec(objects: [amountToSwap]);
    // coinsAVec = tx.makeMoveVec(objects: ["0x2aff8b23f8533c8d37034e7d4ddbbf5b97151f5429aab59772a75be35e8070c3"]);

    print (coinsAVec);
    print ('coinsAVec');
    tx.setSenderIfNotSet(userAccount.getAddress());
  } else {
    var coinObjectIds = await getCoinObjectIds(userAccount.getAddress(), coin1);
    coinsAVec = tx.makeMoveVec(objects: coinObjectIds.map((x) => tx.object(x)));
    tx.setSenderIfNotSet(userAccount.getAddress());
  }

  tx.setGasBudget(BigInt.from(20000000));
  tx.moveCall(
    "$CETUS_INTEGRATE_PACKAGE_ID::pool_script::swap_${isSUISwapIn ? 'b2a' : 'a2b'}",
    typeArguments: [coin1.address, coin2.address],
    arguments: [
      tx.object(CETUS_GLOBAL_CONFIG_ID),    // config: &GlobalConfig,
      tx.object(pool["swap_account"]),      // pool: &mut Pool<CoinTypeA, CoinTypeB>,
      coinsAVec,                            // coins_a: vector<Coin<CoinTypeA>>,
      tx.pureBool(true),                    // by_amount_in: bool,
      tx.pure(amount.toString()),                   // amount: u64,
      tx.pure("0"),            // amount_limit: u64, TODO: make this a real number (this reflects the amount we require to get out in output coin)
      tx.pure(isSUISwapIn ? SQRT_PRICE_LIMIT_B2A : SQRT_PRICE_LIMIT_A2B),         // sqrt_price_limit: u128,
      tx.object(SUI_CLOCK),                 // clock: &Clock*/
  ]);
  print ("ALL GOOD");
  final result = await client.signAndExecuteTransactionBlock(userAccount, tx);
  print("RESTUL");
  print(result.digest);
  return result.digest;
}

Future<List<String>> routeSwaps(SuiAccount? userAccount, Coins.Coin coin, bool isSUISwapIn, double amountIn) async{
  print("here");
  print (coin.symbol);
  print (amountIn);
  print (isSUISwapIn);
  List<String> digests = [];
  String digest1;

  if (isSUISwapIn) {
    // SUI to requested coin, b2a (XXX-SUI pool)
    int trueAmount = (amountIn * pow(10, Coins.SUI.decimals)).toInt();
    digest1 = await swap(userAccount, coin, Coins.SUI, true, trueAmount);
    digests.add(digest1);
  } else {
    // Requested coin to SUI, a2b (XXX-SUI pool)
    int trueAmount = (amountIn * pow(10, coin.decimals)).toInt();
    digest1 = await swap(userAccount, coin, Coins.SUI, false, trueAmount);
    digests.add(digest1);
  }
  
  return digests;
}
