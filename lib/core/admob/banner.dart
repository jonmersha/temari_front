import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:temari/core/admob/consent_manager.dart';

class BannerAdds extends StatefulWidget {
  const BannerAdds({super.key});

  @override
  BannerAddsState createState() => BannerAddsState();
}

class BannerAddsState extends State<BannerAdds> {
  final _consentManager = ConsentManager();
  var _isMobileAdsInitializeCalled = false;
  var _isPrivacyOptionsRequired = false;
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  Orientation? _currentOrientation;

  // final String _adUnitId = Platform.isAndroid
  //     ? 'ca-app-pub-3940256099942544/9214589741'
  //     : 'ca-app-pub-3940256099942544/2435281174';

 final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-1315253554881650/2876690837'
      : 'ca-app-pub-3940256099942544/2435281174';

  @override
  void initState() {
    super.initState();
    _consentManager.gatherConsent((consentGatheringError) {
      if (consentGatheringError != null) {
        debugPrint(
            "${consentGatheringError.errorCode}: ${consentGatheringError.message}");
      }
      _getIsPrivacyOptionsRequired();
      _initializeMobileAdsSDK();
    });
    _initializeMobileAdsSDK();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (_currentOrientation != orientation) {
          _isLoaded = false;
          _loadAd();
          _currentOrientation = orientation;
        }
        return Stack(
          children: [
            if (_bannerAd != null && _isLoaded)
              Align(
                alignment: Alignment.topCenter,
                child: SafeArea(
                  child: SizedBox(
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  ),
                ),
              )
          ],
        );
      },
    );
  }

  void _loadAd() async {
    var canRequestAds = await _consentManager.canRequestAds();
    if (!canRequestAds) {
      return;
    }
    if (!mounted) {
      return;
    }
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.sizeOf(context).width.truncate());
    if (size == null) {
      // Unable to get width of anchored banner.
      return;
    }

    BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    ).load();
  }

  void _getIsPrivacyOptionsRequired() async {
    if (await _consentManager.isPrivacyOptionsRequired()) {
      setState(() {
        _isPrivacyOptionsRequired = true;
      });
    }
  }
  void _initializeMobileAdsSDK() async {
    if (_isMobileAdsInitializeCalled) {
      return;
    }
    if (await _consentManager.canRequestAds()) {
      _isMobileAdsInitializeCalled = true;
      // Initialize the Mobile Ads SDK.
      MobileAds.instance.initialize();
      // Load an ad.
      _loadAd();
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}
