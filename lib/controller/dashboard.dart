import 'dart:convert';

import 'package:coast/config/default.dart';
import 'package:coast/model/dashboardmodel.dart';
import 'package:coast/utility/appstate.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class DashboardController with ChangeNotifier {
  AppState _state = AppState.Idle;
  AppState get state => _state;
  void setState(AppState appState) {
    _state = appState;
    notifyListeners();
  }

  DashboardModel dashboardModel = new DashboardModel();
  DashboardModel get dash => dashboardModel;

  Future<DashboardModel> getdashDetails() async {
    try {
      setState(AppState.Busy);
      var dashResponse =
          await http.get(Config().apiurl + "Dashboardfilter/?dist=all");
      if (dashResponse.statusCode == 200) {
        //Itera i=json.decode(dashResponse.body);
        dashboardModel =
            DashboardModel.fromJson(json.decode(dashResponse.body));
      }
    } catch (e) {
      setState(AppState.Idle);
    }
    setState(AppState.Idle);
    return dashboardModel;
  }
}
