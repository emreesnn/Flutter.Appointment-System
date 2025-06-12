import 'package:flutter/material.dart';
import 'package:flutter_appointment_system/providers/appointment_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppointmentListScreen extends ConsumerStatefulWidget {
  const AppointmentListScreen({super.key});

  @override
  ConsumerState<AppointmentListScreen> createState() =>
      _AppointmentListScreenState();
}

class _AppointmentListScreenState extends ConsumerState<AppointmentListScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(appointmentProvider.notifier).loadAppointments();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "aktif":
        return Colors.green.shade600;
      case "iptal":
        return Colors.red.shade600;
      case "geçmiş":
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appointments = ref.watch(appointmentProvider);

    if (appointments.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Randevular'),
        backgroundColor: Colors.blueGrey.shade200,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            child: ListTile(
              title: Text(
                appointment.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text('Tarih: ${appointment.date}'),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(
                    appointment.appointmentStatus,
                  ).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  appointment.appointmentStatus,
                  style: TextStyle(
                    color: _getStatusColor(appointment.appointmentStatus),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              onTap: () {
                context.push('/detail/${appointment.documentId}');
              },
            ),
          );
        },
      ),
    );
  }
}
