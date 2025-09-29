import 'package:flutter/material.dart';
import 'package:gig/res/colors/app_color.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static final AdManager _instance = AdManager._internal();
  factory AdManager() => _instance;
  AdManager._internal();

  BannerAd? _preloadedBanner;
  bool _isInitialized = false;

  // Initialize and pre-load ads early
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    await MobileAds.instance.initialize();
    _preloadBannerAd();
    _isInitialized = true;
  }

  void _preloadBannerAd() {
    _preloadedBanner = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('Banner ad pre-loaded successfully');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Failed to pre-load banner: $error');
          _preloadedBanner = null;
          // Retry after delay
          Future.delayed(const Duration(seconds: 10), _preloadBannerAd);
        },
      ),
    )..load();
  }

  Widget getBannerWidget() {
    if (_preloadedBanner != null) {
      return Container(
        width: _preloadedBanner!.size.width.toDouble(),
        height: _preloadedBanner!.size.height.toDouble(),
        alignment: Alignment.center,
        child: AdWidget(ad: _preloadedBanner!),
      );
    } else {
      // Show placeholder and try to load again
      _preloadBannerAd();
      return const SizedBox(
        width: 320,
        height: 50,
        child: Center(child: CircularProgressIndicator(
          color: AppColor.primeColor,
        )),
      );
    }
  }

  void dispose() {
    _preloadedBanner?.dispose();
    _preloadedBanner = null;
  }
}