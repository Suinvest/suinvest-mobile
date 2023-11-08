class Coin {
  String address;
  String symbol;
  String name;
  String icon;
  String coinGeckoId;
  int  decimals;

  Coin(
    {
      required this.address,
      required this.symbol,
      required this.name,
      required this.icon,
      required this.coinGeckoId,
      required this.decimals,
      }
  );
}

final SUI = Coin(
  address: "0x2::sui::SUI",
  symbol: "SUI",
  name: "SUI Coin",
  decimals: 10000,
  icon: "SuiToken",
  coinGeckoId: "sui",
);

final CETUS = Coin(
  address: "0x6864a6f921804860930db6ddbe2e16acdf8504495ea7481637a1c8b9a8fe54b::cetus::CETUS",
  symbol: "CETUS",
  name: "CETUS Coin",
  decimals: 10000,
  icon: "CetusToken",
  coinGeckoId: "cetus-protocol",
);

final BLUE_MOVE = Coin(
  address: "0x27fafcc4e39daac97556af8a803dbb52bcb03f0821898dc845ac54225b9793eb::move_coin::MoveCoin",
  symbol: "MOVE",
  name: "BlueMove",
  decimals: 10000,
  icon: "MoveToken",
  coinGeckoId: "bluemove",
);




final List<Coin> COINS = [
  SUI,
  CETUS,
  BLUE_MOVE
];