import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';




class AdsBloc extends ChangeNotifier {


  int _clickCounter = 0;
  int get clickCounter => _clickCounter;

  bool _bannerAd = false;
  bool get bannerAd => _bannerAd;

  bool _interstitialAd = false;
  bool get interstitialAd => _interstitialAd;


  Future checkAdsEnable () async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('admin').doc('ads').get().then((DocumentSnapshot snap) {
      bool _banner = snap.data()['banner_ad'];
      bool _interstitial = snap.data()['interstitial_ad'];
      _bannerAd = _banner;
      _interstitialAd = _interstitial;
      print('banner : $_bannerAd, interstitial: $_interstitialAd');
      notifyListeners();
    }).catchError((e){
      print('error : $e');
    });
  }
  
}