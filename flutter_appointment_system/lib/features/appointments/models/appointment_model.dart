class Appointment {
  final int id;
  final String? documentId;
  final String title;
  final String? description;
  final DateTime date;
  final String appointmentStatus;

  Appointment({
    required this.id,
    this.documentId,
    required this.title,
    this.description,
    required this.date,
    required this.appointmentStatus,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] ?? 0,
      documentId: json['documentId']?.toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: (json['date'] != null && json['date'] != '')
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      appointmentStatus: json['appointment_status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "documentId": documentId,
      "description": description,
      "date": date.toIso8601String(),
      "appointment_status": appointmentStatus,
    };
  }
}
