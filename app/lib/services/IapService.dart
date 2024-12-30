import 'dart:async';

import 'package:app/comms/model/request/subscriptions/HostGetAllSubscriptionRequest.dart';
import 'package:app/comms/model/request/subscriptions/HostUpdateSubscriptionRequest.dart';
import 'package:app/comms/model/response/subscriptions/HostGetAllSubscritionsResponse.dart';
import 'package:app/model/HostErrorCode.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/Subscription.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class IapService {
  static final InAppPurchase _iap = InAppPurchase.instance;
  static bool available = false;
  static final Set<String> _kIds = {
    'id_0001',
    "id_0002",
    "id_0003"
  }; // Add your subscription IDs here
  static List<ProductDetails> products = [];
  static List<PurchaseDetails> _purchases = [];
  static StreamSubscription<List<PurchaseDetails>>? _subscription;
  static List<Subscription>? subscriptionsModel;
  static User user = Session.user;

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
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  static void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    for (var purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        Log.d('Subscription purchased: ${purchase.productID}');
        _iap.completePurchase(purchase);
        updateSubscriptionStatus(purchase).then((_) {
          Log.d("saved internally ");
        });
      } else if (purchase.status == PurchaseStatus.error) {
        Log.d('Purchase error: ${purchase.error}');
      }
    }
  }

  static void restorePurchases() {
    _iap.restorePurchases();
  }

  static Future<void> loadSubscriptions() async {
    Log.d("Starts loadSubscriptions");
    try {
      HostGetAllSubscritionsResponse response =
          await HostGetAllSubscriptionRequest().run();

      if (response.hostErrorCode?.code == HostErrorCodesValue.NoError.code) {
        subscriptionsModel = response.subscriptions;
      }
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
  }

  static Future<bool> updateSubscriptionStatus(PurchaseDetails purchase) async {
    Log.d("Starts updateSubscriptionStatus");
    try {
      var bUpdated = await HostUpdateSubscriptionRequest()
          .run(user.userId, -1, purchase.productID, purchase.transactionDate!);
      return bUpdated;
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return false;
  }
}
