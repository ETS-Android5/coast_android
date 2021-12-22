import 'dart:convert';

import 'package:coast/config/default.dart';
import 'package:coast/model/gpmodel.dart';
import 'package:coast/utility/appstate.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class GPController with ChangeNotifier {
  AppState _state = AppState.Idle;
  AppState get state => _state;
  void setState(AppState appState) {
    _state = appState;
    notifyListeners();
  }

  List<GPModel> _gp = [];
  List<GPModel> get gp => _gp;

  Future<List<GPModel>> getgp(String dist,String tehsil) async {
    try {
      setState(AppState.Busy);
      var gpresponse = await http.get(
          Config().apiurl + "getgp?districtname="+dist+"&tehsil="+tehsil+"");
      print(gpresponse.toString());
      if (gpresponse.statusCode == 200) {
        Iterable i = json.decode(gpresponse.body);
        _gp = i.map((model) => GPModel.fromJSON(model)).toList();
      }
    } catch (e) {
      setState(AppState.Idle);
    }
    setState(AppState.Idle);
    return _gp;
  }
}
