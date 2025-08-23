// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'protocol.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProtocolAdapter extends TypeAdapter<Protocol> {
  @override
  final int typeId = 0;

  @override
  Protocol read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Protocol(
      id: fields[0] as String?,
      name: fields[1] as String,
      description: fields[2] as String?,
      items: (fields[3] as List).cast<ProtocolItem>(),
      template: fields[4] as String,
      createdAt: fields[5] as DateTime?,
      updatedAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Protocol obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.items)
      ..writeByte(4)
      ..write(obj.template)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProtocolAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProtocolItemAdapter extends TypeAdapter<ProtocolItem> {
  @override
  final int typeId = 1;

  @override
  ProtocolItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProtocolItem(
      id: fields[0] as String,
      title: fields[1] as String,
      instruction: fields[2] as String?,
      responseType: fields[3] as ResponseType,
      options: (fields[4] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProtocolItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.instruction)
      ..writeByte(3)
      ..write(obj.responseType)
      ..writeByte(4)
      ..write(obj.options);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProtocolItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ResponseTypeAdapter extends TypeAdapter<ResponseType> {
  @override
  final int typeId = 7;

  @override
  ResponseType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ResponseType.checklist;
      case 1:
        return ResponseType.scale;
      case 2:
        return ResponseType.text;
      case 3:
        return ResponseType.multipleChoice;
      default:
        return ResponseType.checklist;
    }
  }

  @override
  void write(BinaryWriter writer, ResponseType obj) {
    switch (obj) {
      case ResponseType.checklist:
        writer.writeByte(0);
        break;
      case ResponseType.scale:
        writer.writeByte(1);
        break;
      case ResponseType.text:
        writer.writeByte(2);
        break;
      case ResponseType.multipleChoice:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResponseTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
