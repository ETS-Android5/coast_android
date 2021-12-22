import 'dart:io';

import 'package:coast/controller/feasible.dart';
import 'package:coast/controller/gp.dart';
import 'package:coast/controller/insert_field_report.dart';
import 'package:coast/controller/tehsil.dart';
import 'package:coast/controller/village.dart';
import 'package:coast/model/TehsilModel.dart';
import 'package:coast/model/feasibledatamodel.dart';
import 'package:coast/model/gpmodel.dart';
import 'package:coast/model/inser_fieldModel.dart';
import 'package:coast/model/villagemodel.dart';
import 'package:coast/pages/dashboard.dart';
import 'package:coast/util/appdrawer.dart';
import 'package:coast/utility/appstate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FieldReporting extends StatefulWidget {
  @override
  _FieldReportingState createState() => _FieldReportingState();
}

class _FieldReportingState extends State<FieldReporting> {
  var _scaffoldkey = GlobalKey<ScaffoldState>();
  var _formkey = GlobalKey<FormState>();
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
  List<FeasibleDataModel> plot = [];

  List<String> tehsildropdown = [];
  List<String> gpdropdown = [];
  List<String> villagedropdown = [];
  List<String> plotdropdown = [];

  String _selectDist,
      _selectTehsil,
      _selectGp,
      _selectvillage,
      _selectplot,
      _remark = "";
  File _image;
  Position _currentPosition;
  var insrtdata = new InsertFieldModel();
  String lat, lon;

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;

        lat = (position.latitude).toString();
        lon = (position.longitude).toString();
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

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
                child: Form(
                  key: _formkey,
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
                            for (int i = 0; i < tehsil.length; i++) {
                              tehsildropdown.add(tehsil[i].text);
                            }
                            setState(() {});
                          },
                          onSaved: (value) {
                            insrtdata.dist_name = value;
                          },
                          validator: (String value) {
                            if (value?.isEmpty ?? true) {
                              return 'District is required';
                            }
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

                                        for (int i = 0; i < gp.length; i++) {
                                          gpdropdown.add(gp[i].text);
                                        }
                                        setState(() {});
                                      },
                                      validator: (String value) {
                                        if (value?.isEmpty ?? true) {
                                          return 'Tehsil is required';
                                        }
                                      },
                                      onSaved: (value) {
                                        insrtdata.teh_name = value;
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

                                        for (int i = 0;
                                            i < village.length;
                                            i++) {
                                          villagedropdown.add(village[i].text);
                                        }
                                        setState(() {});
                                      },
                                      onSaved: (value) {
                                        insrtdata.gp_name = value;
                                      },
                                      validator: (String value) {
                                        if (value?.isEmpty ?? true) {
                                          return 'Gram Panchayat is required';
                                        }
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
                                        plot = await FeasibleController()
                                            .getfeasibledata(
                                                _selectDist,
                                                _selectTehsil,
                                                _selectGp,
                                                _selectvillage);
                                        plotdropdown.clear();
                                        for (int i = 0; i < plot.length; i++) {
                                          plotdropdown.add(plot[i].r_plotno);
                                        }
                                        setState(() {});
                                      },
                                      onSaved: (value) {
                                        insrtdata.vill_name = value;
                                      },
                                      validator: (String value) {
                                        if (value?.isEmpty ?? true) {
                                          return 'Village is required';
                                        }
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
                      //plot dropdown
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Plot",
                              style: _textstyleheader,
                            )),
                      ),
                      Consumer<FeasibleController>(
                        builder: (context, data, child) {
                          return data.state == AppState.Busy
                              ? CircularProgressIndicator()
                              : Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                          hintText: 'Plot',
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0))),
                                      value: _selectplot,
                                      onChanged: (String newValue) async {
                                        setState(() {
                                          _selectplot = newValue;
                                        });
                                      },
                                      onSaved: (value) {
                                        insrtdata.plot_no = value;
                                      },
                                      validator: (String value) {
                                        if (value?.isEmpty ?? true) {
                                          return 'plot is required';
                                        }
                                      },
                                      items: plotdropdown
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
                      //image
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Capture Image",
                              style: _textstyleheader,
                            )),
                      ),
                      Center(
                        child: _image == null
                            ? Text('No image selected.')
                            : Image.file(_image),
                      ),
                      FloatingActionButton(
                        onPressed: getImage,
                        tooltip: 'Pick Image',
                        child: Icon(Icons.add_a_photo),
                      ),
                      //remark field
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Remarks",
                              style: _textstyleheader,
                            )),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                          initialValue: _remark?.isEmpty ?? true ? "" : _remark,
                          validator: (String value) {
                            return value.isEmpty
                                ? 'Please enter the Remark'
                                : null;
                          },
                          onChanged: (String value) {
                            _remark = value;
                          },
                          onSaved: (String value) {
                            insrtdata.remark = value;
                            print(_remark);
                          },
                        ),
                      ),

                      //submit buttonF
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            child: Consumer<InsertFieldReport>(
                              builder: (context, value, child) {
                                return value.state == AppState.Busy
                                    ? CircularProgressIndicator()
                                    : Material(
                                        color: Color.fromRGBO(0, 84, 169, 1),
                                        child: MaterialButton(
                                          height: 50,
                                          color: Color.fromRGBO(0, 84, 169, 1),
                                          child: new Text('SUBMIT',
                                              style: new TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.white)),
                                          onPressed: () async {
                                            if (_formkey.currentState
                                                .validate()) {
                                              _formkey.currentState.save();
                                              insrtdata.img = _image
                                                  .toString()
                                                  .split('/')
                                                  .last;
                                              insrtdata.lat = lat;
                                              insrtdata.lon = lon;
                                              var insertcontroller = await value
                                                  .insertdata(insrtdata);

                                              Fluttertoast.showToast(
                                                msg: "Data Successfully Stored",
                                              );
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          FieldReporting(),
                                                ),
                                              );
                                            }
                                            return;
                                          },
                                        ),
                                      );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
