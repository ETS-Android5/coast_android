import 'dart:convert';

import 'package:coast/config/default.dart';
import 'package:coast/model/gpmodel.dart';
import 'package:coast/model/villagemodel.dart';
import 'package:coast/utility/appstate.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class VillageController with ChangeNotifier {
  AppState _state = AppState.Idle;
  AppState get state => _state;
  void setState(AppState appState) {
    _state = appState;
    notifyListeners();
  }

  List<VillageModel> _village = [];
  List<VillageModel> get village => _village;

  Future<List<VillageModel>> getvillage(String dist,String tehsil,String gp) async {
    try {
      setState(AppState.Busy);
      var villageresponse = await http.get(
          Config().apiurl + "getvillage?districtname="+dist+"&tehsil="+tehsil+"&gp="+gp+"");
      print(villageresponse.toString());
      if (villageresponse.statusCode == 200) {
        Iterable i = json.decode(villageresponse.body);
        _village = i.map((model) => VillageModel.fromJSON(model)).toList();
      }
    } catch (e) {
      setState(AppState.Idle);
    }
    setState(AppState.Idle);
    return _village;
  }
}
