import 'package:hive/hive.dart';
import 'package:neuro_plus/common/services/hive_service.dart';
import 'package:neuro_plus/models/patient.dart';

class PatientsService {
  static bool initialized = false;
  static const String _boxName = 'patients';

  static Future<void> init() async {
    if (initialized) return;

    await HiveService.init();

    Hive.registerAdapter(GuardianAdapter());
    Hive.registerAdapter(PatientAdapter());

    if (Hive.isBoxOpen(_boxName)) {
      await Hive.box(_boxName).close();
    }

    await Hive.openBox<Patient>(_boxName);

    initialized = true;
  }

  static Future<void> close() async {
    await Hive.close();
    initialized = false;
  }

  static List<Patient> getAllPatients() {
    final box = Hive.box<Patient>(_boxName);
    return box.values.toList()
      ..sort((a, b) => a.fullName.compareTo(b.fullName));
  }

  static Patient? getPatientById(String id) {
    final box = Hive.box<Patient>(_boxName);
    return box.get(id);
  }

  static Future<void> addPatient(Patient patient) async {
    final box = Hive.box<Patient>(_boxName);
    await box.put(patient.id, patient);
  }

  static Future<void> updatePatient(Patient patient) async {
    final box = Hive.box<Patient>(_boxName);
    await box.put(patient.id, patient);
  }

  static Future<void> deletePatient(String id) async {
    final box = Hive.box<Patient>(_boxName);
    await box.delete(id);
  }

  static List<Patient> searchPatients(String query) {
    if (query.isEmpty) return getAllPatients();

    final patients = getAllPatients();
    final lowerQuery = query.toLowerCase();

    return patients.where((patient) {
      final guardiansNames = patient.guardians
          .map((guardian) => guardian.name.toLowerCase())
          .join(' ');

      return patient.fullName.toLowerCase().contains(lowerQuery) ||
          guardiansNames.contains(lowerQuery) ||
          patient.contactPhone.contains(query);
    }).toList();
  }

  static List<Patient> getPatientsByAge(int minAge, int maxAge) {
    final patients = getAllPatients();
    return patients.where((patient) {
      final age = patient.age;
      return age >= minAge && age <= maxAge;
    }).toList();
  }

  static List<Patient> getPatientsByGender(String gender) {
    final patients = getAllPatients();
    return patients.where((patient) => patient.gender == gender).toList();
  }
}
