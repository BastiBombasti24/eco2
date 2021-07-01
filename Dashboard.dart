// @dart=2.9
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code/Activity/Activity.dart';
import 'package:code/Activity/ActivityWarehouse.dart';
import 'package:code/profile/Fuel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CategoryListEntry.dart';
import 'OutputChart.dart';
import 'PieChartElement.dart';

class Dashboard extends StatefulWidget {
  @override
  _Dashboard createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
  bool isBigChart = false;

  String _userId;

  ActivityWarehouse warehouse = ActivityWarehouse();
  List<PieChartElement> data = [];
  double output = 0.0;
  bool list = false;

  @override
  void initState() {
    saveUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);

    data = warehouseToData();

    return Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),

            /// Chart-Container
            Container(
              child: (output > 0
                  ? OutputChart(
                      data,
                      output,
                      30,
                    )
                  : Center(
                      child: Text(
                        'Keine Aktivitäten erkannt! \nGehe zu "Erfassen" um deine \nerste Aktivität anzulegen',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          color: Color.fromRGBO(66, 120, 151, 1.0),
                        ),
                      )
                    )),
              padding: EdgeInsets.only(top: 45, left: 10, right: 10),
              height: queryData.size.height * 0.4,
            ),

              SizedBox(
                height: 30,
              ),

            /// Container for the List
            Container(
              child: Center(
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, i) {
                        return CategoryListEntry(
                            data[i].category, data[i].color, data[i].totalOutput);
                      })),
              height: queryData.size.height * 0.4,
              alignment: Alignment.bottomCenter,
            ),
        ],
    ));
  }

  warehouseToData() {
    output = 0;

    final PieChartElement _flying = new PieChartElement(
        "Fliegen", 0.0, charts.MaterialPalette.red.shadeDefault);
    final PieChartElement _driving = new PieChartElement(
        "Auto", 0.0, charts.MaterialPalette.blue.shadeDefault);
    final PieChartElement _eating = new PieChartElement(
        "Essen", 0.0, charts.MaterialPalette.purple.shadeDefault);

    List<PieChartElement> _warehouseData = [_flying, _driving, _eating];

    warehouse.warehouse.values.forEach((activity) {
      if (activity.type == Type.Flying) {
        _flying.totalOutput += activity.output;
      } else if (activity.type == Type.Driving) {
        _driving.totalOutput += activity.output;
      } else if (activity.type == Type.Eating) {
        _eating.totalOutput += activity.output;
      }

      output += activity.output;
    });

    return _warehouseData;
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
          FlightClass.values.firstWhere((e) => e.toString() == ds.docs[i]['flightClass']),
          ds.docs[i]['description']
      );

      try {
        _activity.fuel = Fuel.values.firstWhere((e) => e.toString() == user.docs[0]['fuelType']);
        _activity.consumption = user.docs[0]["fuelConsumption"];
      } catch (error){
        print(error);
      }

      if (_activity != null) {
        setState(() {
          warehouse.addActivity(_activity);
        });
      }
    }
  }

  Future<String> _getUserId() async {
    return FirebaseAuth.instance.currentUser.uid;
  }
}
