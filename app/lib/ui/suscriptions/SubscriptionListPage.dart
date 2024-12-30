import 'package:app/services/IapService.dart';
import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionListPage extends StatefulWidget {
  @override
  State<SubscriptionListPage> createState() {
    return _SuscriptionListState();
  }
}

class _SuscriptionListState extends State<SubscriptionListPage> {
  bool _isLoading = true;
  late List<ProductDetails> _products = [];
  @override
  void initState() {
    super.initState();
    _fetchFromHost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(flexibleSpace: FlexibleAppBar()),
        body: _isLoading ? AlertDialogs().buildLoading() : _buildBody());
  }

  Widget _buildBody() {
    return ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                title: Text(_products[index].title),
                subtitle: Text(_products[index].description),
                trailing: ElevatedButton(
                  onPressed: ()async {await _buySuscription(index);},
                  child: Column(
                    children: [
                      Text("${_products[index].price}${_products[index].currencySymbol}"),
                      Text("Comprar")
                    ],
                  ),
                ),
              ),
              const Divider()
            ],
          );
        });
  }

  Future<void> _fetchFromHost() async {
    Log.d("Starts _fetchFromhost");
    try {
      if (IapService.available) {
        setState(() {
          _isLoading = true;
        });

        _products = await IapService.getSuscriptions();
      }
      setState(() {
        _isLoading = false;
      });
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
  }
  Future<void>_buySuscription(int index) async{
    Log.d("Starts _buySuscription");
    try{
      IapService.buyProduct(_products[index]);
    }catch(error, stackTrace){
        Log.d("$error, $stackTrace");
    }
  }
}
