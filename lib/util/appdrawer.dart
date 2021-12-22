import 'package:coast/pages/dashboard.dart';
import 'package:coast/pages/feasiblelandsearch.dart';
import 'package:coast/pages/fieldreporting.dart';
import 'package:flutter/material.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class AppDrawer extends StatefulWidget {
  AppDrawer({this.pageindex});
  final int pageindex;
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  int _selectedDrawerIndex = 0;
  final drawerItems = [
    DrawerItem("DASHBOARD", Icons.dashboard), //page index = 0
    DrawerItem("FEASIBLE LAND SEARCH", Icons.search), //page index = 1
    DrawerItem("FIELD REPORTING", Icons.report),
   // DrawerItem("USER PROFILE", Icons.supervised_user_circle),
    DrawerItem("HELP", Icons.help)
  ];

  @override
  void initState() {
    setpageindex(widget.pageindex);
    // Future.delayed(Duration.zero).then((_) {
    //   getUserInfo();
    // });
    super.initState();
  }

  setpageindex(int index) {
    setState(() {
      _selectedDrawerIndex = index;
    });
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    _pageNavigator(_selectedDrawerIndex);
    //Navigator.of(context).pop();
    // close the drawer
  }

  _pageNavigator(int page) {
    if (page == 0) {
      _navfunction(Dashboard());
    } else if (page == 1) {
      _navfunction(FeasibleLandSearch()); 

    } else if (page == 2) {
      _navfunction(FieldReporting()); 
    }
    //  else if (page == 3) {
    //   _navfunction(Report());
    // } else if (page == 4) {
    //   _navfunction(AdministrativeUvit());
    // }
  }

  _navfunction(Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => page),
    );
  }

  Widget customListView({IconData iconData, String titel, int index}) {
    return Wrap(
      children: <Widget>[
        ListTile(
          leading: new Icon(
            iconData,
            color: Colors.white,
          ),
          title: new Text(
            titel,
            style: TextStyle(color: Colors.white),
          ),
          selected: index == _selectedDrawerIndex,
          onTap: () => _onSelectItem(index),
        ),
        Divider(
          color: Colors.white,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < drawerItems.length; i++) {
      var d = drawerItems[i];
      drawerOptions
          .add(customListView(iconData: d.icon, titel: d.title, index: i));
      // drawerOptions.add(
      //   new ListTile(
      //     leading: new Icon(
      //       d.icon,
      //       color: Colors.white,
      //     ),
      //     title: new Text(
      //       d.title,
      //       style: TextStyle(color: Colors.white),
      //     ),
      //     selected: i == _selectedDrawerIndex,
      //     onTap: () => _onSelectItem(i),
      //   ),
      // );
    }

    return Container(
      child: Drawer(
        child: Container(
          color: Color.fromRGBO(0, 84, 169, 1),
          child: Column(
            children: <Widget>[
              Divider(),
              Divider(),
              Column(
                children: drawerOptions,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
