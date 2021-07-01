// @dart=2.9

import 'package:code/profile/Fuel.dart';

enum Type {
  Driving,
  Eating,
  Flying
}

enum FlightClass {
  Economy,
  Business,
  First
}

enum Food {
  Fleisch, // 13.3kg / kg
  Gemuese, // 0.3 / kg
  Fisch, // 0.4 / kg
  Obst, // 0.5 / kg
  Brot // 0.75 / kg
}

class Activity {

  String _userId;
  String _id;
  DateTime _dateTime;
  Type _type;
  double _distance;
  Food _food;
  double _amount;
  bool _oneWay;
  FlightClass _flightClass;
  String _description;

  Fuel _fuel = Fuel.Benzin;
  double _consumption = 7;

  double co2FactorFlying = 0.380;

  Activity (
      String userId,
      String id,
      DateTime dateTime,
      Type type,
      double distance,
      Food food,
      double amount,
      bool oneWay,
      FlightClass flightClass,
      String description
      ) {
    this._userId = userId;
    this._id = id;
    this._dateTime = dateTime;
    this._type = type;
    this._distance = distance;
    this._food = food;
    this._amount = amount;
    this._oneWay = oneWay;
    this._flightClass = flightClass;
    this._description = description;
  }

  double get output {
    switch (_type) {
      case Type.Driving:
        {
          return getDrivingCo2();
        }
        break;
      case Type.Eating:
        {
          return getEatingCo2();
        }
        break;
      case Type.Flying:
        {
          return getFlyingCo2();
        }
        break;
    }
    return null;
  }

  double getDrivingCo2() {

    switch (_fuel) {
      case Fuel.Benzin:
        {
          // 13.3km / kg
          return _distance * _consumption * 23.8 / 1000;
        }
        break;
      case Fuel.Diesel:
        {
          // 13.3km / kg
          return _distance * _consumption * 26.5 / 1000;
        }
        break;
      case Fuel.Elektro:
        {
          // 13.3km / kg
          return _distance * 0.04;
        }
        break;
      case Fuel.Gas:
        {
          // 13.3km / kg
          return _distance * _consumption * 16.3 / 1000;
        }
        break;
    }

    return null;
  }

  double getEatingCo2() {
    switch (_food) {
      case Food.Fleisch:
        {
          // 13.3km / kg
          return amount * 0.0133;
        }
        break;
      case Food.Fisch:
        {
          // 0.4 / kg
          return amount * 0.0004;
        }
        break;
      case Food.Brot:
        {
          // 0.75 / kg
          return amount * 0.00075;
        }
        break;
      case Food.Gemuese:
        {
          // 0.3 / kg
          return amount * 0.0003;
        }
        break;
      case Food.Obst:
        {
          // 0.5 / kg
          return amount * 0.0005;
        }
        break;
    }

    return null;
  }

  double getFlyingCo2() {
    double co2 = _distance * co2FactorFlying;
    if (!_oneWay) {
      co2 = co2 * 2;
    }
    return co2;
  }


  set fuel(Fuel value) {
    _fuel = value;
  }

  FlightClass get flightClass => _flightClass;

  bool get oneWay => _oneWay;

  double get amount => _amount;

  Food get food => _food;

  double get distance => _distance;

  Type get type => _type;

  DateTime get dateTime => _dateTime;

  String get id => _id;

  String get userId => _userId;

  String get description => _description;

  set consumption(double value) {
    _consumption = value;
  }
}