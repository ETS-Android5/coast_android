import 'package:coast/controller/login.dart';
import 'package:coast/pages/dashboard.dart';
import 'package:coast/utility/appstate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _scaffoldkey = GlobalKey<ScaffoldState>();
  var _formkey = GlobalKey<FormState>();
  bool viewpassword = true;
  void _toggle() {
    setState(() {
      viewpassword = !viewpassword;
    });
  }

  String username = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: Stack(
        children: <Widget>[
          Image.asset(
            "assets/bg.jpg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.only(left: 40, right: 40),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: 400,
                // decoration: BoxDecoration(
                //   //  color: Colors.orange,
                //    // shape: BoxShape.rectangle,
                //     borderRadius: BorderRadius.only(
                //         topLeft: Radius.circular(25.0),
                //         bottomRight: Radius.circular(25.0))),
                width: MediaQuery.of(context).size.width,
                color: Color.fromRGBO(0, 0, 0, 0.65),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Email Id",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 18),
                          ),
                        ),
                        //Email box
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: TextFormField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              prefixIcon: Icon(Icons.person),
                              //labelText: "User Id",
                              border: OutlineInputBorder(),
                            ),
                            validator: (String value) {
                              return value.isEmpty
                                  ? 'Please enter the Username'
                                  : null;
                            },
                            onSaved: (String value) {
                              username = value;
                            },
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 40),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Password",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 18),
                          ),
                        ),
                        //password box
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: TextFormField(
                            obscureText: viewpassword,
                            //style: style,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _toggle();
                                },
                                icon: Icon(viewpassword
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              prefixIcon: Icon(Icons.lock),
                            ),
                            validator: (String value) {
                              return value.isEmpty
                                  ? 'please enter the password'
                                  : null;
                            },
                            onSaved: (String value) {
                              password = value;
                            },
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(),
                            Consumer<LoginController>(
                              builder: (context, data, child) {
                                return data.state == AppState.Busy
                                    ? CircularProgressIndicator()
                                    : Material(
                                        color: Color.fromRGBO(255, 255, 0, 1),
                                        elevation: 5.0,
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        //color: Color.fromARGB(255, 53, 113, 38),
                                        child: MaterialButton(
                                          //  color: Color.fromRGBO(255, 255, 0, 1),
                                          //  minWidth: MediaQuery.of(context).size.width / ,
                                          onPressed: () async {
                                            if (!_formkey.currentState
                                                .validate()) {
                                              return;
                                            } else {
                                              _formkey.currentState.save();
                                              var a = await data.getuserDetails(
                                                  username, password);
                                              if (a.dept_id != null) {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Dashboard(),
                                                  ),
                                                );
                                              } else {
                                                _scaffoldkey.currentState
                                                    .showSnackBar(
                                                  new SnackBar(
                                                    content: Text(
                                                        'Invalid username or password'),
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                          child: Text(
                                            "LOGIN",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18),
                                          ),
                                        ),
                                      );
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "2019 Coastal Aquaculture Information System",
                      style: TextStyle(color: Colors.white60, fontSize: 15),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Developed by SPARC (P) Ltd. under agies of ORSAC",
                        style: TextStyle(color: Colors.white60, fontSize: 15),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
