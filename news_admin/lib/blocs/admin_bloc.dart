
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:news_admin/utils/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminBloc extends ChangeNotifier {
  
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String _adminPass;
  String _userType = 'admin';
  bool _isSignedIn = false;
  bool _testing = false;

  List _categories = [];
  List get categories => _categories;
  

  AdminBloc() {
    checkSignIn();
    getAdminPass();
  }

  
  String get adminPass => _adminPass;
  String get userType => _userType;
  bool get isSignedIn => _isSignedIn;
  bool get testing => _testing;


  bool _bannerAd = false;
  bool get bannerAd => _bannerAd;

  bool _interstitialAd = false;
  bool get interstitialAd => _interstitialAd;
  


  Future getAdsData () async {
    await firestore.collection('admin').doc('ads').get()
    .then((value)async{
      if(value.exists){
        _bannerAd = value['banner_ad'];
        _interstitialAd = value['interstitial_ad'];
      }else{
        await firestore.collection('admin').doc('ads')
        .set({
          'banner_ad' : false,
          'interstitial_ad' : false,

        });
      }
    });
    print('banner : $_bannerAd, interstitial : $interstitialAd');
    notifyListeners();
  }



  Future controlBannerAd (bool value, context) async {
    await firestore.collection('admin').doc('ads')
    .update({
      'banner_ad' : value
    }).then((_){
      _bannerAd = value;
      if(value == true){
        openToast(context, "Banner Ads enabled successfully");
      }else{
        openToast(context, "Banner Ads disabled successfully");
      }
    notifyListeners();
    });
    
  }


  Future controlInterstitialAd (bool value, context) async {
    await firestore.collection('admin').doc('ads')
    .update({
      'interstitial_ad' : value
    }).then((_){
      _interstitialAd = value;
      if(value == true){
        openToast(context, "Interstitial Ads enabled successfully");
      }else{
        openToast(context, "Interstitial Ads disabled successfully");
      }
    notifyListeners();
    });
    
  }


  

  Future getAdminPass() async{
    firestore
        .collection('admin')
        .doc('user type')
        .get()
        .then((DocumentSnapshot snap) {
      String _aPass = snap['admin password'];
     _adminPass = _aPass;
      notifyListeners();
    });
  }



  Future<int> getTotalDocuments (String documentName) async {
    final String fieldName = 'count';
    final DocumentReference ref = firestore.collection('item_count').doc(documentName);
      DocumentSnapshot snap = await ref.get();
      if(snap.exists == true){
        int itemCount = snap[fieldName] ?? 0;
        return itemCount;
      }
      else{
        await ref.set({
          fieldName : 0
        });
        return 0;
      }
  }


  Future increaseCount (String documentName) async {
    await getTotalDocuments(documentName)
    .then((int documentCount)async {
      await firestore.collection('item_count')
      .doc(documentName)
      .update({
        'count' : documentCount + 1
      });
    });
  }



  Future decreaseCount (String documentName) async {
    await getTotalDocuments(documentName)
    .then((int documentCount)async {
      await firestore.collection('item_count')
      .doc(documentName)
      .update({
        'count' : documentCount - 1
      });
    });
  }

  



  Future getCategories ()async{

    await firestore.collection('categories').limit(1).get().then((value)async{
      if(value.size != 0){
        QuerySnapshot snap = await firestore.collection('categories').get();
        List d = snap.docs;
        _categories.clear();
        d.forEach((element) {
        _categories.add(element['name']);
      }
      
      );

    }else{
      _categories.clear();
    }

    notifyListeners();

    });
    
  }



  


  Future<List> getFeaturedList ()async{
    final DocumentReference ref = firestore.collection('featured').doc('featured_list');
      DocumentSnapshot snap = await ref.get();
      if(snap.exists == true){
        List featuredList = snap['contents'] ?? [];
        return featuredList;
      }
      else{
        await ref.set({
          'contents' : []
        });
        return [];
      }
  }

  


  Future addToFeaturedList (context, String timestamp) async {
    final DocumentReference ref = firestore.collection('featured').doc('featured_list');
    await getFeaturedList().then((featuredList)async{

      if (featuredList.contains(timestamp)) {
        openToast1(context, "This item is already available in the featured list");
      } else {

        featuredList.add(timestamp);
        await ref.update({'contents': FieldValue.arrayUnion(featuredList)});
        openToast1(context, 'Added Successfully');
      }
    });
  }

  Future removefromFeaturedList (context, String timestamp) async {
    final DocumentReference ref = firestore.collection('featured').doc('featured_list');
    await getFeaturedList().then((featuredList)async{

      if (featuredList.contains(timestamp)) {
        await ref.update({'contents' : FieldValue.arrayRemove([timestamp])});
        openToast1(context, 'Removed Successfully');
      }
    });
  }




  



  




  


  Future deleteContent(String timestamp, String collectionName) async {
    await firestore.collection(collectionName).doc(timestamp).delete();
    notifyListeners();
  }









  

  

  Future setSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('signed_in', true);
    _userType = 'admin';
    _isSignedIn = true;
    notifyListeners();
  }


  void checkSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _isSignedIn = sp.getBool('signed_in') ?? false;
    notifyListeners();
  }



  Future setSignInForTesting() async {
    
    _testing = true;
    _userType = 'tester';
    notifyListeners();
    
  }



  Future saveNewAdminPassword (String newPassword) async {
    await firestore.collection('admin')
    .doc('user type')
    .update({
      'admin password' : newPassword
    }).then((value) => getAdminPass());
    notifyListeners();  
  }








}
