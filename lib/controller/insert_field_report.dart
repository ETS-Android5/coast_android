import 'dart:convert';

import 'package:coast/config/default.dart';
import 'package:coast/model/inser_fieldModel.dart';
import 'package:coast/utility/appstate.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class InsertFieldReport with ChangeNotifier {
  AppState _state = AppState.Idle;
  AppState get state => _state;
  void setState(AppState appState) {
    _state = appState;
    notifyListeners();
  }

  Future insertdata(InsertFieldModel insertFieldModel) async {
    bool result = false;
    try {
      setState(AppState.Busy);
      var feasibleresponse = await http.post(
        Config().apiurl + "insert_field_data",
        headers: {"Content-Type": "application/json"},
        body: json.encode(insertFieldModel.toJson()),
      );
      if (feasibleresponse.statusCode == 200) {
        result = true;
      }
    } catch (e) {
      print(e);
    }
    setState(AppState.Idle);
    return result;
  }
}
