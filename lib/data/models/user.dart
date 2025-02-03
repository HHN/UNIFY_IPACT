import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  // @HiveField(0, defaultValue: 0)
  // final int? userId;
  @HiveField(0)
  final String userName;
  @HiveField(1)
  final String userPin;
  @HiveField(2)
  final String userPublicAddress;
  @HiveField(3)
  final String userPublicKey;

  User(
      {required this.userName,
      required this.userPin,
      required this.userPublicAddress,
      required this.userPublicKey});
}
