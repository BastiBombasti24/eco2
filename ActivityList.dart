// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Activity.dart';
import 'ActivityWarehouse.dart';

class ActivityList extends StatefulWidget {
  @override
  _ActivityList createState() => _ActivityList();
}

class _ActivityList extends State<ActivityList> {
  ActivityWarehouse warehouse = ActivityWarehouse();
  Activity activity;

  @override
  Widget build(BuildContext context) {
    if (warehouse.warehouse.length <= 0)
    return Container(
        child: Center(
          child: Text(
            'Keine Aktivitäten erkannt! \nDrücke auf "+" um deine \nerste Aktivität anzulegen',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              color: Color.fromRGBO(66, 120, 151, 1.0),
            ),
          )
      ),
      padding: EdgeInsets.only(top: 45, left: 10, right: 10),
    );
    return Container(
        child: Center(
            // Demo ListView
            child: ListView.builder(
                itemCount: warehouse.warehouse.length,
                itemBuilder: (context, i) {
                  activity = warehouse.getActivity(i);
                  return Center(
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Dismissible(
                            // Each Dismissible must contain a Key. Keys allow Flutter to
                            // uniquely identify widgets.
                            key: UniqueKey(),
                            // Provide a function that tells the app
                            // what to do after an item has been swiped away.
                            onDismissed: (direction) async{
                              // Remove the item from the data source.
                              await _removeActivity(warehouse.warehouse[i].id);
                            },
                            child: ListTile(
                              leading: _getIcon(activity),
                              title: Text(activity.description),
                              subtitle: Text(
                                DateFormat('dd.MM.yy h:m')
                                    .format(activity.dateTime),
                                textAlign: TextAlign.left,
                              ),
                              trailing: Text(_getAmount(activity) +
                                  " ~ " +
                                  activity.output.toStringAsFixed(2) +
                                  " kg"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                })));
  }

  String _getAmount(Activity activity) {
    if(activity == null){
      return null;
    }

    switch (activity.type) {
      case Type.Driving:
        return activity.distance.toString() + "km";
        break;
      case Type.Eating:
        return activity.amount.toString() + "g";
        break;
      case Type.Flying:
        return activity.distance.toString() + "km";
        break;
    }
  }

  String _getCategory(Activity activity) {
    if(activity == null){
      return null;
    }

    if (activity.toString().contains("DrivingActivity")) {
      return "Auto";
    }
    if (activity.toString().contains("EatingActivity")) {
      return "Essen";
    }
    if (activity.toString().contains("FlyingActivity")) {
      return "Fliegen";
    }
  }

  Icon _getIcon(Activity activity) {
    if(activity == null){
      return null;
    }

    if (activity.type == Type.Driving) {
      return Icon(
        Icons.directions_car,
        color: Colors.blue,
      );
    }
    if (activity.type == Type.Eating) {
      return Icon(
        Icons.fastfood,
        color: Colors.purple,
      );
    }
    if (activity.type == Type.Flying) {
      return Icon(
        Icons.airplanemode_active,
        color: Colors.red,
      );
    }
  }

  Future<void> _removeActivity(String id) async {
    await FirebaseFirestore.instance
        .collection('Activities')
        .doc(id)
        .delete()
        .then((value) async {
        await warehouse.refresh();
    });
    print(warehouse.toString());
  }
}
