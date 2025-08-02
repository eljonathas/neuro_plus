import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'patient.g.dart';

@HiveType(typeId: 2)
class Guardian extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String phone;

  @HiveField(3)
  final String email;

  @HiveField(4)
  final String relationship;

  @HiveField(5)
  final String address;

  Guardian({
    String? id,
    required this.name,
    required this.phone,
    required this.email,
    required this.relationship,
    required this.address,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'relationship': relationship,
      'address': address,
    };
  }

  factory Guardian.fromJson(Map<String, dynamic> json) {
    return Guardian(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      relationship: json['relationship'],
      address: json['address'],
    );
  }

  Guardian copyWith({
    String? name,
    String? phone,
    String? email,
    String? relationship,
    String? address,
  }) {
    return Guardian(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      relationship: relationship ?? this.relationship,
      address: address ?? this.address,
    );
  }
}

@HiveType(typeId: 3)
class Patient extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final DateTime birthDate;

  @HiveField(3)
  final String gender;

  @HiveField(4)
  final List<Guardian> guardians;

  @HiveField(5)
  final String contactPhone;

  @HiveField(6)
  final String address;

  @HiveField(7)
  final String? contactEmail;

  @HiveField(8)
  final String? referralReason;

  @HiveField(9)
  final String? referredBy;

  @HiveField(10)
  final bool? previouslyEvaluated;

  @HiveField(11)
  final String? previousDiagnosis;

  @HiveField(12)
  final List<String> comorbidities;

  @HiveField(30)
  final String? otherComorbidities;

  @HiveField(13)
  final bool? developmentalDelay;

  @HiveField(14)
  final int? firstWordAge;

  @HiveField(15)
  final String? eyeContact;

  @HiveField(16)
  final bool? repetitiveBehaviors;

  @HiveField(17)
  final String? repetitiveBehaviorsDescription;

  @HiveField(18)
  final bool? routineResistance;

  @HiveField(19)
  final String? socialInteractionWithChildren;

  @HiveField(20)
  final String? sensoryHypersensitivity;

  @HiveField(21)
  final bool? attendsSchool;

  @HiveField(22)
  final String? schoolType;

  @HiveField(23)
  final String? schoolShift;

  @HiveField(24)
  final String? hasMediator;

  @HiveField(25)
  final String? schoolObservations;

  @HiveField(26)
  final String? guardiansObservations;

  @HiveField(27)
  final List<String> screeningsPerformed;

  @HiveField(31)
  final String? otherScreenings;

  @HiveField(28)
  final DateTime createdAt;

  @HiveField(29)
  final DateTime updatedAt;

  Patient({
    String? id,
    required this.fullName,
    required this.birthDate,
    required this.gender,
    required this.guardians,
    required this.contactPhone,
    required this.address,
    this.contactEmail,
    this.referralReason,
    this.referredBy,
    this.previouslyEvaluated,
    this.previousDiagnosis,
    this.comorbidities = const [],
    this.otherComorbidities,
    this.developmentalDelay,
    this.firstWordAge,
    this.eyeContact,
    this.repetitiveBehaviors,
    this.repetitiveBehaviorsDescription,
    this.routineResistance,
    this.socialInteractionWithChildren,
    this.sensoryHypersensitivity,
    this.attendsSchool,
    this.schoolType,
    this.schoolShift,
    this.hasMediator,
    this.schoolObservations,
    this.guardiansObservations,
    this.screeningsPerformed = const [],
    this.otherScreenings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Calcula a idade em anos
  int get age {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  // Calcula a idade em meses
  int get ageInMonths {
    final now = DateTime.now();
    int months = (now.year - birthDate.year) * 12;
    months += now.month - birthDate.month;
    if (now.day < birthDate.day) {
      months--;
    }
    return months;
  }

  Patient copyWith({
    String? fullName,
    DateTime? birthDate,
    String? gender,
    List<Guardian>? guardians,
    String? contactPhone,
    String? address,
    String? contactEmail,
    String? referralReason,
    String? referredBy,
    bool? previouslyEvaluated,
    String? previousDiagnosis,
    List<String>? comorbidities,
    String? otherComorbidities,
    bool? developmentalDelay,
    int? firstWordAge,
    String? eyeContact,
    bool? repetitiveBehaviors,
    String? repetitiveBehaviorsDescription,
    bool? routineResistance,
    String? socialInteractionWithChildren,
    String? sensoryHypersensitivity,
    bool? attendsSchool,
    String? schoolType,
    String? schoolShift,
    String? hasMediator,
    String? schoolObservations,
    String? guardiansObservations,
    List<String>? screeningsPerformed,
    String? otherScreenings,
  }) {
    return Patient(
      id: id,
      fullName: fullName ?? this.fullName,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      guardians: guardians ?? this.guardians,
      contactPhone: contactPhone ?? this.contactPhone,
      address: address ?? this.address,
      contactEmail: contactEmail ?? this.contactEmail,
      referralReason: referralReason ?? this.referralReason,
      referredBy: referredBy ?? this.referredBy,
      previouslyEvaluated: previouslyEvaluated ?? this.previouslyEvaluated,
      previousDiagnosis: previousDiagnosis ?? this.previousDiagnosis,
      comorbidities: comorbidities ?? this.comorbidities,
      otherComorbidities: otherComorbidities ?? this.otherComorbidities,
      developmentalDelay: developmentalDelay ?? this.developmentalDelay,
      firstWordAge: firstWordAge ?? this.firstWordAge,
      eyeContact: eyeContact ?? this.eyeContact,
      repetitiveBehaviors: repetitiveBehaviors ?? this.repetitiveBehaviors,
      repetitiveBehaviorsDescription:
          repetitiveBehaviorsDescription ?? this.repetitiveBehaviorsDescription,
      routineResistance: routineResistance ?? this.routineResistance,
      socialInteractionWithChildren:
          socialInteractionWithChildren ?? this.socialInteractionWithChildren,
      sensoryHypersensitivity:
          sensoryHypersensitivity ?? this.sensoryHypersensitivity,
      attendsSchool: attendsSchool ?? this.attendsSchool,
      schoolType: schoolType ?? this.schoolType,
      schoolShift: schoolShift ?? this.schoolShift,
      hasMediator: hasMediator ?? this.hasMediator,
      schoolObservations: schoolObservations ?? this.schoolObservations,
      guardiansObservations:
          guardiansObservations ?? this.guardiansObservations,
      screeningsPerformed: screeningsPerformed ?? this.screeningsPerformed,
      otherScreenings: otherScreenings ?? this.otherScreenings,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'birthDate': birthDate.toIso8601String(),
      'gender': gender,
      'guardians': guardians.map((g) => g.toJson()).toList(),
      'contactPhone': contactPhone,
      'address': address,
      'contactEmail': contactEmail,
      'referralReason': referralReason,
      'referredBy': referredBy,
      'previouslyEvaluated': previouslyEvaluated,
      'previousDiagnosis': previousDiagnosis,
      'comorbidities': comorbidities,
      'otherComorbidities': otherComorbidities,
      'developmentalDelay': developmentalDelay,
      'firstWordAge': firstWordAge,
      'eyeContact': eyeContact,
      'repetitiveBehaviors': repetitiveBehaviors,
      'repetitiveBehaviorsDescription': repetitiveBehaviorsDescription,
      'routineResistance': routineResistance,
      'socialInteractionWithChildren': socialInteractionWithChildren,
      'sensoryHypersensitivity': sensoryHypersensitivity,
      'attendsSchool': attendsSchool,
      'schoolType': schoolType,
      'schoolShift': schoolShift,
      'hasMediator': hasMediator,
      'schoolObservations': schoolObservations,
      'guardiansObservations': guardiansObservations,
      'screeningsPerformed': screeningsPerformed,
      'otherScreenings': otherScreenings,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      fullName: json['fullName'],
      birthDate: DateTime.parse(json['birthDate']),
      gender: json['gender'],
      guardians:
          (json['guardians'] as List<dynamic>?)
              ?.map((g) => Guardian.fromJson(g as Map<String, dynamic>))
              .toList() ??
          [],
      contactPhone: json['contactPhone'],
      address: json['address'],
      contactEmail: json['contactEmail'],
      referralReason: json['referralReason'],
      referredBy: json['referredBy'],
      previouslyEvaluated: json['previouslyEvaluated'],
      previousDiagnosis: json['previousDiagnosis'],
      comorbidities: List<String>.from(json['comorbidities'] ?? []),
      otherComorbidities: json['otherComorbidities'],
      developmentalDelay: json['developmentalDelay'],
      firstWordAge: json['firstWordAge'],
      eyeContact: json['eyeContact'],
      repetitiveBehaviors: json['repetitiveBehaviors'],
      repetitiveBehaviorsDescription: json['repetitiveBehaviorsDescription'],
      routineResistance: json['routineResistance'],
      socialInteractionWithChildren: json['socialInteractionWithChildren'],
      sensoryHypersensitivity: json['sensoryHypersensitivity'],
      attendsSchool: json['attendsSchool'],
      schoolType: json['schoolType'],
      schoolShift: json['schoolShift'],
      hasMediator: json['hasMediator'],
      schoolObservations: json['schoolObservations'],
      guardiansObservations: json['guardiansObservations'],
      screeningsPerformed: List<String>.from(json['screeningsPerformed'] ?? []),
      otherScreenings: json['otherScreenings'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

// Enums para as opções do formulário
class PatientEnums {
  static const List<String> genderOptions = ['Masculino', 'Feminino', 'Outro'];

  static const List<String> comorbiditiesOptions = [
    'TDAH',
    'Ansiedade',
    'Epilepsia',
    'Nenhuma',
    'Outros',
  ];

  static const List<String> eyeContactOptions = ['Sim', 'Não', 'Parcial'];

  static const List<String> socialInteractionOptions = [
    'Sim',
    'Não',
    'Parcial',
  ];

  static const List<String> sensoryHypersensitivityOptions = [
    'Sim',
    'Não',
    'Não observado',
  ];

  static const List<String> schoolTypeOptions = [
    'Regular',
    'Especial',
    'Outra',
  ];

  static const List<String> schoolShiftOptions = ['Manhã', 'Tarde', 'Integral'];

  static const List<String> mediatorOptions = ['Sim', 'Não', 'Não informado'];

  static const List<String> screeningsOptions = [
    'M-CHAT',
    'CARS',
    'ADOS',
    'Nenhuma',
    'Outros',
  ];
}
