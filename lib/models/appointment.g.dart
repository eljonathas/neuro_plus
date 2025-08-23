// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppointmentAdapter extends TypeAdapter<Appointment> {
  @override
  final int typeId = 4;

  @override
  Appointment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Appointment(
      id: fields[0] as String?,
      patientId: fields[1] as String,
      patientName: fields[2] as String,
      date: fields[3] as DateTime,
      time: fields[4] as String,
      protocolIds: (fields[5] as List?)?.cast<String>(),
      protocolNames: (fields[6] as List?)?.cast<String>(),
      status: fields[7] as AppointmentStatus,
      type: fields[8] as AppointmentType,
      notes: fields[9] as String?,
      protocolResponses: (fields[10] as Map?)?.map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as Map).cast<String, dynamic>())),
      createdAt: fields[11] as DateTime?,
      updatedAt: fields[12] as DateTime?,
      duration: fields[13] as int,
      location: fields[14] as String?,
      soapSubjective: fields[15] as String?,
      soapObjective: fields[16] as String?,
      soapAssessment: fields[17] as String?,
      soapPlan: fields[18] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Appointment obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.patientId)
      ..writeByte(2)
      ..write(obj.patientName)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.time)
      ..writeByte(5)
      ..write(obj.protocolIds)
      ..writeByte(6)
      ..write(obj.protocolNames)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.type)
      ..writeByte(9)
      ..write(obj.notes)
      ..writeByte(10)
      ..write(obj.protocolResponses)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt)
      ..writeByte(13)
      ..write(obj.duration)
      ..writeByte(14)
      ..write(obj.location)
      ..writeByte(15)
      ..write(obj.soapSubjective)
      ..writeByte(16)
      ..write(obj.soapObjective)
      ..writeByte(17)
      ..write(obj.soapAssessment)
      ..writeByte(18)
      ..write(obj.soapPlan);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppointmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppointmentStatusAdapter extends TypeAdapter<AppointmentStatus> {
  @override
  final int typeId = 5;

  @override
  AppointmentStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppointmentStatus.scheduled;
      case 1:
        return AppointmentStatus.inProgress;
      case 2:
        return AppointmentStatus.completed;
      case 3:
        return AppointmentStatus.cancelled;
      case 4:
        return AppointmentStatus.noShow;
      default:
        return AppointmentStatus.scheduled;
    }
  }

  @override
  void write(BinaryWriter writer, AppointmentStatus obj) {
    switch (obj) {
      case AppointmentStatus.scheduled:
        writer.writeByte(0);
        break;
      case AppointmentStatus.inProgress:
        writer.writeByte(1);
        break;
      case AppointmentStatus.completed:
        writer.writeByte(2);
        break;
      case AppointmentStatus.cancelled:
        writer.writeByte(3);
        break;
      case AppointmentStatus.noShow:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppointmentStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppointmentTypeAdapter extends TypeAdapter<AppointmentType> {
  @override
  final int typeId = 6;

  @override
  AppointmentType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppointmentType.evaluation;
      case 1:
        return AppointmentType.revaluation;
      case 2:
        return AppointmentType.followUp;
      case 3:
        return AppointmentType.consultation;
      default:
        return AppointmentType.evaluation;
    }
  }

  @override
  void write(BinaryWriter writer, AppointmentType obj) {
    switch (obj) {
      case AppointmentType.evaluation:
        writer.writeByte(0);
        break;
      case AppointmentType.revaluation:
        writer.writeByte(1);
        break;
      case AppointmentType.followUp:
        writer.writeByte(2);
        break;
      case AppointmentType.consultation:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppointmentTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
