import 'dart:async';
import 'dart:convert';

import 'package:app/comms/model/request/subscriptions/HostGetAllSubscriptionRequest.dart';
import 'package:app/comms/model/request/subscriptions/HostUpdateSubscriptionRequest.dart';
import 'package:app/comms/model/response/subscriptions/HostGetAllSubscritionsResponse.dart';
import 'package:app/model/HostErrorCode.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/Subscription.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';
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
  static Subscription? userSuscriptionDetails;

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

  static Future<void> buyProduct(ProductDetails productDetails) async {
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  static Future<void> _handlePurchaseUpdates(
      List<PurchaseDetails> purchases) async {
    for (var purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        Log.d('Subscription purchased: ${purchase.productID}');
        await _iap.completePurchase(purchase);
        await _onSubscriptionPurchased(purchase).then((_) {
          Log.d("saved internally ");
        });
      } else if (purchase.status == PurchaseStatus.error) {
        Log.d('Purchase error: ${purchase.error}');
      } else if (purchase.status == PurchaseStatus.canceled) {
        Log.d("Suscription cancelled: ${purchase.productID}");
        //  await _onSubscriptionCanceled(purchase);
      } else if (purchase.status == PurchaseStatus.pending) {
        Log.d("Suscription pending: ${purchase.productID}");
      } else if (purchase.status == PurchaseStatus.restored) {
        Log.d("Suscription restored: ${purchase.productID}");
        Log.d(
            "Suscription restored: ${purchase.verificationData.serverVerificationData}");
        Log.d(
            "Suscription restored: ${purchase.verificationData.localVerificationData}");
      }
    }
  }

  static Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  static Future<void> loadSubscriptions(User user) async {
    Log.d("Starts loadSubscriptions");
    try {
      HostGetAllSubscritionsResponse response =
          await HostGetAllSubscriptionRequest().run();

      if (response.hostErrorCode?.code == HostErrorCodesValue.NoError.code) {
        subscriptionsModel = response.subscriptions;
        _loadUserSuscriptionDetails(user);
      }
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
  }

  static Future<bool> _onSubscriptionPurchased(PurchaseDetails purchase) async {
    Log.d("Starts _onSubscriptionPurchased");
    try {
      if (purchase.verificationData.source == "google_play") {
        final Map<String, dynamic> parsedData =
            jsonDecode(purchase.verificationData.localVerificationData);
        bool autoRenewing = false;
        String purchaseToken = "";
        int purchaseState = -1;

        print(parsedData);

        if (parsedData.containsKey("autoRenewing")) {
          autoRenewing = parsedData['autoRenewing'];
        }
        if (parsedData.containsKey("purchaseToken")) {
          purchaseToken = parsedData['purchaseToken'];
        }
        if (parsedData.containsKey("purchaseState")) {
          purchaseState = parsedData['purchaseState'];
        }

        var bUpdated = await HostUpdateSubscriptionRequest().run(
            user.userId,
            purchase.productID,
            purchase.transactionDate!,
            autoRenewing,
            purchaseToken,
            purchaseState);

        return bUpdated;
      } else {
        //apple
      }
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return false;
  }

  static Future<bool> _onSubscriptionCancelled(PurchaseDetails purchase) async {
    Log.d("Starts _onSubscriptionCancelled");
    try {
      // if (purchase.verificationData.source == "google_play") {
      //   int status = -1;
      //   var bUpdated = await HostUpdateSubscriptionRequest().run(user.userId,
      //       -1, purchase.productID, purchase.transactionDate!, false, status);
      //   return bUpdated;
      // } else {
      //   //apple
      // }
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return false;
  }

  static void _loadUserSuscriptionDetails(User user) {
    Log.d("Starts loadUserSuscriptionDetails");
    try {
      if (user.subscription.id != null) {
        if (subscriptionsModel != null) {
          for (var item in subscriptionsModel!) {
            if (item.id! == user.subscription.id) {
              userSuscriptionDetails = item;
              break;
            }
          }
        }
      }
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
  }

  static Color getSubscriptionColor(String id) {
    Log.d("Starts getSubscriptionColor $id");
    try {      
      if (subscriptionsModel != null) {
        for (var item in subscriptionsModel!) {
          
          if (item.id! == id) {
            return item.color!;
          }
        }
      }      
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return Colors.green;
  }
}
