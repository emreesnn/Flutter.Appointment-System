import 'package:flutter/material.dart';
import 'package:flutter_appointment_system/features/appointments/models/appointment_model.dart';
import 'package:flutter_appointment_system/providers/appointment_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppointmentDetailScreen extends ConsumerStatefulWidget {
  final String documentId;
  const AppointmentDetailScreen({super.key, required this.documentId});

  @override
  ConsumerState<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState
    extends ConsumerState<AppointmentDetailScreen> {
  Appointment? _appointment;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointment();
  }

  Future<void> _loadAppointment() async {
    try {
      final appt = await ref
          .read(appointmentProvider.notifier)
          .getAppointmentByDocumentId(widget.documentId);
      setState(() {
        _appointment = appt;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
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
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_appointment == null) {
      return const Scaffold(body: Center(child: Text('Randevu bulunamadı')));
    }

    final appointment = _appointment!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Randevu Detayı'),
        backgroundColor: Colors.blueGrey.shade200,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.event,
                          size: 28,
                          color: Colors.blueGrey,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            appointment.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month, size: 24),
                        const SizedBox(width: 10),
                        Text(
                          '${appointment.date.day.toString().padLeft(2, '0')}.${appointment.date.month.toString().padLeft(2, '0')}.${appointment.date.year}  ${appointment.date.hour.toString().padLeft(2, '0')}:${appointment.date.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.info_outline, size: 24),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              appointment.appointmentStatus,
                            ).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            appointment.appointmentStatus,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _getStatusColor(
                                appointment.appointmentStatus,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Açıklama",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      appointment.description ?? 'Açıklama girilmemiş.',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit, size: 20),
                    label: const Text("Düzenle"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey.shade100,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      context.push('/appointments/edit', extra: appointment);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.cancel_outlined, size: 20),
                    label: const Text("İptal Et"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      final updated = Appointment(
                        id: appointment.id,
                        documentId: appointment.documentId,
                        title: appointment.title,
                        description: appointment.description,
                        date: appointment.date,
                        appointmentStatus: 'İptal',
                      );

                      await ref
                          .read(appointmentProvider.notifier)
                          .updateAppointment(appointment.documentId!, updated);

                      if (context.mounted) context.pop(true);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
