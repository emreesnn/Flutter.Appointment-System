import 'package:flutter_appointment_system/features/appointments/data/appointments_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_appointment_system/features/appointments/models/appointment_model.dart';

class AppointmentNotifier extends StateNotifier<List<Appointment>> {
  AppointmentNotifier() : super([]);

  final AppointmentService _service = AppointmentService();

  Future<void> loadAppointments() async {
    try {
      final appointments = await _service.loadAppointments();
      state = appointments;
    } catch (e) {
      print("HATA: $e");
    }
  }

  Future<void> addAppointment(Appointment appointment) async {
    try {
      final newAppointment = await _service.addAppointment(appointment);
      state = [...state, newAppointment];
    } catch (e) {
      print("HATA (create): $e");
    }
  }

  Future<Appointment?> getAppointmentByDocumentId(String documentId) async {
    try {
      final appointment = await _service.getAppointmentByDocumentId(documentId);
      return appointment;
    } catch (e) {
      print("HATA (getByDocumentId): $e");
      return null;
    }
  }

  Future<void> updateAppointment(String id, Appointment updated) async {
    try {
      final updatedAppointment = await _service.updateAppointment(id, updated);
      state = [
        for (final item in state)
          if (item.id == id) updatedAppointment else item,
      ];
    } catch (e) {
      print("HATA (update): $e");
    }
  }

  Future<void> deleteAppointment(int id) async {
    try {
      await _service.deleteAppointment(id);
      state = state.where((item) => item.id != id).toList();
    } catch (e) {
      print("HATA (delete): $e");
    }
  }
}

final appointmentProvider =
    StateNotifierProvider<AppointmentNotifier, List<Appointment>>(
      (ref) => AppointmentNotifier(),
    );
