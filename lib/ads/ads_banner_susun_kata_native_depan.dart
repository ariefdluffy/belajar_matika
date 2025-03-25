import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';

class AdBannerSusunKataNativeDepan extends StatefulWidget {
  const AdBannerSusunKataNativeDepan({super.key});

  @override
  _AdBannerSusunKataNativeDepanState createState() =>
      _AdBannerSusunKataNativeDepanState();
}

class _AdBannerSusunKataNativeDepanState
    extends State<AdBannerSusunKataNativeDepan> {
  NativeAd? _nativeAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadNativeAd();
  }

  void _loadNativeAd() {
    _nativeAd = NativeAd(
      adUnitId: 'ca-app-pub-2393357737286916/9223824292', // ID Iklan Test
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          Logger().e('Native Ad failed to load: $error');
        },
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small, // Pilih template yang sesuai
        cornerRadius: 14.0, // Sesuaikan sudut iklan
      ),
    )..load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isAdLoaded ? AdWidget(ad: _nativeAd!) : const SizedBox();
  }
}
