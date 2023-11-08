import 'package:coingecko_api/coingecko_api.dart';
import 'package:coingecko_api/data/market.dart';
import 'package:coingecko_api/data/market_chart_data.dart';

Future<List<Market>?> fetchCoinPrices(
    List<String> coinIds, String currency) async {
  final api = CoinGeckoApi();
  final result = await api.coins.listCoinMarkets(
    vsCurrency: currency,
    coinIds: coinIds,
  );
  if (!result.isError) {
    return result.data;
  } else {
    print('${result.errorCode}: ${result.errorMessage}');
  }
  return null;
}

Future<List<MarketChartData>?> fetchCoinHistory(
    String coinId, String currency, int priorDays) async {
  final api = CoinGeckoApi();
  final result = await api.coins.getCoinMarketChart(
    id: coinId,
    vsCurrency: currency,
    days: priorDays,
  );
  if (!result.isError) {
    return result.data;
  } else {
    print('${result.errorCode}: ${result.errorMessage}');
  }
  return null;
}
