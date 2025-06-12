import 'package:dio/dio.dart';
import 'package:flutter_appointment_system/features/appointments/models/appointment_model.dart';

class AppointmentService {
  static final Dio _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8000/api'));

  Future<List<Appointment>> loadAppointments() async {
    final response = await _dio.get('/appointments');
    final List data = response.data['data'];
    return data.map((e) => Appointment.fromJson(e)).toList();
  }

  Future<Appointment> addAppointment(Appointment appointment) async {
    final response = await _dio.post(
      '/appointments',
      data: {'data': appointment.toJson()},
    );

    return appointment;
  }

  Future<Appointment> getAppointmentByDocumentId(String docId) async {
    final response = await _dio.get('/appointments/$docId');
    final Map<String, dynamic> data = response.data;
    if (data.isNotEmpty) {
      return Appointment.fromJson(data);
    } else {
      throw Exception("documentId ile randevu bulunamadı: $docId");
    }
  }

  Future<Appointment> updateAppointment(String id, Appointment appointment) async {
    final response = await _dio.put(
      '/appointments/$id',
      data: {'data': appointment.toJson()},
    );
    final data = response.data['data'];
    if (data == null) throw Exception("updateAppointment boş veri döndürdü");
    return Appointment.fromJson(data);
  }

  Future<void> deleteAppointment(int id) async {
    await _dio.delete('/appointments/$id');
  }
}
