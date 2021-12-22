import 'package:coast/controller/gp.dart';
import 'package:coast/controller/tehsil.dart';
import 'package:coast/controller/village.dart';
import 'package:coast/model/TehsilModel.dart';
import 'package:coast/model/gpmodel.dart';
import 'package:coast/model/villagemodel.dart';
import 'package:coast/pages/dashboard.dart';
import 'package:coast/pages/feasibledata.dart';
import 'package:coast/util/appdrawer.dart';
import 'package:coast/utility/appstate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeasibleLandSearch extends StatefulWidget {
  @override
  _FeasibleLandSearchState createState() => _FeasibleLandSearchState();
}

class _FeasibleLandSearchState extends State<FeasibleLandSearch> {
  var _scaffoldkey = GlobalKey<ScaffoldState>();
  var _textstyleheader = TextStyle(
      color: Color.fromRGBO(0, 84, 169, 1),
      fontWeight: FontWeight.bold,
      fontSize: 16);
  List<String> districtDropdown = [
    "Baleshwar",
    "Bhadrak",
    "Cuttack",
    "Ganjam",
    "Jajpur",
    "Khurdha",
    "Puri",
    "Kendrapara",
    "Jagatsinghapur"
  ];
  List<TehsilModel> tehsil = [];
  List<GPModel> gp = [];
  List<VillageModel> village = [];

  List<String> tehsildropdown = [];
  List<String> gpdropdown = [];
  List<String> villagedropdown = [];

  String _selectDist;
  String _selectTehsil, _selectGp, _selectvillage = "all";

  void onbackPressed(BuildContext context) async {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => Dashboard()));
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
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "District",
                              style: _textstyleheader,
                            )),
                      ),
                      //District dropdown
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                              hintText: 'District',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                          value: _selectDist,
                          onChanged: (String newValue) async {
                            setState(() {
                              _selectDist = newValue;
                            });
                            tehsil =
                                await TehsilController().gettehsil(newValue);
                            tehsildropdown.clear();
                            tehsildropdown.add("all");
                            for (int i = 0; i < tehsil.length; i++) {
                              tehsildropdown.add(tehsil[i].text);
                            }
                            setState(() {});
                          },
                          items: districtDropdown
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      //tehsil dropdown
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Tehsil",
                              style: _textstyleheader,
                            )),
                      ),
                      Consumer<TehsilController>(
                        builder: (context, data, child) {
                          return data.state == AppState.Busy
                              ? CircularProgressIndicator()
                              : Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                          hintText: 'Tehsil',
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0))),
                                      value: _selectTehsil,
                                      onChanged: (String newValue) async {
                                        setState(() {
                                          _selectTehsil = newValue;
                                        });
                                        gp = await GPController()
                                            .getgp(_selectDist, _selectTehsil);
                                        gpdropdown.clear();
                                        gpdropdown.add("all");
                                        for (int i = 0; i < gp.length; i++) {
                                          gpdropdown.add(gp[i].text);
                                        }
                                        setState(() {});
                                      },
                                      items: tehsildropdown
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList()),
                                );
                        },
                      ),
                      //Gram dropdown
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Gram Panchayat",
                              style: _textstyleheader,
                            )),
                      ),
                      Consumer<GPController>(
                        builder: (context, data, child) {
                          return data.state == AppState.Busy
                              ? CircularProgressIndicator()
                              : Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                          hintText: 'Gram Panchayat',
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0))),
                                      value: _selectGp,
                                      onChanged: (String newValue) async {
                                        setState(() {
                                          _selectGp = newValue;
                                        });
                                        village = await VillageController()
                                            .getvillage(_selectDist,
                                                _selectTehsil, _selectGp);
                                        villagedropdown.clear();
                                        villagedropdown.add("all");
                                        for (int i = 0;
                                            i < village.length;
                                            i++) {
                                          villagedropdown.add(village[i].text);
                                        }
                                        setState(() {});
                                      },
                                      items: gpdropdown
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList()),
                                );
                        },
                      ),
                      //Village
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Village",
                              style: _textstyleheader,
                            )),
                      ),
                      Consumer<VillageController>(
                        builder: (context, data, child) {
                          return data.state == AppState.Busy
                              ? CircularProgressIndicator()
                              : Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                          hintText: 'Village',
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0))),
                                      value: _selectvillage,
                                      onChanged: (String newValue) async {
                                        setState(() {
                                          _selectvillage = newValue;
                                        });
                                      },
                                      items: villagedropdown
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList()),
                                );
                        },
                      ),
                      //submit buttonF
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                              child: Material(
                            color: Color.fromRGBO(0, 84, 169, 1),
                            child: MaterialButton(
                              height: 50,
                              color: Color.fromRGBO(0, 84, 169, 1),
                              child: new Text('SUBMIT',
                                  style: new TextStyle(
                                      fontSize: 16.0, color: Colors.white)),
                              onPressed: () async {
                                // var a = await data.getfeasibledata(_selectDist,
                                //     _selectTehsil, _selectGp, _selectvillage);
                                print(_selectDist +
                                    " " +
                                    _selectTehsil +
                                    " " +
                                    _selectGp +
                                    " " +
                                    _selectvillage);

                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => FeasibleData(
                                      dist: _selectDist,
                                      teh: _selectTehsil,
                                      gp: _selectGp,
                                      vill: _selectvillage,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ))
      ],
    );
  }
}
