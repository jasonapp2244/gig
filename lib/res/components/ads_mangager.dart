import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gig/res/colors/app_color.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static final AdManager _instance = AdManager._internal();
  factory AdManager() => _instance;
  AdManager._internal();

  BannerAd? _preloadedBanner;
  bool _isInitialized = false;

  // ✅ Get platform-specific banner ID
  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8812386332155668/6756514724'; // Android Ad Unit ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-8812386332155668/1234567890'; // Replace with your iOS Ad Unit ID
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  // Initialize and pre-load ads early
  Future<void> initialize() async {
    if (_isInitialized) return;

    await MobileAds.instance.initialize();
    _preloadBannerAd();
    _isInitialized = true;
  }

  void _preloadBannerAd() {
    _preloadedBanner = BannerAd(
      adUnitId: bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('✅ Banner ad pre-loaded successfully');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('❌ Failed to pre-load banner: $error');
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
      // Show placeholder while loading
      _preloadBannerAd();
      return const SizedBox(
        width: 320,
        height: 50,
        child: Center(
          child: CircularProgressIndicator(color: AppColor.primeColor),
        ),
      );
    }
  }

  void dispose() {
    _preloadedBanner?.dispose();
    _preloadedBanner = null;
  }
}
