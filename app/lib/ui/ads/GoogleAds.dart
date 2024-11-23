import 'package:google_mobile_ads/google_mobile_ads.dart';

class GoogleAds {
  late BannerAd bannerAd;
  bool _isAdLoaded = false;

  void loadBanner(Function(bool) onLoad) {
    bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Test Ad Unit ID
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          _isAdLoaded = true; 
          onLoad(true);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Ad failed to load: $error');
          ad.dispose();
          _isAdLoaded = false; 
          onLoad(false);
        },
      ),
    );

    bannerAd.load();
  }

  void dispose (){
    if (_isAdLoaded){
      bannerAd.dispose(); 
    }
  }

}
