
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class InternetBloc extends ChangeNotifier{
  bool _hasInternet = false;




  set hasInternet (newVal){
    _hasInternet = newVal;
  }

  bool get hasInternet => _hasInternet;

  checkInternet() async {
    var result = await (Connectivity().checkConnectivity());
    if (result == ConnectivityResult.none) {
      _hasInternet = false;
      
    } else {
      _hasInternet = true;
      
    }

    notifyListeners();
  }


}