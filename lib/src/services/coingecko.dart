import 'package:coingecko_api/coingecko_api.dart';

class CoingeckoService {
  static Future<List<dynamic>?> getPrice(
      String coinId, String currency, int days) async {
    final api = CoinGeckoApi();
    print('Calling method getCoinOHLC() ...');
    final result = await api.coins.getCoinOHLC(
      id: coinId,
      vsCurrency: currency,
      days: days,
    );
    if (!result.isError) {
      print('getCoinOHLC() results:');
      result.data.forEach(
        (item) => print(
            '${item.timestamp}: open = ${item.open}, high = ${item.high}, low = ${item.low}, close = ${item.close}'),
      );
      return result.data;
    } else {
      print('getCoinOHLC() method returned error:');
      print('${result.errorCode}: ${result.errorMessage}');
      print('Test method failed.');
    }
    return null;
  }
}
