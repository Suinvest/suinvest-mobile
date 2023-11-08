class Coin {
  String address;
  String symbol;
  String name;
  String icon;
  String coinGeckoId;
  int decimals;

  Coin({
    required this.address,
    required this.symbol,
    required this.name,
    required this.icon,
    required this.coinGeckoId,
    required this.decimals,
  });
}

final SUI = Coin(
  address: "0x0000000000000000000000000000000000000000000000000000000000000002::sui::SUI",
  symbol: "SUI",
  name: "Sui",
  decimals: 9,
  icon: "https://assets.coingecko.com/coins/images/26375/standard/sui_asset.jpeg",
  coinGeckoId: "sui"
);

final CETUS = Coin(
  address: "0x06864a6f921804860930db6ddbe2e16acdf8504495ea7481637a1c8b9a8fe54b::cetus::CETUS",
  symbol: "CETUS",
  name: "Cetus Token",
  decimals: 9,
  icon: "https://assets.coingecko.com/coins/images/30256/standard/cetus.png",
  coinGeckoId: "cetus-protocol"
);

final USDC = Coin(
  address: "0x5d4b302506645c37ff133b98c4b50a5ae14841659738d6d733d59d0d217a93bf::coin::COIN",
  symbol: "USDC",
  name: "USD Coin",
  decimals: 6,
  icon: "https://assets.coingecko.com/coins/images/6319/standard/usdc.png",
  coinGeckoId: "usdc"
);

final USDT = Coin(
  address: "0xc060006111016b8a020ad5b33834984a437aaa7d3c74c18e09a95d48aceab08c::coin::COIN",
  symbol: "USDT",
  name: "Tether USD",
  decimals: 6,
  icon: "https://assets.coingecko.com/coins/images/325/standard/Tether.png",
  coinGeckoId: "tether"
);

final WETH = Coin(
  address: "0xaf8cd5edc19c4512f4259f0bee101a40d41ebed738ade5874359610ef8eeced5::coin::COIN",
  symbol: "WETH",
  name: "Wrapped ETH",
  decimals: 8,
  icon: "https://assets.coingecko.com/coins/images/279/standard/ethereum.png",
  coinGeckoId: "weth"
);

final SUIA = Coin(
  address: "0x1d58e26e85fbf9ee8596872686da75544342487f95b1773be3c9a49ab1061b19::suia_token::SUIA_TOKEN",
  symbol: "SUIA",
  name: "Suia.io Token",
  decimals: 9,
  icon: "https://assets.coingecko.com/coins/images/30385/standard/suia.jpg",
  coinGeckoId: "suia"
);

final SUIP = Coin(
  address: "0xe4239cd951f6c53d9c41e25270d80d31f925ad1655e5ba5b543843d4a66975ee::SUIP::SUIP",
  symbol: "SUIP",
  name: "SuiPad",
  decimals: 9,
  icon: "https://assets.coingecko.com/coins/images/30284/standard/25100.png",
  coinGeckoId: "suipad"
);

final WSOL = Coin(
  address: "0xb7844e289a8410e50fb3ca48d69eb9cf29e27d223ef90353fe1bd8e27ff8f3f8::coin::COIN",
  symbol: "WSOL",
  name: "Wrapped SOL",
  decimals: 8,
  icon: "https://assets.coingecko.com/coins/images/4128/standard/solana.png",
  coinGeckoId: "solana"
);

final REAP = Coin(
  address: "0xde2d3e02ba60b806f81ee9220be2a34932a513fe8d7f553167649e95de21c066::reap_token::REAP_TOKEN",
  symbol: "REAP",
  name: "Releap Token",
  decimals: 9,
  icon: "https://assets.coingecko.com/coins/images/31161/standard/Releap_logomark_color_%281%29.png",
  coinGeckoId: "releap"
);

final WBTC = Coin(
  address: "0x027792d9fed7f9844eb4839566001bb6f6cb4804f66aa2da6fe1ee242d896881::coin::COIN",
  symbol: "WBTC",
  name: "Wrapped BTC",
  decimals: 8,
  icon: "https://assets.coingecko.com/coins/images/7598/standard/wrapped_bitcoin_wbtc.png",
  coinGeckoId: "wrapped-bitcoin"
);

final WMATIC = Coin(
  address: "0xdbe380b13a6d0f5cdedd58de8f04625263f113b3f9db32b3e1983f49e2841676::coin::COIN",
  symbol: "WMATIC",
  name: "Wrapped MATIC",
  decimals: 8,
  icon: "https://assets.coingecko.com/coins/images/14073/standard/matic.png",
  coinGeckoId: "wmatic"
);

final WBNB = Coin(
  address: "0xb848cce11ef3a8f62eccea6eb5b35a12c4c2b1ee1af7755d02d7bd6218e8226f::coin::COIN",
  symbol: "WBNB",
  name: "Wrapped BNB",
  decimals: 8,
  icon: "https://assets.coingecko.com/coins/images/12591/standard/binance-coin-logo.png",
  coinGeckoId: "wbnb"
);

final SSWP = Coin(
  address: "0x361dd589b98e8fcda9a7ee53b85efabef3569d00416640d2faa516e3801d7ffc::TOKEN::TOKEN",
  symbol: "SSWP",
  name: "Suiswap",
  decimals: 9,
  icon: "https://assets.coingecko.com/coins/images/30688/standard/suiswap-200.png",
  coinGeckoId: "suiswap"
);

// final MED = Coin(
//   address: "0x9a7ca7b6de5b6e9a4dadec42fada7cd84068aebd7adbd1faeb713622c4628ca9::meadow::MEADOW",
//   symbol: "",
//   name: "",
//   decimals: 0,
//   icon: "",
//   coinGeckoId: ""
// );

// final SBOX = Coin(
//   address: "0xbff8dc60d3f714f678cd4490ff08cabbea95d308c6de47a150c79cc875e0c7c6::sbox::SBOX",
//   symbol: "",
//   name: "",
//   decimals: 0,
//   icon: "",
//   coinGeckoId: ""
// );

final List<Coin> COINS = [
  SUI,
  CETUS,
  USDC,
  USDT,
  WETH,
  SUIA,
  SUIP,
  WSOL,
  REAP,
  WBTC,
  WMATIC,
  WBNB,
  SSWP,
  // SBOX,
  // MED,
];
