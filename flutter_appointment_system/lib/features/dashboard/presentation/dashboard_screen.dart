import 'package:flutter/material.dart';
import 'package:flutter_appointment_system/features/appointments/models/appointment_model.dart';
import 'package:flutter_appointment_system/providers/appointment_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Appointment>> _appointmentsByDay = {};

  late final ProviderSubscription<List<Appointment>> _subscription;

  @override
  void initState() {
    super.initState();

    ref.read(appointmentProvider.notifier).loadAppointments();

    _subscription = ref.listenManual<List<Appointment>>(appointmentProvider, (
      previous,
      next,
    ) {
      if (next.isNotEmpty) {
        _groupAppointments(next);
      }
    });
  }

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }

  void _groupAppointments(List<Appointment> appointments) {
    final Map<DateTime, List<Appointment>> grouped = {};
    for (final appt in appointments) {
      final key = DateTime.utc(appt.date.year, appt.date.month, appt.date.day);
      grouped.putIfAbsent(key, () => []).add(appt);
    }

    setState(() {
      _appointmentsByDay = grouped;
    });
  }

  List<Appointment> _getAppointmentsForDay(DateTime day) {
    return _appointmentsByDay[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final appointments = ref.watch(appointmentProvider);

    if (_appointmentsByDay.isEmpty && appointments.isNotEmpty) {
      _groupAppointments(appointments);
    }

    final selectedAppointments = _getAppointmentsForDay(
      _selectedDay ?? _focusedDay,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ana Sayfa"),
        backgroundColor: Colors.blueGrey.shade200,
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              context.push('/login');
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: CircleAvatar(child: Icon(Icons.person)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: 'tr_TR',
            headerStyle: HeaderStyle(formatButtonVisible: false),
            firstDay: DateTime.utc(2020),
            lastDay: DateTime.utc(2030),
            focusedDay: _focusedDay,
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _getAppointmentsForDay,
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.push('/appointments'),
              child: const Text("Tüm randevuları görüntüle"),
            ),
          ),
          Expanded(
            child: selectedAppointments.isEmpty
                ? const Center(child: Text("Bu gün için randevu bulunmuyor."))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: selectedAppointments.length,
                    itemBuilder: (context, index) {
                      final appt = selectedAppointments[index];
                      return Card(
                        child: ListTile(
                          title: Text(appt.title),
                          subtitle: Text(
                            "Saat: ${appt.date.hour.toString().padLeft(2, '0')}:${appt.date.minute.toString().padLeft(2, '0')}",
                          ),
                          trailing: Text(appt.appointmentStatus),
                          onTap: () async {
                            final result = await context.push(
                              '/detail/${appt.documentId}',
                            );
                            if (result == true) {
                              await ref
                                  .read(appointmentProvider.notifier)
                                  .loadAppointments();
                            }
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await context.push('/appointments/new');
          if (result == true) {
            await ref.read(appointmentProvider.notifier).loadAppointments();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
