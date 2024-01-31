import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MaterialApp(
    home: InterstitialExample(),
  ));
}

/// A simple app that loads an interstitial ad.
class InterstitialExample extends StatefulWidget {
  const InterstitialExample({super.key});

  @override
  InterstitialExampleState createState() => InterstitialExampleState();
}

class InterstitialExampleState extends State<InterstitialExample> {
  InterstitialAd? _interstitialAd;
  final _gameLength = 5;
  // late var _counter = _gameLength;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';

  @override
  void initState() {
    super.initState();

    _loadAd();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interstitial Example',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Interstitial Example'),
          ),
          body: Stack(
            children: [
              Center(
                child: ElevatedButton(onPressed: (){
                    _interstitialAd?.show();
                }, child: Text("click")),
              )
            ],
          )),
    );
  }

  /// Loads an interstitial ad.
  void _loadAd() {
    InterstitialAd.load(
        adUnitId: _adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (InterstitialAd ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});

            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            // ignore: avoid_print
            print('InterstitialAd failed to load: $error');
          },
        ));
  }


  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }
}
