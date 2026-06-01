import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
class ConcernChip extends StatelessWidget {
  final String label; final IconData icon;
  const ConcernChip({super.key, required this.label, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18, color: AppColors.mintDark),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      backgroundColor: Colors.white,
      side: const BorderSide(color: AppColors.mint),
    );
  }
}
