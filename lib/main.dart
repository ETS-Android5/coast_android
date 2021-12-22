import 'package:coast/controller/dashboard.dart';
import 'package:coast/controller/feasible.dart';
import 'package:coast/controller/gp.dart';
import 'package:coast/controller/insert_field_report.dart';
import 'package:coast/controller/login.dart';
import 'package:coast/controller/plotmap.dart';
import 'package:coast/controller/tehsil.dart';
import 'package:coast/controller/village.dart';
import 'package:coast/pages/dashboard.dart';
import 'package:coast/pages/demo.dart';
import 'package:coast/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => LoginController(),
          ),
          ChangeNotifierProvider(
            create: (_) => DashboardController(),
          ),
          ChangeNotifierProvider(
            create: (_) => TehsilController(),
          ),
          ChangeNotifierProvider(
            create: (_) => GPController(),
          ),
          ChangeNotifierProvider(
            create: (_) => VillageController(),
          ),
          ChangeNotifierProvider(
            create: (_) => FeasibleController(),
          ),
          ChangeNotifierProvider(
            create: (_) => PlotMapController(),
          ),
          ChangeNotifierProvider(
            create: (_) => InsertFieldReport(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'COAST',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MyHomePage(),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  SharedPreferences sharedPreferences;
  Future<Timer> loadData() async {
    return Timer(Duration(seconds: 2), onDoneLoading);
  }

//Navigate to next page
  onDoneLoading() async {
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(
    //     builder: (context) => LoginPage(),
    //   ),
    // );
    sharedPreferences = await SharedPreferences.getInstance();
    var user = sharedPreferences.getString("uname");
    if (user != null && user != "") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Dashboard(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: new BoxDecoration(
          image: new DecorationImage(
              image: new AssetImage("assets/splash_screen.jpg"),
              fit: BoxFit.fill),
        ),
      ),
    );
  }
}
