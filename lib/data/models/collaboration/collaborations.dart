import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'collaborations.g.dart';

@HiveType(typeId: 1)
class Collaborations extends HiveObject {
  @HiveField(0)
  final String collaborationId;
  @HiveField(1)
  final String collaborationName;
  @HiveField(2, defaultValue: false)
  final bool collaborationAccepted;
  @HiveField(3)
  final bool collaborationSent;
  @HiveField(4)
  final String transactionId;
  @HiveField(5)
  final String senderIOTAAddress;
  @HiveField(6)
  final String senderPublicKey;
  @HiveField(7)
  final String receiverIOTAAddress;
  @HiveField(8)
  final String receiverPublicKey;

  Collaborations({required this.collaborationId,
    required this.collaborationName,
    required this.collaborationAccepted,
    required this.collaborationSent,
    required this.transactionId,
    required this.senderIOTAAddress,
    required this.senderPublicKey,
    required this.receiverIOTAAddress,
    required this.receiverPublicKey,
  });
}
