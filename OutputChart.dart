// @dart=2.9
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'PieChartElement.dart';

class OutputChart extends StatelessWidget {
  final bool animate;
  final double output;
  final double outputSize;
  final List<PieChartElement> data;

  OutputChart(this.data, this.output, this.outputSize, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
          child: Stack(
        children: <Widget>[
          charts.PieChart(_calcActivities(data),
              animate: animate,
              defaultRenderer: new charts.ArcRendererConfig(
                  arcWidth: 45,
                  arcRendererDecorators: [new charts.ArcLabelDecorator()])),
          Center(
            child: Text(
              output.toStringAsFixed(2) + " kg",
              style: TextStyle(
                  fontSize: 30,
                  color: Color.fromRGBO(66, 120, 151, 1.0),
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      )),
    );
  }

  static List<charts.Series<PieChartElement, String>> _calcActivities(
      List<PieChartElement> data) {
    return [
      new charts.Series<PieChartElement, String>(
        id: 'Segments',
        domainFn: (PieChartElement pElem, _) => pElem.category,
        measureFn: (PieChartElement pElem, _) => pElem.totalOutput,
        colorFn: (PieChartElement pElem, _) => pElem.color,
        data: data,
      )
    ];
  }
}
