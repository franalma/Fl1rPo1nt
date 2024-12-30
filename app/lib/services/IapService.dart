import 'dart:async';

import 'package:app/ui/utils/Log.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class IapService {
  static final InAppPurchase _iap = InAppPurchase.instance;
  static bool available = false;
  static final Set<String> _kIds = {
    'id_0001', "id_0002", "id_0003"
  }; // Add your subscription IDs here
  static List<ProductDetails> products = [];
  static List<PurchaseDetails> _purchases = [];
  static StreamSubscription<List<PurchaseDetails>>? _subscription;

  static Future<void> init() async {
    Log.d("Stars iap init()");
    available = await _iap.isAvailable();

    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen((purchases) {
      _handlePurchaseUpdates(purchases);
    });
  }

  static Future<List<ProductDetails>> getSuscriptions() async {
    Log.d("Starts getSuscriptions ");
    if (available) {
      final ProductDetailsResponse response =
          await _iap.queryProductDetails(_kIds);
      if (response.error == null && response.productDetails.isNotEmpty) {
        products = response.productDetails;
      }
    }

    return products;
  }

  static void buyProduct(ProductDetails productDetails) {
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);
    _iap.buyNonConsumable(
        purchaseParam:
            purchaseParam); 
  }

  static void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    for (var purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        Log.d('Subscription purchased: ${purchase.productID}');
        _iap.completePurchase(purchase);
      } else if (purchase.status == PurchaseStatus.error) {
        Log.d('Purchase error: ${purchase.error}');
      }
    }
  }

  static void restorePurchases() {
    _iap.restorePurchases();
  }
}
