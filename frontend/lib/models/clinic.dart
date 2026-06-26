class Clinic {
  final String id;
  final String name;
  final String specialty;
  final String address;
  final String distance;
  final double rating;
  final int reviewCount;
  final List<String> tags;
  final bool isOpen;

  const Clinic({
    required this.id,
    required this.name,
    required this.specialty,
    required this.address,
    required this.distance,
    required this.rating,
    required this.reviewCount,
    required this.tags,
    required this.isOpen,
  });
}
