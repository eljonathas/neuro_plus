// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GuardianAdapter extends TypeAdapter<Guardian> {
  @override
  final int typeId = 2;

  @override
  Guardian read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Guardian(
      id: fields[0] as String?,
      name: fields[1] as String,
      phone: fields[2] as String,
      email: fields[3] as String,
      relationship: fields[4] as String,
      address: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Guardian obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.relationship)
      ..writeByte(5)
      ..write(obj.address);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GuardianAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PatientAdapter extends TypeAdapter<Patient> {
  @override
  final int typeId = 3;

  @override
  Patient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Patient(
      id: fields[0] as String?,
      fullName: fields[1] as String,
      birthDate: fields[2] as DateTime,
      gender: fields[3] as String,
      guardians: (fields[4] as List).cast<Guardian>(),
      contactPhone: fields[5] as String,
      address: fields[6] as String,
      contactEmail: fields[7] as String?,
      referralReason: fields[8] as String?,
      referredBy: fields[9] as String?,
      previouslyEvaluated: fields[10] as bool?,
      previousDiagnosis: fields[11] as String?,
      cidCode: fields[32] as String?,
      comorbidities: (fields[12] as List).cast<String>(),
      otherComorbidities: fields[30] as String?,
      developmentalDelay: fields[13] as bool?,
      firstWordAge: fields[14] as int?,
      eyeContact: fields[15] as String?,
      repetitiveBehaviors: fields[16] as bool?,
      repetitiveBehaviorsDescription: fields[17] as String?,
      routineResistance: fields[18] as bool?,
      socialInteractionWithChildren: fields[19] as String?,
      sensoryHypersensitivity: fields[20] as String?,
      attendsSchool: fields[21] as bool?,
      schoolType: fields[22] as String?,
      schoolShift: fields[23] as String?,
      hasMediator: fields[24] as String?,
      schoolObservations: fields[25] as String?,
      guardiansObservations: fields[26] as String?,
      screeningsPerformed: (fields[27] as List).cast<String>(),
      otherScreenings: fields[31] as String?,
      createdAt: fields[28] as DateTime?,
      updatedAt: fields[29] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Patient obj) {
    writer
      ..writeByte(33)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.birthDate)
      ..writeByte(3)
      ..write(obj.gender)
      ..writeByte(4)
      ..write(obj.guardians)
      ..writeByte(5)
      ..write(obj.contactPhone)
      ..writeByte(6)
      ..write(obj.address)
      ..writeByte(7)
      ..write(obj.contactEmail)
      ..writeByte(8)
      ..write(obj.referralReason)
      ..writeByte(9)
      ..write(obj.referredBy)
      ..writeByte(10)
      ..write(obj.previouslyEvaluated)
      ..writeByte(11)
      ..write(obj.previousDiagnosis)
      ..writeByte(32)
      ..write(obj.cidCode)
      ..writeByte(12)
      ..write(obj.comorbidities)
      ..writeByte(30)
      ..write(obj.otherComorbidities)
      ..writeByte(13)
      ..write(obj.developmentalDelay)
      ..writeByte(14)
      ..write(obj.firstWordAge)
      ..writeByte(15)
      ..write(obj.eyeContact)
      ..writeByte(16)
      ..write(obj.repetitiveBehaviors)
      ..writeByte(17)
      ..write(obj.repetitiveBehaviorsDescription)
      ..writeByte(18)
      ..write(obj.routineResistance)
      ..writeByte(19)
      ..write(obj.socialInteractionWithChildren)
      ..writeByte(20)
      ..write(obj.sensoryHypersensitivity)
      ..writeByte(21)
      ..write(obj.attendsSchool)
      ..writeByte(22)
      ..write(obj.schoolType)
      ..writeByte(23)
      ..write(obj.schoolShift)
      ..writeByte(24)
      ..write(obj.hasMediator)
      ..writeByte(25)
      ..write(obj.schoolObservations)
      ..writeByte(26)
      ..write(obj.guardiansObservations)
      ..writeByte(27)
      ..write(obj.screeningsPerformed)
      ..writeByte(31)
      ..write(obj.otherScreenings)
      ..writeByte(28)
      ..write(obj.createdAt)
      ..writeByte(29)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
