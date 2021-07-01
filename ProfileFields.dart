// @dart=2.9
import 'dart:async';

import 'package:code/services/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileFields extends StatefulWidget {
  @override
    _ProfileFieldsState createState() => _ProfileFieldsState();
  }

class _ProfileFieldsState extends State<ProfileFields> {
  TextEditingController _savedInputController = TextEditingController();
  TextEditingController _logoutController = TextEditingController();
  bool _unsavedText = true;

  ///Text-Field-Controller
  final _email = new TextEditingController();
  final _fuelConsumption = new TextEditingController();
  String _fuelType = "";
  String _userId = "";
  String _userName = "";
  String _documentId = "";
  String errorMessage = "";
  bool saved = false;

  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  @override
  void initState() {
    saveName();
    saveUserId();
    saveUserEmail();

    if (_fuelType == "") {
      _fuelType = "Benzin";
    }

    if (_fuelConsumption.text == "") {
      _fuelConsumption.text = "7";
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);


    return Scaffold(
        body: ListView(children: <Widget>[
          SizedBox(height: 20),
          Column(
            children: <Widget>[
              Container(
                child: Center(
                  child: Text(
                    'Hallo ' + _userName,
                    style: TextStyle(
                      color: Color.fromRGBO(66, 120, 151, 1.0),
                      fontSize: 22.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                child: TextField(
                    enabled: false,
                    controller: _email,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'E-Mail',
                    )),
                height: 75,
                width: 300,
                alignment: Alignment.topCenter,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: TextField(
                    controller: _fuelConsumption,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Kraftstoffverbrauch / 100km',
                    )),
                height: 75,
                width: 300,
                alignment: Alignment.topCenter,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 60,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                      color: Colors.grey, style: BorderStyle.solid, width: 1),
                ),
                child: DropdownButtonHideUnderline(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: ButtonTheme(
                      alignedDropdown: true,
                      minWidth: 100,
                      child: DropdownButton<String>(
                        value: _fuelType,
                        onChanged: (String newValue) {
                          setState(() {
                            _fuelType = newValue;
                          });
                        },
                        items: <String>['Benzin',
                          'Diesel',
                          'Elektro',
                          'Gas']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Visibility(
                visible: errorMessage != "",
                child: Text(
                  errorMessage,
                  style: TextStyle(
                    color: Color.fromRGBO(215, 0, 72, 1.0),
                  ),
                ),
              ),
              Visibility(
                visible: saved,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.check,
                          color: Color.fromRGBO(32, 215, 0, 1.0),
                        ),
                        Text(
                          "gespeichert",
                          style: TextStyle(
                            color: Color.fromRGBO(32, 215, 0, 1.0),
                          ),
                        ),
                      ]
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 50,
                  ),
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(66, 120, 151, 1.0),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              editUser();
                              FocusScope.of(context).unfocus();
                            },
                            child: Text('Speichern'),
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width : 130,
                  ),
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.red,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              final provider =
                              Provider.of<GoogleSignInProvider>(context, listen: false);
                              provider.logout();
                            },
                            child: Text('Abmelden'),
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ]),
    );
  }

  Future saveName() async {
    var result = await _getUserName();
    print(result);
    setState(() {
      _userName = result;
    });
  }

  Future<String> _getUserName() async {
    return FirebaseAuth.instance.currentUser.displayName;
  }

  Future saveUserId() async {
    var result = await _getUserId();
    print(result);
    setState(() {
      _userId = result;
    });

    QuerySnapshot ds = await FirebaseFirestore.instance
        .collection('Users')
        .where('userId', isEqualTo: result)
        .get();

    setState(() {
      String userFuelType;
      try {
        userFuelType = ds.docs[0]["fuelType"];
      } catch (error){
        print(error);
      }

      _fuelConsumption.text = ds.docs[0]["fuelConsumption"].toString();
      _fuelType = userFuelType.replaceAll('Fuel.', '');
      _documentId = ds.docs[0].id;
    });


  }
  Future<String> _getUserId() async {
    return FirebaseAuth.instance.currentUser.uid;
  }

  editUser () async{

    errorMessage = "";

    _fuelConsumption.text = _fuelConsumption.text.replaceAll(',', '.');

    try {
      double.parse(_fuelConsumption.text);
    } catch (error) {
      errorMessage = "Kraftstoffverbrauch muss eine Zahl sein!";
    }

    if (errorMessage == "") {
      if (_documentId != "" ) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(_documentId)
            .update({
          'fuelType': 'Fuel.' + _fuelType,
          'fuelConsumption': double.parse(_fuelConsumption.text)
        }
        ).then((value) => showSaved());
      } else {
        users.add({
          'fuelType': 'Fuel.' + _fuelType,
          'fuelConsumption': double.parse(_fuelConsumption.text),
          'userId': _userId
        }).then((value) {
          saveUserId();
          showSaved();
        });
      }
    }
  }

  void showSaved() {
    setState(() {
      saved = true;
    });
    Timer(Duration(seconds: 1), () {
      setState(() {
        saved = false;
      });
    });
  }

  Future saveUserEmail() async {
    var result = await _getUserEmail();
    print(result);
    setState(() {
      _email.text = result;
    });
  }

  Future<String> _getUserEmail() async {
    return FirebaseAuth.instance.currentUser.email;
  }
}