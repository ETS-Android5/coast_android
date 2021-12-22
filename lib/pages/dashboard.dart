import 'package:coast/controller/dashboard.dart';
import 'package:coast/util/appdrawer.dart';
import 'package:coast/utility/appstate.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var _scaffoldkey = GlobalKey<ScaffoldState>();
  var _textstyleheader =
      TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14);

  List<charts.Series> seriesList, aquaList, farmlist;
  List<String> tabletilteData = [
    'No. of Tehsil',
    'No. of Villages',
    'Aquaculture Pond Area',
    'No. of Registered Farms',
    'Feasible Govt. Land Area'
  ];
  List<String> tablefigureData = [];
  List<Sales> aquachartdata = [];
  List<Sales> feasibleLandChart = [];
  List<Sales> registerfamChart = [];
  DateTime backbuttonpressedTime;
  @override
  void initState() {
    super.initState();
    seriesList = _createFeasibleData();
    aquaList = _createAquaData();
    farmlist = _createFarmData();
    Future.delayed(Duration.zero).then((_) {
      Provider.of<DashboardController>(context,listen: false).getdashDetails();
    });
  }

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    //Statement 1 Or statement2
    bool backButton = backbuttonpressedTime == null ||
        currentTime.difference(backbuttonpressedTime) > Duration(seconds: 3);
    if (backButton) {
      backbuttonpressedTime = currentTime;
      Fluttertoast.showToast(
          msg: "Double Click to exit app",
          backgroundColor: Colors.black,
          textColor: Colors.white);

      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(0, 84, 169, 1),
              title: const Text("Dashboard"),
            ),
            drawer: AppDrawer(),
            key: _scaffoldkey,
            body: WillPopScope(
              onWillPop: onWillPop,
              child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Consumer<DashboardController>(
                      builder: (context, data, child) {
                        if (data.dash != null) {
                          if (!(data.dash.aquapondinfoChart?.isEmpty ?? true)) {
                            tablefigureData.clear();
                            tablefigureData.add(data.dash.tehsil.toString());
                            tablefigureData.add(data.dash.vill.toString());
                            tablefigureData
                                .add(data.dash.aqpndcount.toString());
                            tablefigureData
                                .add(data.dash.reglandcount.toString());
                            tablefigureData
                                .add(data.dash.feslndcount.toString());
                            for (int i = 0;
                                i < data.dash.aquapondinfoChart.length;
                                i++) {
                              aquachartdata.add(Sales(
                                  data.dash.aquapondinfoChart[i].rDistnmAqp,
                                  data.dash.aquapondinfoChart[i].rSumareaAqp));
                            }
                            for (int i = 0;
                                i < data.dash.govtlandinfoChart.length;
                                i++) {
                              feasibleLandChart.add(Sales(
                                  data.dash.govtlandinfoChart[i].rDistnm,
                                  data.dash.govtlandinfoChart[i].rSubfesland));
                            }
                            for (int i = 0;
                                i < data.dash.aquapondRegfarmInfo.length;
                                i++) {
                              registerfamChart.add(Sales(
                                  data.dash.aquapondRegfarmInfo[i].rDistnm,
                                  data.dash.aquapondRegfarmInfo[i]
                                      .rSumareaaqua));
                            }
                          }
                        }
                        return data.state == AppState.Busy
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "DASHBOARD",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 20),
                                  ),
                                  Text(
                                    "Study Area Details",
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 84, 169, 1),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  //Tabular
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Card(
                                      elevation: 2,
                                      child: DataTable(
                                        columns: [
                                          DataColumn(
                                              label: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      11,
                                                  child: Text('Sl No.',
                                                      style:
                                                          _textstyleheader))),
                                          DataColumn(
                                              label: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                7,
                                            child: Text(
                                              'Title',
                                              style: _textstyleheader,
                                              textAlign: TextAlign.center,
                                            ),
                                          )),
                                          DataColumn(
                                            label: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  9,
                                              child: Text('Figure',
                                                  style: _textstyleheader),
                                            ),
                                          ),
                                        ],
                                        rows: [
                                          for (int i = 0;
                                              i < tabletilteData.length;
                                              i++) ...{
                                            new DataRow(cells: [
                                              DataCell(Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      10,
                                                  child: Text(
                                                      (i + 1).toString()))),
                                              DataCell(Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3.5,
                                                  child: Text(
                                                    tabletilteData[i],
                                                  ))),
                                              DataCell(Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3,
                                                  child:
                                                      Text(tablefigureData[i])))
                                            ])
                                          }
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 20),
                                  ),
                                  Text(
                                    "Feasible Land Information(in Ha.)",
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 84, 169, 1),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 300,
                                    child: Card(
                                      elevation: 2,
                                      child: barChart(),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 20),
                                  ),
                                  Text(
                                    "Aqua Pond Information(in Ha.)",
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 84, 169, 1),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 300,
                                    child: Card(
                                      elevation: 2,
                                      child: aquabarChart(),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 20),
                                  ),
                                  Text(
                                    "Registered Farm Information(in Ha.)",
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 84, 169, 1),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 300,
                                    child: Card(
                                      elevation: 2,
                                      child: registerFarmbarChart(),
                                    ),
                                  ),
                                ],
                              );
                      },
                    )),
              ),
            ))
      ],
    );
  }

  List<charts.Series<Sales, String>> _createFeasibleData() {
    return [
      charts.Series<Sales, String>(
        id: 'Sales1',
        domainFn: (Sales sales, _) => sales.year,
        measureFn: (Sales sales, _) => sales.sales,
        data: feasibleLandChart,
        labelAccessorFn: (Sales sales, _) => sales.sales.toString(),
        fillColorFn: (Sales sales, _) {
          return charts.MaterialPalette.red.shadeDefault;
        },
      ),
    ];
  }

  List<charts.Series<Sales, String>> _createAquaData() {
    return [
      charts.Series<Sales, String>(
        id: 'Sales',
        domainFn: (Sales sales, _) => sales.year,
        measureFn: (Sales sales, _) => sales.sales,
        data: aquachartdata,
        labelAccessorFn: (Sales sales, _) => sales.sales.toString(),
        fillColorFn: (Sales sales, _) {
          return charts.MaterialPalette.blue.shadeDefault;
        },
      ),
    ];
  }

  List<charts.Series<Sales, String>> _createFarmData() {
    return [
      charts.Series<Sales, String>(
        id: 'Sales',
        domainFn: (Sales sales, _) => sales.year,
        measureFn: (Sales sales, _) => sales.sales,
        data: registerfamChart,
        labelAccessorFn: (Sales sales, _) => sales.sales.toString(),
        fillColorFn: (Sales sales, _) {
          return charts.MaterialPalette.green.shadeDefault;
        },
      ),
    ];
  }

  barChart() {
    return charts.BarChart(
      seriesList,
      animate: false,
      vertical: true,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      domainAxis: new charts.OrdinalAxisSpec(
          viewport: new charts.OrdinalViewport('', 4)),
      behaviors: [new charts.PanAndZoomBehavior()],
    );
  }

  aquabarChart() {
    return charts.BarChart(
      aquaList,
      animate: true,
      vertical: true,
      // barGroupingType: charts.BarGroupingType.grouped,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      //sliding starting from ganjam and 7 for how many bar in a screen
      domainAxis: new charts.OrdinalAxisSpec(
          viewport: new charts.OrdinalViewport('Ganjam', 5)),
      // Optionally add a pan or pan and zoom behavior.
      // If pan/zoom is not added, the viewport specified remains the viewport.
      behaviors: [new charts.PanAndZoomBehavior()],
    );
  }

  registerFarmbarChart() {
    return charts.BarChart(
      farmlist,
      animate: true,
      vertical: true,
      // barGroupingType: charts.BarGroupingType.grouped,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      //sliding starting from ganjam and 7 for how many bar in a screen
      domainAxis: new charts.OrdinalAxisSpec(
          viewport: new charts.OrdinalViewport('Ganjam', 5)),
      // Optionally add a pan or pan and zoom behavior.
      // If pan/zoom is not added, the viewport specified remains the viewport.
      behaviors: [new charts.PanAndZoomBehavior()],
    );
  }
}

class Sales {
  final String year;
  final double sales;
  Sales(this.year, this.sales);
}
