import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class DoctorCard extends StatelessWidget {
  final String name, specialty, imageUrl;
  final double rating;
  const DoctorCard(
      {super.key,
      required this.name,
      required this.specialty,
      required this.rating,
      required this.imageUrl});

  String get _initials {
    final parts = name.replaceAll('Dr.', '').trim().split(RegExp(r'\s+'));
    return parts
        .take(2)
        .map((part) => part.isNotEmpty ? part[0] : '')
        .join()
        .toUpperCase();
  }

  Widget _buildImageFallback() {
    return Container(
      height: 100,
      width: double.infinity,
      color: AppColors.primaryMintLight,
      alignment: Alignment.center,
      child: Text(
        _initials,
        style: const TextStyle(
          color: AppColors.primaryMint,
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 4)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Image.network(
            imageUrl,
            height: 100,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildImageFallback(),
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(8),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(specialty,
                  style:
                      const TextStyle(fontSize: 12, color: AppColors.greyText)),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.star, size: 14, color: Colors.amber),
                Text(' $rating')
              ]),
            ])),
      ]),
    );
  }
}
