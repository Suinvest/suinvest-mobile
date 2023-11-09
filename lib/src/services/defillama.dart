import 'package:http/http.dart' as http;
import 'dart:convert';

const defillamaBaseUrl = 'https://api.llama.fi';


class CryptoListItem {
  final int dailyChange;
  final String name;
  final String symbol;
  final String price;
  final String change;
  final String iconUrl;

  const CryptoListItem({
    required this.rank,
    required this.name,
    required this.symbol,
    required this.price,
    required this.change,
    required this.iconUrl,
  });
}


Future<List<SUIData>?> fetchSUIData() async {
    print ("fetching data");
    final response = await http.get(Uri.parse('${defillamaBaseUrl}/overview/dexs/sui'));
  if (response.statusCode == 200) {
    final res = json.decode(response.body);
    final protocols = res['protocols'];
    print (protocols);

    protocols.forEach((protocol) {
      print (protocol['name']);
    });
    return ["re"];
  } else {
    throw Exception('Failed to load coins');
  }
}