import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
class DoctorCard extends StatelessWidget {
  final String name, specialty, imageUrl; final double rating;
  const DoctorCard({super.key, required this.name, required this.specialty, required this.rating, required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160, margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 4)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), child: Image.network(imageUrl, height: 100, width: double.infinity, fit: BoxFit.cover)),
        Padding(padding: const EdgeInsets.all(8), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4), Text(specialty, style: const TextStyle(fontSize: 12, color: AppColors.greyText)),
          const SizedBox(height: 4), Row(children: [const Icon(Icons.star, size: 14, color: Colors.amber), Text(' $rating')]),
        ])),
      ]),
    );
  }
}
