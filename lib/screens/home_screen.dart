

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

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin{

  static  const primaryDarkBgColor =  Color(0xff181735);
  static const primaryDarkCardColor =  Color(0xff282747);
  static const primaryLightTextColor =  Color(0xffFCFCFC);

  late TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    print("Build");
    return Scaffold(
      backgroundColor:primaryDarkBgColor,
      appBar: AppBar(
        bottom: TabBar(
          controller: tabController,
            dividerColor: Colors.grey,
            dividerHeight: 0.1,
            indicatorColor: primaryLightTextColor,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [
              Tab(
                  child: Text("ALL",style: TextStyle(color: primaryLightTextColor,fontWeight: FontWeight.bold),)),
              Tab(child: Text("INR",style: TextStyle(color: primaryLightTextColor,fontWeight: FontWeight.bold),)),
              Tab(child: Text("USDT",style: TextStyle(color: primaryLightTextColor,fontWeight: FontWeight.bold),)),

            ]),
        forceMaterialTransparency: true,
        backgroundColor: primaryDarkBgColor,
        elevation: 0,
        title: const Text("Crypto price tracker",style: TextStyle(color: primaryLightTextColor,fontWeight: FontWeight.w800),),
      ),
      body:mainHomeUi()

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
                      Row(
                        children: [
                          const Text("Buy:-",style: TextStyle(fontSize: 12,color: Colors.grey,fontWeight: FontWeight.w500),),
                          Text(wBuy,style: const TextStyle(fontSize: 12,color: Colors.green,fontWeight: FontWeight.w700),),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Sell:-",style: TextStyle(fontSize: 12,color: Colors.grey,fontWeight: FontWeight.w500),),
                          Text(wSell,style: const TextStyle(fontSize: 12,color: Colors.red,fontWeight: FontWeight.w700),),
                        ],
                      ),
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
                      Row(
                        children: [
                          const Text("Buy:-",style: TextStyle(fontSize: 12,color: Colors.grey,fontWeight: FontWeight.w500),),
                          Text(dBuy,style: const TextStyle(fontSize: 12,color: Colors.green,fontWeight: FontWeight.w700),),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Sell:-",style: TextStyle(fontSize: 12,color: Colors.grey,fontWeight: FontWeight.w500),),
                          Text(dSell,style: const TextStyle(fontSize: 12,color: Colors.red,fontWeight: FontWeight.w700),),
                        ],
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
  Widget mainHomeUi(){
    return Column(
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
                  return const Center(child: CircularProgressIndicator(color: primaryLightTextColor,));
                } else if (provider.market.isNotEmpty &&
                    provider.marketDcx.isNotEmpty) {
                  return TabBarView(
                    controller: tabController,
                      children: [
                        ListView.builder(
                          itemCount: provider.market.length,
                          itemBuilder: (context, index) {
                            WazirxModel wazModel = provider.market[index];
                            CoinDcxModel coinDcxModel = provider.marketDcx[index];
                            return marketUi(
                                coinDcxModel.market.toString(),
                                wazModel.askPrice.toString(), wazModel.bidPrice.toString(),
                                coinDcxModel.ask.toString(),coinDcxModel.bid.toString() );
                          },),
                        ListView.builder(
                          itemCount: provider.inrDcxList.length,
                          itemBuilder: (context, index) {
                            WazirxModel wazModel = provider.inrWazList[index];
                            CoinDcxModel coinDcxModel = provider.inrDcxList[index];
                            return marketUi(
                                coinDcxModel.market.toString(),
                                wazModel.askPrice.toString(), wazModel.bidPrice.toString(),
                                coinDcxModel.ask.toString(),coinDcxModel.bid.toString() );
                          },),
                        ListView.builder(
                          itemCount: provider.usdtDcxList.length,
                          itemBuilder: (context, index) {
                            WazirxModel wazModel = provider.usdtWazList[index];
                            CoinDcxModel coinDcxModel = provider.usdtDcxList[index];

                            return marketUi(
                                coinDcxModel.market.toString(),
                                wazModel.askPrice.toString(), wazModel.bidPrice.toString(),
                                coinDcxModel.ask.toString(),coinDcxModel.bid.toString() );
                          },),
                      ]);
                } else {
                  return const Text("Error");
                }
              },))
      ],
    );
  }

}
