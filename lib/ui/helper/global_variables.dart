import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:unify_secret/data/models/user.dart';

class GlobalVariables {
  static bool gIsDarkMode = false;
  static BuildContext? currentContext;
  static String? globalCurrentUser;
  // static Box userBox = Hive.box<UsersCollection>('users');
  // static Box userBox = Hive.box<UsersCollection>('users');
}
