// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class CategoryListEntry extends StatelessWidget{

  final String category;
  final charts.Color color;
  final double total;

  const CategoryListEntry(this.category, this.color, this.total);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: _getIcon(category),
              title: Text(category),
              trailing: Text(total.toStringAsFixed(2) + " kg"),
            ),
          ],
        ),
      ),
    );
  }

  Icon _getIcon(String category){

    if (category == "Auto"){
      return Icon(
        Icons.directions_car,
        color: Colors.blue,
      );
    }
    if (category == "Essen"){
      return Icon(
        Icons.fastfood,
        color: Colors.purple,
      );
    }
    if (category == "Fliegen"){
      return Icon(
        Icons.airplanemode_active,
        color: Colors.red,
      );
    }

  }
}