import 'dart:async';
import 'dart:convert';

import 'package:crypto_price_tracker/data/models/coin_dcx_model.dart';
import 'package:crypto_price_tracker/data/models/wazirx_model.dart';
import 'package:crypto_price_tracker/data/my_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class DataProvider with ChangeNotifier {
  ApiHelper apiHelper = ApiHelper();

  List<String> inrPairs = [
    'btcinr', 'ethinr', 'xrpinr', 'ltcinr', 'bchinr',
    'maticinr', 'dogeinr', 'etcinr', 'trxinr', 'adausdt',
    'shibusdt', 'xrpusdt', 'bchusdt', 'ethusdt', 'ltcusdt',
    'maticusdt', 'dogeusdt', 'etcusdt', 'trxusdt', 'dotinr',
    'solusdt', 'lunausdt', 'linkusdt', 'usdcusdt', 'avaxusdt',
    'icpusdt', 'filusdt', 'venusdt', 'bttusdt', 'axsusdt',
    'atomusdt', 'algousdt', 'crousdt', 'sprusdt', 'telusdt',
    'uniinr', 'crvinr', 'aaveusdt', 'snxusdt', 'ksmusdt',
    'chzusdt', 'icxusdt', 'sushiusdt', 'ftmusdt', 'daiusdt',
    'mdxusdt', 'renusdt', 'batusdt'
  ];

  List<String> usdtPairs = [
    'btcusdt', 'ethusdt', 'xrpusdt', 'ltcusdt', 'bchusdt',
    'maticusdt', 'dogeusdt', 'etcusdt', 'trxusdt', 'adausdt',
    'shibusdt', 'dotusdt', 'solusdt', 'lunausdt', 'linkusdt',
    'usdcusdt', 'avaxusdt', 'icpusdt', 'filusdt', 'venusdt',
    'bttusdt', 'axsusdt', 'atomusdt', 'algousdt', 'crousdt',
    'sprusdt', 'telusdt', 'uniusdt', 'crvusdt', 'aaveusdt',
    'snxusdt', 'ksmusdt', 'chzusdt', 'icxusdt', 'sushiusdt',
    'ftmusdt', 'daiusdt', 'mdxusdt', 'renusdt', 'batusdt',
    'avaxusdt', 'ethinr', 'btcinr', 'maticinr', 'ltcinr',
    'xrpinr', 'bchinr', 'dogeinr', 'etcinr', 'trxinr'
  ];


  bool isLoading = true;
  List<WazirxModel> market = [];
  List<CoinDcxModel> marketDcx = [];

  List<CoinDcxModel> inrDcxList =[];

  DataProvider() {
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      var res = await http.get(Uri.parse(apiHelper.wazUrl));
      var res2 = await http.get(Uri.parse(apiHelper.dcxUrl));

      var data = jsonDecode(res.body);
      var data2 = jsonDecode(res2.body);

      List<WazirxModel> temp = [];
      List<CoinDcxModel> temp2 = [];

      // Create a map to store CoinDCX data by market symbol
      Map<String, CoinDcxModel> coinDcxMap = {};

      // Process CoinDCX data and store it in the map
      for (int i = 0; i < data2.length; i++) {
        String market = data2[i]['market'].toString().toLowerCase();
        // Check if the market pair is in the inrPairs or usdtPairs lists
        if (inrPairs.contains(market) || usdtPairs.contains(market)) {
          CoinDcxModel coinDcxModel = CoinDcxModel.fromJson(data2[i]);
          coinDcxMap[market] = coinDcxModel;
        }
      }

      // Process WazirX data and add matching CoinDCX data to temp2 list
      for (int i = 0; i < data.length; i++) {
        String symbol = data[i]['symbol'].toString().toLowerCase();
        // Check if the symbol is in the inrPairs or usdtPairs lists
        if (inrPairs.contains(symbol) || usdtPairs.contains(symbol)) {
          WazirxModel wazirxModel = WazirxModel.fromJson(data[i]);
          String market = symbol; // Adjust this if WazirX uses a different market symbol format
          // Check if CoinDCX data exists for the same symbol in the map
          if (coinDcxMap.containsKey(market)) {
            temp.add(wazirxModel);
            temp2.add(coinDcxMap[market]!);

          }
        }
      }

      market = temp;
      marketDcx = temp2;
      isLoading = false;
      notifyListeners();
    } catch (error) {
      print("Error-hitting-api-with$error");
    }

    Timer(const Duration(seconds: 3), () {
      // print("Fetch-data-called");
      fetchData();
    });
  }
}
