import 'package:charts_flutter/flutter.dart' as charts;

//PieChartElemt-Datatype for Color settings
class PieChartElement{

  String _category;
  double _totalOutput;
  charts.Color _color;

  PieChartElement(this._category, this._totalOutput, this._color);

  double get totalOutput => _totalOutput;

  set totalOutput(double value) {
    _totalOutput = value;
  }

  charts.Color get color => _color;

  String get category => _category;
}