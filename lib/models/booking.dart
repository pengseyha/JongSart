class Booking {
  final String id;
  final String concern;
  final String date;
  final String time;
  final String doctorName;
  final String clinicName;
  final String status;

  const Booking({
    required this.id,
    required this.concern,
    required this.date,
    required this.time,
    required this.doctorName,
    required this.clinicName,
    required this.status,
  });
}
