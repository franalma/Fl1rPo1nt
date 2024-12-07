import 'package:app/ads/GoogleAds.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsManager {
  GoogleAds? _googleAds;
  bool _isBannerLoaded = false;
  bool _isAdaptativeAdLoaded = false;

  Function(bool) onAdaptativeBannerLoaded;

  AdsManager(this.onAdaptativeBannerLoaded);

  void init(BuildContext context) async {
    _googleAds = GoogleAds();
    // _googleAds!.loadBanner((value) {
    //   _isBannerLoaded = value;
    // });
    await  _googleAds!.loadAdaptiveBanner(context, (value) {
      Log.d("AdsManager loaded adaptative ad: $value");
      
      _isAdaptativeAdLoaded = value;
      Log.d("----->${_googleAds?.adaptiveBannerAd}");
      // onAdaptativeBannerLoaded(value);


      
   }); 
    
  }

  Widget BackButtonIcon() {
    if (_isBannerLoaded) {
      return Positioned(
        bottom: 16, // Distance from the bottom of the screen
        left: 0,
        right: 0,
        child: Center(
          child: Container(
            height: _googleAds!.bannerAd.size.height.toDouble(),
            width: _googleAds!.bannerAd.size.width.toDouble(),
            child: AdWidget(ad: _googleAds!.bannerAd),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget buildAdaptativeBannerd(BuildContext context) {
     print("------------------->buildAdaptativeBanner: ${_googleAds}");
    
    if (_isAdaptativeAdLoaded && _googleAds?.adaptiveBannerAd != null) {
      return Positioned(
        bottom: 80, // Distance from the bottom of the screen
        left: 0,
        right: 0,
        child: Center(
          child: Container(
            height: _googleAds!.adaptiveBannerAd.size.height.toDouble(),
            width: _googleAds!.adaptiveBannerAd.size.width.toDouble(),
            child: AdWidget(ad: _googleAds!.adaptiveBannerAd),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
