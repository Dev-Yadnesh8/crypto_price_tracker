import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../data/models/coin_dcx_model.dart';
import '../data/models/wazirx_model.dart';
import '../data/my_data.dart';

class DataProvider with ChangeNotifier {
  ApiHelper apiHelper = ApiHelper();

  List<String> inrPairs = [
    'btcinr', 'ethinr', 'xrpinr', 'ltcinr', 'bchinr',
    'maticinr', 'dogeinr', 'etcinr', 'trxinr', 'uniinr',
    'solinr','linkinr', 'adainr', 'batinr', 'vetinr', 'avaxinr',
    'dotinr', 'icpinr', 'fttinr', 'enjinr', 'atomrin',
    'zilinr', 'filinr', 'chzinr', 'oninr', 'xlminr',
    'lrcinr', 'ksminr', 'scinr', 'yfiiinr', 'daiinr'
  ];

  List<String> usdtPairs = [
    'btcusdt', 'ethusdt', 'xrpusdt', 'ltcusdt', 'bchusdt',
    'maticusdt', 'dogeusdt', 'etcusdt', 'trxusdt', 'uniusdt',
    'solusdt', 'linkusdt', 'adausdt', 'batusdt', 'vetusdt',
    'avaxusdt', 'dotusdt', 'icpusdt', 'fttusdt', 'enjusdt',
    'atomusdt', 'zilusdt', 'filusdt', 'chzusdt', 'onusdt',
    'xlmusdt', 'lrcusdt', 'ksmusdt', 'scusdt', 'yfiiusdt', 'daiusdt'
  ];

  bool isLoading = true;
  String searchText = '';
  List<WazirxModel> market = [];
  List<CoinDcxModel> marketDcx = [];
  List<dynamic> searchedList = [];


  List<CoinDcxModel> inrDcxList = [];
  List<WazirxModel> inrWazList = [];
  List<CoinDcxModel> usdtDcxList = [];
  List<WazirxModel> usdtWazList = [];

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
      List<CoinDcxModel> inrTemp = [];
      List<WazirxModel> inrTemp2 = [];
      List<CoinDcxModel> usdtTemp = [];
      List<WazirxModel> usdtTemp2 = [];

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
            // Check if the pair is INR or USDT and add to the corresponding list
            if (inrPairs.contains(symbol)) {
              inrTemp2.add(wazirxModel);
              inrTemp.add(coinDcxMap[market]!);
            } else if (usdtPairs.contains(symbol)) {
              usdtTemp2.add(wazirxModel);
              usdtTemp.add(coinDcxMap[market]!);
            }
          }
        }
      }

      market = temp;
      marketDcx = temp2;
      inrDcxList = inrTemp;
      usdtDcxList = usdtTemp;
      inrWazList = inrTemp2;
      usdtWazList = usdtTemp2;
      isLoading = false;
    notifyListeners();
    } catch (error) {
      print("Error-hitting-api-with$error");
    }

    Timer(const Duration(seconds: 10), () {
      // print("Fetch-data-called");
      fetchData();
    });
  }


}
