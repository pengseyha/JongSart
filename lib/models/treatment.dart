class Treatment {
  final String id, name, category, description;
  final int duration;
  final double price;
  final List<String> beforeAfter;
  final List<Map<String, String>> faqs;
  Treatment(
      {required this.id,
      required this.name,
      required this.category,
      required this.duration,
      required this.price,
      required this.description,
      required this.beforeAfter,
      required this.faqs});
  factory Treatment.fromJson(Map<String, dynamic> json) => Treatment(
        id: json['id'],
        name: json['name'],
        category: json['category'],
        duration: json['duration'],
        price: json['price'].toDouble(),
        description: json['description'],
        beforeAfter: List<String>.from(json['beforeAfter']),
        faqs: List<Map<String, String>>.from(json['faqs']),
      );
}
