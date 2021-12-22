import 'package:coast/controller/plotmap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:map_controller/map_controller.dart';
import 'package:latlong/latlong.dart';
import 'package:geojson/geojson.dart';
import 'package:geopoint/geopoint.dart';
import 'dart:async';
import 'package:pedantic/pedantic.dart';
import 'package:provider/provider.dart';

import 'feasibledata.dart';
import 'package:platform/platform.dart';
import 'package:android_intent/android_intent.dart';
import 'package:geolocator/geolocator.dart';

class PlotMap extends StatefulWidget {
  PlotMap(this.dist, this.teh, this.gp, this.vill, this.plotno, this.area,
      this.kisama);
  String dist, teh, gp, vill, plotno, kisama;
  double area;
  @override
  _PlotMapState createState() => _PlotMapState();
}

class _PlotMapState extends State<PlotMap> {
  var _scaffoldkey = GlobalKey<ScaffoldState>();
  String _value = 'm', origin, destination;
  double lat = 0.0, lon = 0.0;
  MapController mapController;
  final polygons = <Polygon>[];
  StatefulMapController statefulMapController;
  LatLng currentmove = new LatLng(20.340905, 85.805739);
  String url, plotlat, plotlon;
  StreamSubscription<StatefulMapControllerStateChange> sub;
  final _markersOnMap = [];
  var _textStyleinfo = TextStyle(color: Colors.black, fontSize: 17);
  Position _currentPosition;

  void onbackPressed(BuildContext context) async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => FeasibleData(
                  dist: widget.dist,
                  teh: widget.teh,
                  gp: widget.gp,
                  vill: widget.vill,
                )));
  }

  //basemap
  Widget basemapDropdown() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 10),
          margin: EdgeInsets.only(left: 10, top: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
                color: Colors.black, style: BorderStyle.solid, width: 0.5),
          ),
          child: DropdownButton<String>(
            items: [
              DropdownMenuItem<String>(
                child: Text('Satelite'),
                value: 's',
              ),
              DropdownMenuItem<String>(
                child: Text('Hybrid'),
                value: 'y',
              ),
              DropdownMenuItem<String>(
                child: Text('Terrain'),
                value: 'p',
              ),
              DropdownMenuItem<String>(
                child: Text('Normal'),
                value: 'm',
              ),
            ],
            onChanged: (String value) {
              setState(() {
                _value = value;
                fluttermap(_value, lat, lon);
              });
              _value = value;
              fluttermap(_value, lat, lon);
            },
            hint: Text('Select Basemap'),
            value: _value,
            underline: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.transparent),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  //multi polygon
  Future<void> processData({dynamic json32, Color color}) async {
    polygons.clear();
    final geojson = GeoJson();
    geojson.processedMultipolygons.listen((GeoJsonMultiPolygon multiPolygon) {
      for (final polygon in multiPolygon.polygons) {
        final geoSerie = GeoSerie(
            type: GeoSerieType.polygon,
            name: polygon.geoSeries[0].name,
            geoPoints: <GeoPoint>[]);
        for (final serie in polygon.geoSeries) {
          geoSerie.geoPoints.addAll(serie.geoPoints);
        }
        print(polygon.geoSeries[0].name);
        currentmove = new LatLng(
            geoSerie.geoPoints[0].latitude, geoSerie.geoPoints[0].longitude);
        plotlat = (geoSerie.geoPoints[0].latitude).toString();
        plotlon = (geoSerie.geoPoints[0].longitude).toString();
        destination = plotlat + "," + plotlon;
        statefulMapController.centerOnPoint(currentmove);
        statefulMapController.zoomTo(19);
        final poly = Polygon(
            points: geoSerie.toLatLng(ignoreErrors: true),
            color: Colors.transparent,
            borderStrokeWidth: 3.0,
            borderColor: color); // isDotted: true'
        polygons.add(poly);
        // setState(() => polygons.add(poly));
      }
    });
    geojson.endSignal.listen((bool _) => geojson.dispose());
    // The data is from https://datahub.io/core/geo-countries
    //final data = await rootBundle.loadString('assets/countries.geojson');

    final nameProperty = "ADMIN";
    unawaited(geojson.parse(json32, nameProperty: nameProperty, verbose: true));
  }

  @override
  void initState() {
    switch (widget.dist) {
      case "Baleshwar":
        {
          url =
              "http://14.98.253.212:8080/geoserver/COAST_MOBILE/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=COAST_MOBILE:Mobile_Baleshwar_Feasible_Land&maxFeatures=50&outputFormat=application%2Fjson&CQL_FILTER=";
        }
        break;
      case "Bhadrak":
        {
          url =
              "http://14.98.253.212:8080/geoserver/COAST_MOBILE/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=COAST_MOBILE:Mobile_Bhadrak_Feasible_Land&maxFeatures=50&outputFormat=application%2Fjson&CQL_FILTER=";
        }
        break;
      case "Cuttack":
        {
          url =
              "http://14.98.253.212:8080/geoserver/COAST_MOBILE/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=COAST_MOBILE:Mobile_Cuttack_Feasible_Land&maxFeatures=50&outputFormat=application%2Fjson&CQL_FILTER=";
        }

        break;
      case "Ganjam":
        {
          url =
              "http://14.98.253.212:8080/geoserver/COAST_MOBILE/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=COAST_MOBILE:Mobile_Ganjam_Feasible_Land&maxFeatures=50&outputFormat=application%2Fjson&CQL_FILTER=";
        }
        break;
      case "Jagatsinghapur":
        {
          url =
              "http://14.98.253.212:8080/geoserver/COAST_MOBILE/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=COAST_MOBILE:Mobile_Jagatsinghapur_Feasible_Land&maxFeatures=50&outputFormat=application%2Fjson&CQL_FILTER=";
        }
        break;
      case "Jajpur":
        {
          url =
              "http://14.98.253.212:8080/geoserver/COAST_MOBILE/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=COAST_MOBILE:Mobile_Jajpur_Feasible_Land&maxFeatures=50&outputFormat=application%2Fjson&CQL_FILTER=";
        }
        break;
      case "Kendrapara":
        {
          url =
              "http://14.98.253.212:8080/geoserver/COAST_MOBILE/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=COAST_MOBILE:Mobile_Kendrapara_Feasible_Land&maxFeatures=50&outputFormat=application%2Fjson&CQL_FILTER=";
        }
        break;
      case "Khurdha":
        {
          url =
              "http://14.98.253.212:8080/geoserver/COAST_MOBILE/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=COAST_MOBILE:Mobile_Khurdha_Feasible_Land&maxFeatures=50&outputFormat=application%2Fjson&CQL_FILTER=";
        }
        break;
      case "Puri":
        {
          url =
              "http://14.98.253.212:8080/geoserver/COAST_MOBILE/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=COAST_MOBILE:Mobile_Puri_Feasible_Land&maxFeatures=50&outputFormat=application%2Fjson&CQL_FILTER=";
        }
        break;

      default:
        break;
    }

    String cqlQuery = "dist_name='" +
        widget.dist +
        "' and teh_name='" +
        widget.teh +
        "' and gp_name='" +
        widget.gp +
        "' and vill_name='" +
        widget.vill +
        "' and plot_no='" +
        widget.plotno +
        "'";
    mapController = MapController();
    statefulMapController = StatefulMapController(mapController: mapController);
    Future.delayed(Duration.zero).then((_) {
      //  Provider.of<PlotMapController>(context, listen: false).getgeojson(url,cqlQuery);

      Provider.of<PlotMapController>(context, listen: false)
          .getgeojson(url, cqlQuery)
          .then((onValue) {
        processData(json32: onValue, color: Colors.blue);
      }).catchError((onError) {});
    });
    sub = statefulMapController.changeFeed.listen((change) => setState(() {}));

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
        origin = (position.latitude).toString() +
            "," +
            (position.longitude).toString();
        print("current   " + _currentPosition.toString());
      });
    }).catchError((e) {
      print(e);
    });
  }

  Widget fluttermap(String value, double lat, double lon) {
    return Container(
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: LatLng(20.1754, 84.4053),
          zoom: 8,
          onTap: (latlng) {
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width * 0.2,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                        width: 8,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Tehsil : " + widget.teh + "",
                            style: _textStyleinfo,
                          ),
                          Divider(
                            color: Colors.black54,
                          ),
                          Text(
                            "Village : " + widget.vill + "",
                            style: _textStyleinfo,
                          ),
                          Divider(
                            color: Colors.black54,
                          ),
                          Text(
                            "Plot No : " + widget.plotno + "",
                            style: _textStyleinfo,
                          ),
                          Divider(
                            color: Colors.black54,
                          ),
                          Text(
                            "Area (in ac.) : " + (widget.area).toString() + "",
                            style: _textStyleinfo,
                          ),
                          Divider(
                            color: Colors.black54,
                          ),
                          Text(
                            "Kisama : " + widget.kisama + "",
                            style: _textStyleinfo,
                          ),
                          Divider(
                            color: Colors.black54,
                          ),
                          Text(
                            "Latitude : " + plotlat + "",
                            style: _textStyleinfo,
                          ),
                          Divider(
                            color: Colors.black54,
                          ),
                          Text(
                            "Longitude : " + plotlon + "",
                            style: _textStyleinfo,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        layers: [
          TileLayerOptions(
            urlTemplate:
                "https://mt.google.com/vt/lyrs=" + value + "&x={x}&y={y}&z={z}",
            subdomains: ['a', 'b', 'c'],
          ),
          PolygonLayerOptions(polygons: polygons),
          MarkerLayerOptions(
            markers: statefulMapController.markers,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         // origin = "20.307515,85.8090322";
          //destination = "20.34091,85.8035503";
          print("or  "+origin.toString());
          print("dest  "+destination.toString());
          if (new LocalPlatform().isAndroid) {
            final AndroidIntent intent = new AndroidIntent(
                action: 'action_view',
                data: Uri.encodeFull(
                    "https://www.google.com/maps/dir/?api=1&origin=" +
                        origin +
                        "&destination=" +
                        destination +
                        "&travelmode=driving&dir_action=navigate"),
                package: 'com.google.android.apps.maps');
            intent.launch();
          }
          // // else {
          // //     String url = "https://www.google.com/maps/dir/?api=1&origin=" + origin + "&destination=" + destination + "&travelmode=driving&dir_action=navigate";
          // //     if (await canLaunch(url)) {
          // //           await launch(url);
          // //    } else {
          // //         throw 'Could not launch $url';
          // //    }
          // // }
        },
        child: Icon(Icons.navigation),
        backgroundColor: Colors.green,
      ),
      body: WillPopScope(
        onWillPop: () async {
          onbackPressed(context);
        },
        child: SafeArea(
          key: _scaffoldkey,
          child: Stack(
            children: <Widget>[
              //map
              fluttermap(_value, lat, lon),

              //layer dropdown
              basemapDropdown(),
            ],
          ),
        ),
      ),
    );
  }
}
