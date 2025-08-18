import 'package:hive/hive.dart';
import 'package:neuro_plus/common/services/hive_service.dart';
import 'package:neuro_plus/models/appointment.dart';

class AppointmentsService {
  static const String _boxName = 'appointments';
  static Box<Appointment>? _box;

  static Future<void> init() async {
    if (_box == null || !_box!.isOpen) {
      await HiveService.init();
      // Registrar adaptadores se ainda não foram registrados
      if (!Hive.isAdapterRegistered(4)) {
        Hive.registerAdapter(AppointmentAdapter());
      }
      if (!Hive.isAdapterRegistered(5)) {
        Hive.registerAdapter(AppointmentStatusAdapter());
      }
      if (!Hive.isAdapterRegistered(6)) {
        Hive.registerAdapter(AppointmentTypeAdapter());
      }

      _box = await Hive.openBox<Appointment>(_boxName);
    }
  }

  static Future<void> close() async {
    await _box?.close();
    _box = null;
  }

  static Future<String> createAppointment(Appointment appointment) async {
    await init();
    await _box!.put(appointment.id, appointment);
    return appointment.id;
  }

  static Future<void> updateAppointment(Appointment appointment) async {
    final updatedAppointment = appointment.copyWith();
    await _box!.put(appointment.id, updatedAppointment);
  }

  static Future<void> deleteAppointment(String id) async {
    await _box!.delete(id);
  }

  static Appointment? getAppointment(String id) {
    if (_box == null || !_box!.isOpen) return null;
    return _box!.get(id);
  }

  static List<Appointment> getAllAppointments() {
    if (_box == null || !_box!.isOpen) return [];
    return _box!.values.toList()..sort((a, b) {
      final dateComparison = a.date.compareTo(b.date);
      if (dateComparison != 0) return dateComparison;
      return a.time.compareTo(b.time);
    });
  }

  static List<Appointment> getAppointmentsByPatient(String patientId) {
    if (_box == null || !_box!.isOpen) return [];
    return _box!.values
        .where((appointment) => appointment.patientId == patientId)
        .toList()
      ..sort((a, b) {
        final dateComparison = a.date.compareTo(b.date);
        if (dateComparison != 0) return dateComparison;
        return a.time.compareTo(b.time);
      });
  }

  static List<Appointment> getAppointmentsByDate(DateTime date) {
    if (_box == null || !_box!.isOpen) return [];
    return _box!.values
        .where(
          (appointment) =>
              appointment.date.year == date.year &&
              appointment.date.month == date.month &&
              appointment.date.day == date.day,
        )
        .toList()
      ..sort((a, b) => a.time.compareTo(b.time));
  }

  static List<Appointment> getAppointmentsByDateRange(
    DateTime start,
    DateTime end,
  ) {
    if (_box == null || !_box!.isOpen) return [];
    return _box!.values
        .where(
          (appointment) =>
              appointment.date.isAfter(
                start.subtract(const Duration(days: 1)),
              ) &&
              appointment.date.isBefore(end.add(const Duration(days: 1))),
        )
        .toList()
      ..sort((a, b) {
        final dateComparison = a.date.compareTo(b.date);
        if (dateComparison != 0) return dateComparison;
        return a.time.compareTo(b.time);
      });
  }

  static List<Appointment> getAppointmentsByStatus(AppointmentStatus status) {
    if (_box == null || !_box!.isOpen) return [];
    return _box!.values
        .where((appointment) => appointment.status == status)
        .toList()
      ..sort((a, b) {
        final dateComparison = a.date.compareTo(b.date);
        if (dateComparison != 0) return dateComparison;
        return a.time.compareTo(b.time);
      });
  }

  static List<Appointment> searchAppointments(String query) {
    if (_box == null || !_box!.isOpen) return [];
    if (query.isEmpty) return getAllAppointments();

    final lowerQuery = query.toLowerCase();
    return _box!.values
        .where(
          (appointment) =>
              appointment.patientName.toLowerCase().contains(lowerQuery) ||
              appointment.typeText.toLowerCase().contains(lowerQuery) ||
              appointment.statusText.toLowerCase().contains(lowerQuery) ||
              (appointment.protocolNames?.any(
                    (name) => name.toLowerCase().contains(lowerQuery),
                  ) ??
                  false) ||
              (appointment.notes?.toLowerCase().contains(lowerQuery) ?? false),
        )
        .toList()
      ..sort((a, b) {
        final dateComparison = a.date.compareTo(b.date);
        if (dateComparison != 0) return dateComparison;
        return a.time.compareTo(b.time);
      });
  }

  static Future<void> updateAppointmentStatus(
    String id,
    AppointmentStatus status,
  ) async {
    final appointment = _box!.get(id);
    if (appointment != null) {
      final updatedAppointment = appointment.copyWith(status: status);
      await _box!.put(id, updatedAppointment);
    }
  }

  static Future<void> updateAppointmentProtocolResponses(
    String appointmentId,
    String protocolId,
    Map<String, dynamic> responses,
  ) async {
    final appointment = _box!.get(appointmentId);
    if (appointment != null) {
      final currentResponses = Map<String, Map<String, dynamic>>.from(
        appointment.protocolResponses ?? {},
      );
      currentResponses[protocolId] = responses;

      final updatedAppointment = appointment.copyWith(
        protocolResponses: currentResponses,
      );
      await _box!.put(appointmentId, updatedAppointment);
    }
  }

  // Estatísticas úteis
  static Map<String, int> getAppointmentStats() {
    if (_box == null || !_box!.isOpen) return {};

    final appointments = _box!.values.toList();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return {
      'total': appointments.length,
      'scheduled':
          appointments
              .where((a) => a.status == AppointmentStatus.scheduled)
              .length,
      'completed':
          appointments
              .where((a) => a.status == AppointmentStatus.completed)
              .length,
      'cancelled':
          appointments
              .where((a) => a.status == AppointmentStatus.cancelled)
              .length,
      'today':
          appointments
              .where(
                (a) =>
                    a.date.year == today.year &&
                    a.date.month == today.month &&
                    a.date.day == today.day,
              )
              .length,
      'thisWeek':
          appointments
              .where(
                (a) =>
                    a.date.isAfter(
                      today.subtract(Duration(days: today.weekday - 1)),
                    ) &&
                    a.date.isBefore(
                      today.add(Duration(days: 7 - today.weekday + 1)),
                    ),
              )
              .length,
    };
  }

  // Verificar conflitos de horário
  static bool hasTimeConflict(
    DateTime date,
    String time,
    int duration, {
    String? excludeId,
  }) {
    if (_box == null || !_box!.isOpen) return false;

    final appointments = getAppointmentsByDate(date);
    final newStartTime = _parseTime(time);
    final newEndTime = newStartTime.add(Duration(minutes: duration));

    for (final appointment in appointments) {
      if (excludeId != null && appointment.id == excludeId) continue;
      if (appointment.status == AppointmentStatus.cancelled) continue;

      final existingStartTime = _parseTime(appointment.time);
      final existingEndTime = existingStartTime.add(
        Duration(minutes: appointment.duration),
      );

      // Verificar sobreposição
      if (newStartTime.isBefore(existingEndTime) &&
          newEndTime.isAfter(existingStartTime)) {
        return true;
      }
    }

    return false;
  }

  static DateTime _parseTime(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return DateTime(2000, 1, 1, hour, minute);
  }
}
