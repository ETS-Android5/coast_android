import 'package:coast/controller/feasible.dart';
import 'package:coast/pages/feasiblelandsearch.dart';
import 'package:coast/pages/plotmap.dart';
import 'package:coast/util/appdrawer.dart';
import 'package:coast/utility/appstate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeasibleData extends StatefulWidget {
  FeasibleData({this.dist, this.teh, this.gp, this.vill});
  String dist, teh, gp, vill;
  @override
  _FeasibleDataState createState() => _FeasibleDataState();
}

class _FeasibleDataState extends State<FeasibleData> {
  var _scaffoldkey = GlobalKey<ScaffoldState>();
  List<String> lable = ["District", "Tehsil", "Gram Panchayat", "Village Name"];
  var _textstyleheader = TextStyle(color: Colors.white, fontSize: 16);
  var _textstyledata =
      TextStyle(color: Color.fromRGBO(0, 84, 169, 1), fontSize: 16);

  List<String> upperdata = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) {
      Provider.of<FeasibleController>(context,listen: false)
          .getfeasibledata(widget.dist, widget.teh, widget.gp, widget.vill);
    });
  }

  void onbackPressed(BuildContext context) async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => FeasibleLandSearch()));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(0, 84, 169, 1),
              title: const Text("Feasible Land Search"),
            ),
            drawer: AppDrawer(),
            key: _scaffoldkey,
            body: WillPopScope(
              onWillPop: () async {
                onbackPressed(context);
              },
              child: SingleChildScrollView(
                child: Consumer<FeasibleController>(
                  builder: (context, data, child) {
                    if (data.feasible != null) {
                      upperdata.clear();
                      upperdata.add(widget.dist);
                      upperdata.add(widget.teh);
                      upperdata.add(widget.gp);
                      upperdata.add(widget.vill);
                    }
                    return data.state == AppState.Busy
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Column(
                            children: <Widget>[
                              for (int i = 0; i < lable.length; i++) ...{
                                new Row(
                                  children: <Widget>[
                                    Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            top: 5, left: 20, bottom: 5),
                                        child: Text(
                                          lable[i],
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(0, 84, 169, 1),
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          top: 5, left: 20, bottom: 5),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Color.fromRGBO(0, 84, 169, 1),
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            top: 5, left: 20, bottom: 5),
                                        child: Text(
                                          upperdata[i],
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              },
                              Padding(
                                padding: EdgeInsets.all(10),
                              ),
                              //tabular
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Card(
                                    elevation: 2,
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Flexible(
                                              fit: FlexFit.tight,
                                              flex: 1,
                                              child: Container(
                                                  color: Color.fromRGBO(
                                                      0, 84, 169, 1),
                                                  height: 35,
                                                  child: Center(
                                                    child: Text(
                                                      "Plot No.",
                                                      style: _textstyleheader,
                                                    ),
                                                  )),
                                            ),
                                            Divider(color: Colors.white),
                                            Flexible(
                                              flex: 1,
                                              fit: FlexFit.tight,
                                              child: Container(
                                                  color: Color.fromRGBO(
                                                      0, 84, 169, 1),
                                                  height: 35,
                                                  child: Center(
                                                    child: Text(
                                                      "Kisama",
                                                      style: _textstyleheader,
                                                    ),
                                                  )),
                                            ),
                                            Divider(color: Colors.white),
                                            Flexible(
                                              fit: FlexFit.tight,
                                              flex: 1,
                                              child: Container(
                                                  color: Color.fromRGBO(
                                                      0, 84, 169, 1),
                                                  height: 35,
                                                  child: Center(
                                                    child: Text(
                                                      "Area(ac.)",
                                                      style: _textstyleheader,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )),
                                            ),
                                            Divider(color: Colors.white),
                                            Flexible(
                                              fit: FlexFit.tight,
                                              flex: 1,
                                              child: Container(
                                                  color: Color.fromRGBO(
                                                      0, 84, 169, 1),
                                                  height: 35,
                                                  child: Center(
                                                    child: Text(
                                                      "Map View",
                                                      style: _textstyleheader,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )),
                                            ),
                                          ],
                                        ),
                                        for (int i = 0;
                                            i < data.feasible.length;
                                            i++) ...{
                                          new Row(
                                            children: <Widget>[
                                              //plot
                                              Flexible(
                                                flex: 1,
                                                fit: FlexFit.tight,
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey,
                                                            width: 0.5)),
                                                    height: 40,
                                                    child: Center(
                                                      child: Text(
                                                        data.feasible[i]
                                                            .r_plotno,
                                                        style: _textstyledata,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    )),
                                              ),
                                              Divider(color: Colors.white),
                                              //kisama
                                              Flexible(
                                                fit: FlexFit.tight,
                                                flex: 1,
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey,
                                                            width: 0.5)),
                                                    height: 40,
                                                    child: Center(
                                                      child: Text(
                                                        data.feasible[i]
                                                            .r_kisama,
                                                        style: _textstyledata,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    )),
                                              ),
                                              Divider(color: Colors.white),
                                              //area
                                              Flexible(
                                                fit: FlexFit.tight,
                                                flex: 1,
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey,
                                                            width: 0.5)),
                                                    height: 40,
                                                    child: Center(
                                                      child: Text(
                                                        data.feasible[i].r_area
                                                            .toString(),
                                                        style: _textstyledata,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    )),
                                              ),
                                              Divider(color: Colors.white),
                                              Flexible(
                                                  fit: FlexFit.tight,
                                                  flex: 1,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey,
                                                            width: 0.5)),
                                                    height: 40,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        print(data.feasible[i]
                                                            .r_plotno
                                                            .toString());
                                                        Navigator.of(context)
                                                            .pushReplacement(
                                                          MaterialPageRoute(
                                                            builder: (context) => PlotMap(
                                                                widget.dist,
                                                                widget.teh,
                                                                widget.gp,
                                                                widget.vill,
                                                                data.feasible[i]
                                                                    .r_plotno,
                                                                data.feasible[i]
                                                                    .r_area,
                                                                data.feasible[i]
                                                                    .r_kisama),
                                                          ),
                                                        );
                                                      },
                                                      child: Icon(
                                                        Icons.navigation,
                                                        color: Color.fromRGBO(
                                                            0, 84, 169, 1),
                                                      ),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        }
                                      ],
                                    )),
                              ),
                            ],
                          );
                  },
                ),
              ),
            )),
      ],
    );
  }
}
