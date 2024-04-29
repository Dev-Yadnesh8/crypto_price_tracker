class CoinDcxModel {
  String? market;
  double? change24Hour;
  double? high;
  double? low;
  double? volume;
  double? lastPrice;
  double? bid;
  double? ask;
  int? timestamp;

  CoinDcxModel(
      {this.market,
        this.change24Hour,
        this.high,
        this.low,
        this.volume,
        this.lastPrice,
        this.bid,
        this.ask,
        this.timestamp});

  CoinDcxModel.fromJson(Map<String, dynamic> json) {
    market = json['market'];
    // Convert string values to doubles
    change24Hour = json['change_24_hour'] != null ? double.tryParse(json['change_24_hour'].toString()) : null;
    high = json['high'] != null ? double.tryParse(json['high'].toString()) : null;
    low = json['low'] != null ? double.tryParse(json['low'].toString()) : null;
    volume = json['volume'] != null ? double.tryParse(json['volume'].toString()) : null;
    lastPrice = json['last_price'] != null ? double.tryParse(json['last_price'].toString()) : null;
    bid = json['bid'] != null ? double.tryParse(json['bid'].toString()) : null;
    ask = json['ask'] != null ? double.tryParse(json['ask'].toString()) : null;
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['market'] = market;
    data['change_24_hour'] = change24Hour;
    data['high'] = high;
    data['low'] = low;
    data['volume'] = volume;
    data['last_price'] = lastPrice;
    data['bid'] = bid;
    data['ask'] = ask;
    data['timestamp'] = timestamp;
    return data;
  }
}