import 'package:flutter/material.dart';
import 'package:flutter_appointment_system/features/appointments/models/appointment_model.dart';
import 'package:flutter_appointment_system/providers/appointment_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:go_router/go_router.dart';

class AppointmentFormScreen extends ConsumerStatefulWidget {
  final Appointment? existingAppointment;
  const AppointmentFormScreen({super.key, this.existingAppointment});

  @override
  ConsumerState<AppointmentFormScreen> createState() =>
      _AppointmentFormScreenState();
}

class _AppointmentFormScreenState extends ConsumerState<AppointmentFormScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedTime;
  final List<String> _availableTimes = [
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
  ];

  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool get _isEditMode => widget.existingAppointment != null;

  @override
  void initState() {
    super.initState();

    if (_isEditMode) {
      final appt = widget.existingAppointment!;
      _titleController.text = appt.title;
      _descController.text = appt.description ?? '';
      _selectedDay = appt.date;
      _focusedDay = appt.date;

      final formattedTime =
          "${appt.date.hour.toString().padLeft(2, '0')}:${appt.date.minute.toString().padLeft(2, '0')}";
      _selectedTime = _availableTimes.contains(formattedTime)
          ? formattedTime
          : null;
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() &&
        _selectedDay != null &&
        _selectedTime != null) {
      try {
        final timeParts = _selectedTime!.split(':');
        final fullDateTime = DateTime(
          _selectedDay!.year,
          _selectedDay!.month,
          _selectedDay!.day,
          int.parse(timeParts[0]),
          int.parse(timeParts[1]),
        );

        final updatedAppointment = Appointment(
          id: widget.existingAppointment?.id ?? 0,
          documentId: widget.existingAppointment?.documentId,
          title: _titleController.text,
          description: _descController.text,
          date: fullDateTime,
          appointmentStatus:
              widget.existingAppointment?.appointmentStatus ?? 'Aktif',
        );

        if (_isEditMode) {
          await ref
              .read(appointmentProvider.notifier)
              .updateAppointment(
                updatedAppointment.documentId!,
                updatedAppointment,
              );
        } else {
          await ref
              .read(appointmentProvider.notifier)
              .addAppointment(updatedAppointment);
        }

        if (context.mounted) {
          context.pop(true);
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Hata oluştu: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Randevuyu Düzenle' : 'Randevu Oluştur'),
        backgroundColor: Colors.blueGrey.shade200,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TableCalendar(
                locale: 'tr_TR',
                firstDay: DateTime.utc(2020),
                lastDay: DateTime.utc(2030),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                onDaySelected: (selected, focused) {
                  setState(() {
                    _selectedDay = selected;
                    _focusedDay = focused;
                  });
                },
                calendarFormat: CalendarFormat.month,
                availableCalendarFormats: const {CalendarFormat.month: ''},
              ),
              const SizedBox(height: 16),
              const Text(
                'Saat Seçimi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                children: _availableTimes.map((time) {
                  final isSelected = _selectedTime == time;
                  return ChoiceChip(
                    label: Text(time),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedTime = time),
                    selectedColor: Colors.orange.shade200,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Başlık',
                  prefixIcon: const Icon(Icons.title_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blueGrey.shade100),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.blueGrey.shade300,
                      width: 1.5,
                    ),
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Başlık gerekli' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Açıklama',
                  prefixIcon: const Icon(Icons.description_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blueGrey.shade100),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.blueGrey.shade300,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: Text(_isEditMode ? 'Kaydet' : 'Randevuyu Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
