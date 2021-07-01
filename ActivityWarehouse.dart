// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code/interfaces/Fuel.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Activity.dart';

class ActivityWarehouse {

  int _ID = 0;

  static final ActivityWarehouse _instance = ActivityWarehouse._internal();
  final Map<int, Activity> warehouse = {};

  factory ActivityWarehouse() => _instance;

  ActivityWarehouse._internal();

  void addActivity(Activity activity){
    warehouse[_ID++] = activity;
  }

  void sortWarehouse() {
    List activities = [];
    warehouse.entries.forEach((e) => activities.add(e.value));
    activities.sort((a, b) =>
      b.dateTime.compareTo(a.dateTime)
    );
    clearWarehouse();
    for (int i = 0; i < activities.length; i++) {
      warehouse[i] = activities[i];
    }
  }

  void clearWarehouse(){
    warehouse.clear();
    _ID = 0;
  }

  T getActivity<T extends Activity>(int id){
    return warehouse[id];
  }

  bool containsActivity(int id){
    return warehouse.containsKey(id);
  }

  T removeActivity<T extends Activity>(String id){
    refresh();
  }

  double get totalOutput{
    double totalOutput = 0.0;

    warehouse.values.forEach((activity) {
      totalOutput += activity.output;
    });

    return totalOutput;
  }

  @override
  String toString() {
    return 'ActivityWarehouse{warehouse: $warehouse}';
  }

  Future refresh() async {
    var result = await _getUserId();

    QuerySnapshot ds = await FirebaseFirestore.instance
        .collection('Activities')
        .where('userId', isEqualTo: result)
        .get();

    clearWarehouse();

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
      if (_activity != null) {
          addActivity(_activity);
      }
    }
    sortWarehouse();
    print('Refreshed!');
    print(warehouse.toString());
  }

  Future<String> _getUserId() async {
    return FirebaseAuth.instance.currentUser.uid;
  }
}