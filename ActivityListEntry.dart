// @dart=2.9

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Activity.dart';

class ActivityListEntry extends StatelessWidget{

  Activity activity;

  ActivityListEntry(this.activity);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: _getIcon(activity),
              title: Text(
                  activity.description
              ),
              subtitle: Text(
                DateFormat('dd.MM.yy h:m').format(activity.dateTime),
                textAlign: TextAlign.left,
              ),
              trailing: Text(_getAmount(activity) + " ~ " + activity.output.toStringAsFixed(2) + " kg"),
            ),
          ],
        ),
      ),
    );
  }

  String _getAmount (Activity activity) {
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

  String _getCategory(Activity activity){

    if (activity.toString().contains("DrivingActivity")){
      return "Auto";
    }
    if (activity.toString().contains("EatingActivity")){
      return "Essen";
    }
    if (activity.toString().contains("FlyingActivity")){
      return "Fliegen";
    }
  }

  Icon _getIcon(Activity activity){

    if (activity.type == Type.Driving){
      return Icon(
          Icons.directions_car,
        color: Colors.blue,
      );
    }
    if (activity.type == Type.Eating){
      return Icon(
        Icons.fastfood,
        color: Colors.purple,
      );
    }
    if (activity.type == Type.Flying){
      return Icon(
        Icons.airplanemode_active,
        color: Colors.red,
      );
    }

  }

}