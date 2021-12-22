import 'dart:convert';

import 'package:coast/config/default.dart';
import 'package:coast/model/TehsilModel.dart';
import 'package:coast/utility/appstate.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class TehsilController with ChangeNotifier {
  AppState _state = AppState.Idle;
  AppState get state => _state;
  void setState(AppState appState) {
    _state = appState;
    notifyListeners();
  }

  // TehsilModel _tehsil = new TehsilModel();
  // TehsilModel get tehsil => _tehsil;

  List<TehsilModel> _tehsil = [];
  List<TehsilModel> get tehsil => _tehsil;

  Future<List<TehsilModel>> gettehsil(String dist) async {
    try {
      setState(AppState.Busy);
      var loginResponse =
          await http.get(Config().apiurl + "get_tehsil?dist=" + dist + "");
      print(loginResponse.toString());
      if (loginResponse.statusCode == 200) {
        Iterable i = json.decode(loginResponse.body);
        _tehsil = i.map((model) => TehsilModel.fromJSON(model)).toList();

        //  _tehsil = TehsilModel.fromJSON(json.decode(loginResponse.body));
      }
    } catch (e) {
      setState(AppState.Idle);
    }
    setState(AppState.Idle);
    return _tehsil;
  }
}
