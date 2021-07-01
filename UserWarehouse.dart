import 'package:code/interfaces/User.dart';

abstract class UserWarehouse<T extends User>{

  void addUser(int ID, T user);
  T getUser(int ID);
  bool containsUser(int ID);
  T removeUser(int ID);

}