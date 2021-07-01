// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code/Activity/ActivityWarehouse.dart';
import 'package:code/profile/Fuel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'Activity.dart';
import 'ActivityList.dart';

class Activities extends StatefulWidget {
  @override
  _Activities createState() => _Activities();
}

class _Activities extends State<Activities> {
  ActivityWarehouse warehouse = ActivityWarehouse();
  bool check = false;
  bool doCreate = false;
  String errorMessage = "";

  Position _position;

  String _dropdownValue = "Kategorie";

  ///TextField-Label
  String _field1 = '';
  String _field2 = '';
  bool _isChecked = false;

  bool _isFlight = false;
  bool _isEating = false;
  String _flightClass = 'Economy';
  String _food = 'Fleisch';

  ///Text-Field-Size
  bool _fieldVis1 = false;
  bool _fieldVis2 = false;
  bool _fieldVis3 = false;
  bool _descriptionVis = false;

  ///Text-Field-Controller
  final _fieldCon1 = new TextEditingController();
  final _fieldCon2 = new TextEditingController();
  final _description = new TextEditingController();

  ///Aktivitätsauswahl
  int _activityChoice;

  String _userId = "";

  //hier evtl weitere Felder initialisieren
  //bzw. Firebase-Aktivitätsinstanzen initialisieren
  // CollectionReference flyingActivities = FirebaseFirestore.instance.collection('FlyingActivities');
  // CollectionReference drivingActivities = FirebaseFirestore.instance.collection('DrivingActivities');
  // CollectionReference eatingActivities = FirebaseFirestore.instance.collection('EatingActivities');

  CollectionReference activities =
      FirebaseFirestore.instance.collection('Activities');

  @override
  void initState() {
    saveUserId();
    warehouse.sortWarehouse();
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    /// ACTIVITY-LIST
    if (!doCreate) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          child: ActivityList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              doCreate = !doCreate;
            });
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    } else
      /// ACTIVITY-CREATION
      return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
              child: Column(children: <Widget>[
            SizedBox(height: 20),
            CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 30,
                child: _selectCategory(_dropdownValue)),
            SizedBox(height: 20),
            Container(
              child: Container(
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
                        value: _dropdownValue,
                        onChanged: (String newValue) {
                          setState(() {
                            _dropdownValue = newValue;
                            _selectItem();
                            _cleanUp();
                          });
                        },
                        items: <String>[
                          'Kategorie',
                          'Flug',
                          'Autofahrt',
                          'Essen'
                        ].map<DropdownMenuItem<String>>((String value) {
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
              alignment: Alignment.center,
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: _descriptionVis,
                  child: Container(
                    height: 60,
                    width: 300,
                    child: TextField(
                        controller: _description,
                        onEditingComplete: () => node.nextFocus(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Beschreibung',
                        )),
                    alignment: Alignment.topCenter,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: _fieldVis1,
                  child: Container(
                    child: TextField(
                        controller: _fieldCon1,
                        onEditingComplete: () => node.nextFocus(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: _field1,
                        )),
                    height: 75,
                    width: 300,
                    alignment: Alignment.topCenter,
                  ),
                ),
                Visibility(
                  visible: _isEating,
                  child: Container(
                    height: 60,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: Colors.grey,
                          style: BorderStyle.solid,
                          width: 1),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: ButtonTheme(
                          alignedDropdown: true,
                          minWidth: 100,
                          child: DropdownButton<String>(
                            value: _food,
                            onChanged: (String newValue) {
                              setState(() {
                                _food = newValue;
                                node.nextFocus();
                              });
                            },
                            items: <String>[
                              'Fleisch',
                              'Fisch',
                              'Gemüse',
                              'Obst',
                              'Brot'
                            ].map<DropdownMenuItem<String>>((String value) {
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
                ),
                Visibility(
                  visible: !_isFlight,
                  child: SizedBox(
                    height: 10,
                  ),
                ),
                Visibility(
                  visible: _fieldVis2 && !_isFlight,
                  child: Container(
                    child: TextField(
                        onEditingComplete: () => node.nextFocus(),
                        controller: _fieldCon2,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: _field2,
                        )),
                    height: 75,
                    width: 300,
                    alignment: Alignment.topCenter,
                  ),
                ),
                Visibility(
                  visible: _isFlight,
                  child: Container(
                    height: 60,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: Colors.grey,
                          style: BorderStyle.solid,
                          width: 1),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: ButtonTheme(
                          alignedDropdown: true,
                          minWidth: 100,
                          child: DropdownButton<String>(
                            value: _flightClass,
                            onChanged: (String newValue) {
                              setState(() {
                                _flightClass = newValue;
                                node.nextFocus();
                              });
                            },
                            items: <String>['Economy', 'Business', 'First']
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
                ),
                Visibility(
                  visible: _fieldVis3,
                  child: Container(
                    child: CheckboxListTile(
                        title: Text("One-Way"),
                        checkColor: Colors.white,
                        value: _isChecked,
                        onChanged: (bool value) {
                          setState(() {
                            _isChecked = !_isChecked;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading),
                    padding: EdgeInsets.only(right: 50, left: 25),
                    alignment: Alignment.topCenter,
                  ),
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
              ],
            )
          ])),
          floatingActionButton: Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _cleanUp();
                      doCreate = !doCreate;
                    });
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.grey,
                  ),
                  backgroundColor: Colors.white,
                ),
                FloatingActionButton(
                  onPressed: () async {
                    await _createActivity();
                  },
                  child: Icon(
                    Icons.check,
                    color: Colors.grey,
                  ),
                  backgroundColor: Colors.white,
                ),
              ])));
  }

  void _selectItem() {
    if (_dropdownValue == "Autofahrt") {
      //das erste Feld wird benötigt
      _fieldVis2 = _fieldVis3 = _isFlight = _isEating = false;
      _fieldVis1 = _descriptionVis = true;

      _field1 = "Distanz in km";
      _field2 = "";
      _activityChoice = 1;
    } else if (_dropdownValue == "Essen") {
      //die ersten zwei Felder werden benötigt
      _fieldVis1 = _fieldVis2 = _isEating = _descriptionVis = true;
      _fieldVis3 = _isFlight = _fieldVis1 = false;

      _field1 = "Speise";
      _field2 = "Gewicht in Gramm";
      _activityChoice = 2;
    } else if (_dropdownValue == "Flug") {
      _fieldVis1 = _fieldVis2 = _fieldVis3 = _isFlight = _descriptionVis = true;

      _isEating = false;

      //Alle drei Felder werden benötigt
      _field1 = "Distanz in km";
      _field2 = "Flug-Klasse";
      _activityChoice = 3;
    } else {
      _fieldVis1 = _fieldVis2 =
          _fieldVis3 = _isFlight = _isEating = _descriptionVis = false;

      _field1 = _field2 = "";
      _activityChoice = 0;
    }
  }

  Future<void> _createActivity() async {
    String positionString = "";
    errorMessage = "";

    _fieldCon1.text = _fieldCon1.text.replaceAll(',', '.');
    _fieldCon2.text = _fieldCon2.text.replaceAll(',', '.');

    if (_activityChoice != 2) {
      try {
        double.parse(_fieldCon1.text);
      } catch (error) {
        errorMessage = "Distanz muss eine Zahl sein!";
      }
    } else {
      try {
        double.parse(_fieldCon2.text);
      } catch (error) {
        errorMessage = "Gewicht muss eine Zahl sein!";
      }
    }


    if (_description.text == "") {
      errorMessage = "Beschreibung darf nicht leer sein!";
    }

    if (_position != null) {
      positionString = _position.toString();
    }

    if (errorMessage == "") {
      switch (_activityChoice) {
        case 1:
          {
            await activities.add({
              'userId': _userId,
              'dateTime': DateTime.now(),
              'type': Type.Driving.toString(),
              'distance': double.parse(_fieldCon1.text),
              'food': 'Food.Fleisch',
              'amount': 0.0,
              'oneWay': false,
              'flightClass': FlightClass.Business.toString(),
              'description': _description.text,
              'position': positionString
            });
          }
          break;
        case 2:
          {
            await activities.add({
              'userId': _userId,
              'dateTime': DateTime.now(),
              'type': Type.Eating.toString(),
              'distance': 0.0,
              'food': 'Food.' + _food.replaceAll('ü', 'ue'),
              'amount': double.parse(_fieldCon2.text),
              'oneWay': false,
              'flightClass': FlightClass.Business.toString(),
              'description': _description.text,
              'position': positionString
            });
          }
          break;
        case 3:
          {
            await activities.add({
              'userId': _userId,
              'dateTime': DateTime.now(),
              'type': Type.Flying.toString(),
              'distance': double.parse(_fieldCon1.text),
              'food': 'Food.Fleisch',
              'amount': 0.0,
              'oneWay': _isChecked,
              'flightClass': 'FlightClass.' + _flightClass,
              'description': _description.text,
              'position': positionString
            });
          }
          break;
      }
      saveUserId();
      _cleanUp();
      setState(() {
        doCreate = !doCreate;
      });
    }
    setState(() {
      doCreate = doCreate;
    });
  }

  void _cleanUp() {
    _fieldCon1.text = "";
    _fieldCon2.text = "";
    _isChecked = false;
  }

  Future saveUserId() async {
    var result = await _getUserId();
    setState(() {
      _userId = result;
    });

    QuerySnapshot ds = await FirebaseFirestore.instance
        .collection('Activities')
        .where('userId', isEqualTo: result)
        .get();

    QuerySnapshot user = await FirebaseFirestore.instance
        .collection('Users')
        .where('userId', isEqualTo: result)
        .get();

    warehouse.clearWarehouse();

    for (int i = 0; i < ds.docs.length; i++) {
      Timestamp ts = ds.docs[i]['dateTime'];
      Activity _activity = Activity(
          ds.docs[i]['userId'],
          ds.docs[i].id,
          ts.toDate(),
          Type.values.firstWhere((e) => e.toString() == ds.docs[i]['type']),
          ds.docs[i]['distance'],
          Food.values.firstWhere((e) => e.toString() == ds.docs[i]['food']),
          ds.docs[i]['amount'],
          ds.docs[i]['oneWay'],
          FlightClass.values
              .firstWhere((e) => e.toString() == ds.docs[i]['flightClass']),
          ds.docs[i]['description']);
      try {
        _activity.fuel = Fuel.values
            .firstWhere((e) => e.toString() == user.docs[0]['fuelType']);
        _activity.consumption = user.docs[0]["fuelConsumption"];
      } catch (error) {
        print(error);
      }

      if (_activity != null) {
        setState(() {
          warehouse.addActivity(_activity);
        });
      }
    }
    setState(() {
      warehouse.sortWarehouse();
    });
  }

  Future<String> _getUserId() async {
    return FirebaseAuth.instance.currentUser.uid;
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    try {
      setState(() {
        _position = position;
      });
    } catch (error) {
      print(error.toString());
    }
    return position;
  }

  Icon _selectCategory(String category) {
    if (category == 'Flug')
      return Icon(
        Icons.airplanemode_active_outlined,
        color: Colors.red,
        size: 50,
      );
    else if (category == 'Autofahrt')
      return Icon(
        Icons.directions_car_outlined,
        color: Colors.blue,
        size: 50,
      );
    else if (category == 'Essen')
      return Icon(
        Icons.fastfood_outlined,
        color: Colors.purple,
        size: 50,
      );
    else
      return Icon(
        Icons.category_outlined,
        color: Colors.black,
        size: 50,
      );
  }
}
