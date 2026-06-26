class PatientReview {
  final String id;
  final String name;
  final String label;
  final String body;
  final double rating;

  const PatientReview({
    required this.id,
    required this.name,
    required this.label,
    required this.body,
    required this.rating,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'label': label,
      'body': body,
      'rating': rating,
    };
  }

  factory PatientReview.fromJson(Map<String, dynamic> json) {
    return PatientReview(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      label: json['label'] as String? ?? '',
      body: json['body'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
    );
  }
}
