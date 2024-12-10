import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GoogleAds {
  late BannerAd bannerAd;
   BannerAd? adaptiveBannerAd;
  bool _isAdLoadedBanner = false;
  bool isAdaptativeAdLoaded = false;

  void loadBanner(Function(bool) onLoad) {
    bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Test Ad Unit ID
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          _isAdLoadedBanner = true; 
          onLoad(true);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          Log.d('Ad failed to load: $error');
          ad.dispose();
          _isAdLoadedBanner = false; 
          onLoad(false);
        },
      ),
    );

    bannerAd.load();
  }

  Future<void> loadAdaptiveBanner(BuildContext context, Function(bool) onLoad) async {
    Log.d("Starts loadAdaptiveBanner ");
    final AnchoredAdaptiveBannerAdSize? adSize = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.of(context).size.width.toInt()); 

    adaptiveBannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Usa un ID de prueba o el tuyo
      size: adSize!,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          isAdaptativeAdLoaded = true;                     
          onLoad(true);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          isAdaptativeAdLoaded = false; 
          onLoad(false);
        },
      ),
    );
  
    adaptiveBannerAd?.load();
  }


  void disposeBanner (){
    if (_isAdLoadedBanner){
      bannerAd.dispose(); 
    }
  }

  void disposeAdaptativeBanner (){
    if (isAdaptativeAdLoaded && adaptiveBannerAd != null){
      adaptiveBannerAd?.dispose(); 
    }
  }

}
