import 'package:app/services/IapService.dart';
import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                leading: Icon(
                  FontAwesomeIcons.medal,
                  size: 40,
                  color: IapService.getSubscriptionColor(_products[index].id),
                ),
                title: Text(
                  _products[index].title.contains("(")
                      ? _products[index]
                          .title
                          .substring(0, _products[index].title.indexOf("("))
                      : _products[index].title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                subtitle: Text(_products[index].description),
                trailing: SizedBox(
                  height: 80,
                  child: Stack(   
                               
                    children: [
                      Positioned(                          
                        child: Text(
                          "${_products[index].price}${_products[index].currencySymbol}",
                          style:
                              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                        Positioned(
                          top:10,
                        child: IconButton(
                          icon: const Icon(Icons.shopping_cart),
                          onPressed: () async {
                            await _buySuscription(index);
                          },
                        ),
                      )
                    
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

  Future<void> _buySuscription(int index) async {
    Log.d("Starts _buySuscription");
    try {
      IapService.buyProduct(_products[index]);
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
  }
}
