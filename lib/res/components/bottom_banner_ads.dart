import 'package:flutter/material.dart';
import 'package:gig/res/colors/app_color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BottomBannerAd extends StatefulWidget {
  const BottomBannerAd({Key? key}) : super(key: key);

  @override
  State<BottomBannerAd> createState() => _BottomBannerAdState();
}

class _BottomBannerAdState extends State<BottomBannerAd> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  // Real ad unit ID
  // final String _adUnitId = 'ca-app-pub-8812386332155668/4027577863';
  final String _adUnitId = 'ca-app-pub-3940256099942544/6300978111';
  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _bannerAd = BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('Ad loaded successfully.');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _isAdLoaded = true;
              });
            }
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Ad failed to load: $error');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAdLoaded) {
      return SizedBox(
        width: 320, // Match banner width to prevent layout shifts
        height: 50, // Match banner height
        child: Center(
          child: SizedBox(
            child: Text(
              "No Ads At This Moment",
              style: GoogleFonts.dmSans(color: AppColor.whiteColor),
            ),
          ), // Empty while loading, or show a placeholder
        ),
      );
    }

    return Container(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      alignment: Alignment.center,
      child: AdWidget(ad: _bannerAd!),
    );
  }
}

























// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class BottomBannerAd extends StatefulWidget {
//   const BottomBannerAd({super.key}) ;

//   @override
//   State<BottomBannerAd> createState() => _BottomBannerAdState();
// }

// class _BottomBannerAdState extends State<BottomBannerAd> {
//   BannerAd? _bannerAd;
//   bool _isAdLoaded = false;

//   // Test ad unit ID - replace with your actual ad unit ID for production
//   final String _adUnitId = 'ca-app-pub-3940256099942544/6300978111';

//   @override
//   void initState() {
//     super.initState();
//     _loadAd();
//   }

//   void _loadAd() {
//     _bannerAd = BannerAd(
//       adUnitId: _adUnitId,
//       request: const AdRequest(),
//       size: AdSize.banner,
//       listener: BannerAdListener(
//         onAdLoaded: (Ad ad) {
//           setState(() {
//             _isAdLoaded = true;
//           });
//         },
//         onAdFailedToLoad: (Ad ad, LoadAdError error) {
//           ad.dispose();
//           print('Ad failed to load: $error');
//         },
//       ),
//     )..load();
//   }

//   @override
//   void dispose() {
//     _bannerAd?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_isAdLoaded) {
//       return const SizedBox.shrink(); // Hide when no ad is loaded
//     }

//     return Container(
//       width: _bannerAd!.size.width.toDouble(),
//       height: _bannerAd!.size.height.toDouble(),
//       alignment: Alignment.center,
//       child: AdWidget(ad: _bannerAd!),
//     );
//   }
// }