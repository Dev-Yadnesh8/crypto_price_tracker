

import 'package:crypto_price_tracker/data/models/coin_dcx_model.dart';
import 'package:crypto_price_tracker/data/models/wazirx_model.dart';
import 'package:crypto_price_tracker/provider/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  static  const primaryDarkBgColor =  Color(0xff181735);
  static const primaryDarkCardColor =  Color(0xff282747);
  static const primaryLightTextColor =  Color(0xffFCFCFC);

  @override
  Widget build(BuildContext context) {
    print("Build");
    return Scaffold(
      backgroundColor:primaryDarkBgColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: primaryDarkBgColor,
        elevation: 0,
        title: const Text("Crypto price tracker",style: TextStyle(color: primaryLightTextColor,fontWeight: FontWeight.w800),),
      ),
      body: Column(
        children: [
        const SizedBox(
           height: 50,
           child: Row(
             children: [
               Expanded(child: Center(child: Text("Coin",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500),))),
               Expanded(child: Center(child: Padding(
                 padding: EdgeInsets.only(right: 40),
                 child: Text("Exchange1",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500),),
               ))),
               Expanded(child: Center(child: Padding(
                 padding: EdgeInsets.only(right: 60),
                 child: Text("Exchange2",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500),),
               ))),
             ],
           ),
         ),
          Expanded(
              child: Consumer<DataProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading == true) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (provider.market.isNotEmpty &&
                      provider.marketDcx.isNotEmpty) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        await provider.fetchData();
                      },
                      child: ListView.builder(
                        itemCount: provider.market.length,
                        itemBuilder: (context, index) {
                          WazirxModel wazModel = provider.market[index];
                          CoinDcxModel coinDcxModel = provider.marketDcx[index];
                          return marketUi(
                              coinDcxModel.market.toString(),
                              wazModel.askPrice.toString(), wazModel.bidPrice.toString(),
                              coinDcxModel.ask.toString(),coinDcxModel.bid.toString() );
                        },),
                    );
                  } else {
                    return const Text("Error");
                  }
                },))
        ],
      ),

    );
  }

  Widget marketUi(String pairName,String wBuy,String wSell,String dBuy,String dSell){
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6,horizontal: 8),
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color:primaryDarkCardColor
      ),
      child:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(pairName,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.white),))),
            const SizedBox(width: 12,),
            Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Wazirx",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.white),),
                      Text("Buy:-$wBuy",style: const TextStyle(fontSize: 12,color: Colors.green,fontWeight: FontWeight.w500),),
                      Text("Sell:-$wSell",style: const TextStyle(fontSize: 12,color: Colors.red,fontWeight: FontWeight.w500),),
                    ],
                  ),
                )),
            Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("CoinDCX",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.white),),
                      Text("Buy:-$dBuy",style: const TextStyle(fontSize: 12,color: Colors.green,fontWeight: FontWeight.w500),),
                      Text("Sell:-$dSell",style: const TextStyle(fontSize: 12,color: Colors.red,fontWeight: FontWeight.w500),),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
