import 'package:coingecko_api/coingecko_api.dart';
import 'package:coingecko_api/data/market.dart';

Future<List<Market>?> fetchCoinPrices(
      List<String> coinIds, String currency) async {
    final api = CoinGeckoApi();
    print('fetching coinIds in fetchCoinPrices()');
    print(coinIds);
    final result = await api.coins.listCoinMarkets(
      vsCurrency: currency,
      coinIds: coinIds,
    );
    print('response of coin data in fetchCoinPrices()');
    print(result);
    if (!result.isError) {
      return result.data;
    } else {
      print('getCoinOHLC() method returned error:');
      print('${result.errorCode}: ${result.errorMessage}');
      print('Test method failed.');
    }
    return null;
  }
