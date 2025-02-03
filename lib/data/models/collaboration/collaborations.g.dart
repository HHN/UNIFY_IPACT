// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collaborations.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CollaborationsAdapter extends TypeAdapter<Collaborations> {
  @override
  final int typeId = 1;

  @override
  Collaborations read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Collaborations(
      collaborationId: fields[0] as String,
      collaborationName: fields[1] as String,
      collaborationAccepted: fields[2] == null ? false : fields[2] as bool,
      collaborationSent: fields[3] as bool,
      transactionId: fields[4] as String,
      senderIOTAAddress: fields[5] as String,
      senderPublicKey: fields[6] as String,
      receiverIOTAAddress: fields[7] as String,
      receiverPublicKey: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Collaborations obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.collaborationId)
      ..writeByte(1)
      ..write(obj.collaborationName)
      ..writeByte(2)
      ..write(obj.collaborationAccepted)
      ..writeByte(3)
      ..write(obj.collaborationSent)
      ..writeByte(4)
      ..write(obj.transactionId)
      ..writeByte(5)
      ..write(obj.senderIOTAAddress)
      ..writeByte(6)
      ..write(obj.senderPublicKey)
      ..writeByte(7)
      ..write(obj.receiverIOTAAddress)
      ..writeByte(8)
      ..write(obj.receiverPublicKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CollaborationsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
