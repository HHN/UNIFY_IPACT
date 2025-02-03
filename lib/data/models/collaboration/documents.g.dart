// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documents.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DocumentsAdapter extends TypeAdapter<Documents> {
  @override
  final int typeId = 2;

  @override
  Documents read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Documents(
      collaborationId: fields[0] as String?,
      documentName: fields[1] as String?,
      documentShareStatus: fields[2] as bool?,
      filePath: fields[3] as String?,
      fileId: fields[4] as String?,
      fileOriginalName: fields[5] as String?,
      generateKeyFileForSymmetricCryptography: fields[6] as String?,
      symmetricEncryptFile: fields[7] as String?,
      asymmetricEncryptFile: fields[8] as String?,
      asymmetricDecryptFile: fields[9] as String?,
      symmetricDecryptFile: fields[10] as String?,
      originalFileHash: fields[11] as String?,
      symmetricEncryptFileHash: fields[12] as String?,
      ownDocument: fields[13] as bool?,
      originalFileHashTransactionId: fields[14] as String?,
      symmetricEncryptFileHashTransactionId: fields[15] as String?,
      symmetricDecryptFileHash: fields[16] as String?,
      asymmetricDecryptFileHash: fields[17] as String?,
      symmetricDecryptFileHashTransactionId: fields[18] as String?,
      asymmetricDecryptFileHashTransactionId: fields[19] as String?,
      isCryptographicKeyShared: fields[20] as bool?,
      cryptographicKeyTransactionId: fields[21] as String?,
      isFileEncrypted: fields[22] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Documents obj) {
    writer
      ..writeByte(23)
      ..writeByte(0)
      ..write(obj.collaborationId)
      ..writeByte(1)
      ..write(obj.documentName)
      ..writeByte(2)
      ..write(obj.documentShareStatus)
      ..writeByte(3)
      ..write(obj.filePath)
      ..writeByte(4)
      ..write(obj.fileId)
      ..writeByte(5)
      ..write(obj.fileOriginalName)
      ..writeByte(6)
      ..write(obj.generateKeyFileForSymmetricCryptography)
      ..writeByte(7)
      ..write(obj.symmetricEncryptFile)
      ..writeByte(8)
      ..write(obj.asymmetricEncryptFile)
      ..writeByte(9)
      ..write(obj.asymmetricDecryptFile)
      ..writeByte(10)
      ..write(obj.symmetricDecryptFile)
      ..writeByte(11)
      ..write(obj.originalFileHash)
      ..writeByte(12)
      ..write(obj.symmetricEncryptFileHash)
      ..writeByte(13)
      ..write(obj.ownDocument)
      ..writeByte(14)
      ..write(obj.originalFileHashTransactionId)
      ..writeByte(15)
      ..write(obj.symmetricEncryptFileHashTransactionId)
      ..writeByte(16)
      ..write(obj.symmetricDecryptFileHash)
      ..writeByte(17)
      ..write(obj.asymmetricDecryptFileHash)
      ..writeByte(18)
      ..write(obj.symmetricDecryptFileHashTransactionId)
      ..writeByte(19)
      ..write(obj.asymmetricDecryptFileHashTransactionId)
      ..writeByte(20)
      ..write(obj.isCryptographicKeyShared)
      ..writeByte(21)
      ..write(obj.cryptographicKeyTransactionId)
      ..writeByte(22)
      ..write(obj.isFileEncrypted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
