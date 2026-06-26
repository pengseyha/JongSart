class Offer {
  final String id;
  final String title;
  final String subtitle;
  final String price;
  final String badge;
  final bool isClaimed;

  const Offer({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.badge,
    this.isClaimed = false,
  });

  Offer copyWith({bool? isClaimed}) {
    return Offer(
      id: id,
      title: title,
      subtitle: subtitle,
      price: price,
      badge: badge,
      isClaimed: isClaimed ?? this.isClaimed,
    );
  }
}
