import 'package:flutter/foundation.dart';
import '../utility/appstate.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlotMapController with ChangeNotifier {
  AppState _state = AppState.Idle;
  AppState get state => _state;
  void setState(AppState appState) {
    _state = appState;
    notifyListeners();
  }

  var adminunit_response;
  Future<dynamic> getgeojson(String url, String query) async {
    try {
      print("" + url + " " + query + "");
      adminunit_response = await http.get("" + url + " " + query + "");
      if (adminunit_response.statusCode == 200) {
        print(adminunit_response.body);
        var admin = adminunit_response.body;
        if (admin = null) {}
      }
    } catch (e) {
      print(e);
    }
    setState(AppState.Idle);
    return adminunit_response.body;
  }
}
