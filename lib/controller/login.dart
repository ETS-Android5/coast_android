import 'package:coast/config/default.dart';
import 'package:coast/model/loginmodel.dart';
import 'package:coast/utility/appstate.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController with ChangeNotifier {
  AppState _state = AppState.Idle;
  AppState get state => _state;
  void setState(AppState appState) {
    _state = appState;
    notifyListeners();
  }

  LoginModel _login = new LoginModel();
  LoginModel get login => _login;
  String prefUser;

  Future<LoginModel> getuserDetails(String username, String pass) async {
    try {
      setState(AppState.Busy);
      var loginResponse = await http.get(
          Config().apiurl + "UserInfo/?uid=" + username + "&pass=" + pass + "");
      print(loginResponse.toString());
      if (loginResponse.statusCode == 200) {
        _login = LoginModel.fromJSON(json.decode(loginResponse.body));

        prefUser = _login.user_name;
        var prefs = await SharedPreferences.getInstance();
        prefs.setString('uname', prefUser);
      }
      setState(AppState.Idle);
    } catch (e) {
      setState(AppState.Idle);
    }
    return _login;
  }
}
