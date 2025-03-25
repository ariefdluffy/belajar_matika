import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBannerSusunKataWidgetAtas extends StatefulWidget {
  const AdBannerSusunKataWidgetAtas({super.key});

  @override
  _AdBannerSusunKataWidgetAtasState createState() =>
      _AdBannerSusunKataWidgetAtasState();
}

class _AdBannerSusunKataWidgetAtasState
    extends State<AdBannerSusunKataWidgetAtas> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId:
          "ca-app-pub-2393357737286916/4341935222", // Ganti dengan Ad Unit ID asli
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return _isAdLoaded
        ? Container(
            alignment: Alignment.center,
            width: _bannerAd!.size.width.toDouble(),
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          )
        : const SizedBox(); // Jika belum dimuat, tidak tampilkan apa-apa
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}
