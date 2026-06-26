class Doctor {
  final String id, name, specialty, clinic, about, imageUrl;
  final int experience, patients;
  final double rating;
  const Doctor(
      {required this.id,
      required this.name,
      required this.specialty,
      required this.experience,
      required this.rating,
      required this.patients,
      required this.clinic,
      required this.about,
      required this.imageUrl});
  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        id: json['id'],
        name: json['name'],
        specialty: json['specialty'],
        experience: json['experience'],
        rating: json['rating'].toDouble(),
        patients: json['patients'],
        clinic: json['clinic'],
        about: json['about'],
        imageUrl: json['imageUrl'],
      );
}
