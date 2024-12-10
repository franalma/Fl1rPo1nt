import 'package:app/ads/GoogleAds.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsManager {
  final GoogleAds _googleAds = GoogleAds();

  Function(bool) onAdaptativeBannerLoaded;

  AdsManager(this.onAdaptativeBannerLoaded);

  void init(BuildContext context) async {
    // _googleAds!.loadBanner((value) {
    //   _isBannerLoaded = value;
    // });
    await _googleAds.loadAdaptiveBanner(context, (value) {
      Log.d("AdsManager loaded adaptative ad callback: $value");
      Log.d(
          "AdsManager loaded adaptative ad: ${_googleAds.isAdaptativeAdLoaded}");

      if (value && _googleAds.isAdaptativeAdLoaded) {
        Log.d("----->${_googleAds.adaptiveBannerAd}");
        onAdaptativeBannerLoaded(value);
      }
    });
  }

  Widget buildAdaptativeBannerd(BuildContext context) {
    Log.d("Starts buildAdaptativeBannerd");

    try {
      if (_googleAds.adaptiveBannerAd != null) {
        return Positioned(
          bottom: 5, // Distance from the bottom of the screen
          left: 0,
          right: 0,
          child: Center(
            child: SizedBox(
              height: _googleAds.adaptiveBannerAd?.size.height.toDouble(),
              width: _googleAds.adaptiveBannerAd?.size.width.toDouble(),
              child: AdWidget(ad: _googleAds.adaptiveBannerAd!),
            ),
          ),
        );
      }
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
    return Container();
  }
}
