// @dart=2.9
import 'package:code/Activity/Activity.dart';
import 'package:code/interfaces/Fuel.dart';
import 'package:code/interfaces/Mailadress.dart';

abstract class User {
  int _ID;
  Mailadress _mailadress;
  String _password;
  String _name;
  Map<int, double> _monthlyEmmission;
  double _fuelConsumption;
  Fuel _fuel;

  double calcMonthlyEmission<T extends Activity>(Map<int, T> activities);

  ///GETTER
  Fuel get fuel => _fuel;

  double get fuelConsumption => _fuelConsumption;

  Map<int, double> get monthlyEmmission => _monthlyEmmission;

  String get name => _name;

  String get password => _password;

  Mailadress get mailadress => _mailadress;

  int get ID => _ID;

  ///SETTER
  set fuel(Fuel value) {
    _fuel = value;
  }

  set fuelConsumption(double value) {
    _fuelConsumption = value;
  }

  set monthlyEmmission(Map<int, double> value) {
    _monthlyEmmission = value;
  }

  set name(String value) {
    _name = value;
  }

  set password(String value) {
    _password = value;
  }

  set mailadress(Mailadress value) {
    _mailadress = value;
  }
}
