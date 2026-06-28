/// Status lifecycle for a clinic appointment request.
///
/// In Cambodia, a booking is not confirmed instantly. The customer first sends
/// a request (pending), then clinic staff confirm / reschedule / cancel, and
/// finally the visit is marked completed.
enum BookingStatus {
  pending,
  confirmed,
  rescheduled,
  cancelled,
  completed;

  /// Full label used on detail screens.
  String get label {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending confirmation';
      case BookingStatus.confirmed:
        return 'Confirme';
      case BookingStatus.rescheduled:
        return 'Reschedule';
      case BookingStatus.cancelled:
        return 'Cancelle';
      case BookingStatus.completed:
        return 'Complete';
    }
  }

  /// Short label used on status badges.
  String get badgeLabel {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.rescheduled:
        return 'Rescheduled';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.completed:
        return 'Completed';
    }
  }

  static BookingStatus fromName(String? name) {
    return BookingStatus.values.firstWhere(
      (status) => status.name == name,
      orElse: () => BookingStatus.pending,
    );
  }
}

class Booking {
  final String id;
  final String patientName;
  final String phone;
  final String? telegramOrWhatsapp;
  final String concern;
  final String treatmentId;
  final String treatmentName;
  final String clinicId;
  final String clinicName;
  final String? doctorId;
  final String? doctorName;
  final String date;
  final String time;
  final String note;
  final BookingStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Booking({
    required this.id,
    required this.patientName,
    required this.phone,
    this.telegramOrWhatsapp,
    required this.concern,
    required this.treatmentId,
    required this.treatmentName,
    required this.clinicId,
    required this.clinicName,
    this.doctorId,
    this.doctorName,
    required this.date,
    required this.time,
    required this.note,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  Booking copyWith({
    BookingStatus? status,
    String? date,
    String? time,
    DateTime? updatedAt,
  }) {
    return Booking(
      id: id,
      patientName: patientName,
      phone: phone,
      telegramOrWhatsapp: telegramOrWhatsapp,
      concern: concern,
      treatmentId: treatmentId,
      treatmentName: treatmentName,
      clinicId: clinicId,
      clinicName: clinicName,
      doctorId: doctorId,
      doctorName: doctorName,
      date: date ?? this.date,
      time: time ?? this.time,
      note: note,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientName': patientName,
      'phone': phone,
      'telegramOrWhatsapp': telegramOrWhatsapp,
      'concern': concern,
      'treatmentId': treatmentId,
      'treatmentName': treatmentName,
      'clinicId': clinicId,
      'clinicName': clinicName,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'date': date,
      'time': time,
      'note': note,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      patientName: json['patientName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      telegramOrWhatsapp: json['telegramOrWhatsapp'] as String?,
      concern: json['concern'] as String? ?? '',
      treatmentId: json['treatmentId'] as String? ?? '',
      treatmentName: json['treatmentName'] as String? ?? '',
      clinicId: json['clinicId'] as String? ?? '',
      clinicName: json['clinicName'] as String? ?? '',
      doctorId: json['doctorId'] as String?,
      doctorName: json['doctorName'] as String?,
      date: json['date'] as String? ?? '',
      time: json['time'] as String? ?? '',
      note: json['note'] as String? ?? '',
      status: BookingStatus.fromName(json['status'] as String?),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.tryParse(json['updatedAt'] as String),
    );
  }
}
