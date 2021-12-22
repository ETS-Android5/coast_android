import 'dart:convert';

import 'package:coast/config/default.dart';
import 'package:coast/model/feasibledatamodel.dart';

import 'package:coast/utility/appstate.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class FeasibleController with ChangeNotifier {
  AppState _state = AppState.Idle;
  AppState get state => _state;
  void setState(AppState appState) {
    _state = appState;
    notifyListeners();
  }

  List<FeasibleDataModel> _feasible = [];
  List<FeasibleDataModel> get feasible => _feasible;

  Future<List<FeasibleDataModel>> getfeasibledata(
      String dist, String tehsil, String gp, String vill) async {
        print(dist);
        print(tehsil);
        print(gp);
        print(vill);


    try {
      setState(AppState.Busy);
      var feasibleresponse = await http.get(Config().apiurl +
          "fes_lnd_rpt/?actioncode=FT&dist="+dist+"&teh="+tehsil+"&gramp="+gp+"&vill="+vill+"");
      if (feasibleresponse.statusCode == 200) {
        Iterable i = json.decode(feasibleresponse.body);
        _feasible =
            i.map((model) => FeasibleDataModel.fromJSON(model)).toList();
      }
    } catch (e) {
      setState(AppState.Idle);
    }
    setState(AppState.Idle);
    return _feasible;
  }
}
