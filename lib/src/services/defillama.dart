import 'package:http/http.dart' as http;
import 'dart:convert';

const defillamaBaseUrl = 'https://api.llama.fi';

class TVLTimestamp {
  final int timestamp;
  final double tvl;

  const TVLTimestamp({
    required this.timestamp,
    required this.tvl,
  });
}

class DEXVolume {
  final int defillamaId;
  final String name;
  final String displayName;
  final String logo;
  final double change_1m;
  final double change_1d;
  final double change_7d;
  final double total24h;
  final double dailyVolume;
  final double totalVolume7d;
  final double totalVolume30d;
  final double totalAllTime;
  
  const DEXVolume({
    required this.defillamaId,
    required this.name,
    required this.displayName,
    required this.logo,
    required this.change_1m,
    required this.change_1d,
    required this.change_7d,
    required this.total24h,
    required this.dailyVolume,
    required this.totalVolume7d,
    required this.totalVolume30d,
    required this.totalAllTime,
  });
}

class SUIData {
  final List<TVLTimestamp> tvlHistory;
  final List<DEXVolume> dexVolumes;
  // final dynamic protocolsFees;

  const SUIData({
    required this.tvlHistory,
    required this.dexVolumes,
    // required this.protocolsFees,
  });
}


Future<SUIData?> fetchSUIData() async {
  final dexVolsResponse = await http.get(Uri.parse('${defillamaBaseUrl}/overview/dexs/sui'));
  // final protocolsFeesResponse = await http.get(Uri.parse('${defillamaBaseUrl}/overview/fees/sui'));

  final tvlHistoryResponse = await http.get(Uri.parse('${defillamaBaseUrl}/v2/historicalChainTvl/sui'));
  if (tvlHistoryResponse.statusCode == 200 && dexVolsResponse.statusCode == 200) {
    final dexVolsJson = json.decode(dexVolsResponse.body);
    // final protocolsFeesJson = json.decode(protocolsFeesResponse.body);
    final tvlHistory = json.decode(tvlHistoryResponse.body);
    final dexVols = dexVolsJson['protocols'];
    
    return SUIData(tvlHistory: tvlHistory, dexVolumes: dexVols);
  } else {
    throw Exception('Failed to load coins');
  }
}