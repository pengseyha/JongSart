import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';

class ClinicDetailScreen extends StatelessWidget {
  const ClinicDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.watch<AppState>().isFavorite('clinic_lumina');

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // Top Image and Back/Actions Layout Block
                        Stack(
                          children: [
                            SizedBox(
                              height: 280,
                              width: double.infinity,
                              child: Image.network(
                                'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=800', // Premium clinic aesthetic
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFD8F3EC),
                                        Color(0xFF7BC5A8),
                                      ],
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.spa_outlined,
                                        color: Colors.white, size: 56),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: MediaQuery.of(context).padding.top + 8,
                              left: 16,
                              right: 16,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    child: IconButton(
                                      icon: const Icon(Icons.arrow_back,
                                          color: Colors.black, size: 20),
                                      onPressed: () => context.pop(),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                        child: IconButton(
                                          icon: const Icon(Icons.share_outlined,
                                              color: Colors.black, size: 20),
                                          onPressed: () {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Clinic profile link ready to share.',
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                        child: IconButton(
                                          icon: Icon(
                                              isFavorite
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: isFavorite
                                                  ? AppColors.primaryMint
                                                  : Colors.black,
                                              size: 20),
                                          onPressed: () => context
                                              .read<AppState>()
                                              .toggleFavorite('clinic_lumina'),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Overlapping Info Box Header Card
                        Transform.translate(
                          offset: const Offset(0, -30),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.borderGrey),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4)),
                                ],
                              ),
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      _buildBadge(Icons.check_circle_outline,
                                          'Certified Clinic'),
                                      _buildBadge(Icons.verified_outlined,
                                          'Expert Doctors'),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'JongSart Clinic',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textDark),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Row(
                                        children: List.generate(
                                            5,
                                            (index) => const Icon(Icons.star,
                                                color: Colors.amber, size: 16)),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text('4.9',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textDark,
                                              fontSize: 13)),
                                      const SizedBox(width: 4),
                                      const Expanded(
                                        child: Text('(1,221 Reviews)',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: AppColors.textGrey,
                                                fontSize: 13)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  const Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.location_on_outlined,
                                          color: AppColors.primaryMint,
                                          size: 20),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'No. 42 Russian Federation Boulevard (St. 110),\nPhnom Penh, Cambodia',
                                          style: TextStyle(
                                              color: AppColors.textGrey,
                                              fontSize: 13,
                                              height: 1.4),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: AppColors.borderGrey)),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                _buildTab('Overview', true),
                                _buildTab('Doctors', false),
                                _buildTab('Services', false),
                                _buildTab('Gallery', false),
                                _buildTab('Reviews', false),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('About the Clinic',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textDark)),
                              const SizedBox(height: 12),
                              const Text(
                                'JongSart ជាគ្លីនិកថែរក្សាស្បែក និងកែសម្ផស្សឈានមុខគេនៅក្នុងប្រទេសកម្ពុជា។ ផ្អែកលើស្តង់ដារអនាម័យខ្ពស់ និងបច្ចេកវិទ្យាព្យាបាលស្បែកយ៉ាងច្បាស់លាស់ យើងរួមបញ្ចូលគ្នានូវជម្រើសព្យាបាលដ៏ល្អបំផុត ជាមួយការថែទាំយ៉ាងយកចិត្តទុកដាក់ ដើម្បីផ្តល់ជូននូវលទ្ធផលស្បែកមានសុខភាពល្អ និងភ្លឺថ្លា។',
                                style: TextStyle(
                                    color: AppColors.textGrey,
                                    fontSize: 14,
                                    height: 1.6),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: _buildInfoCard(
                                          'Opening Hours', _buildHoursList())),
                                  const SizedBox(width: 12),
                                  Expanded(
                                      child: _buildInfoCard(
                                          'Amenities', _buildAmenitiesList())),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Fixed Bottom Booking Action CTA Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryMint,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  onPressed: () => context.push('/booking'),
                  child: const Text(
                    'Book Consultation',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryMintLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryMint.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primaryMint, size: 14),
          const SizedBox(width: 4),
          Text(text,
              style: const TextStyle(
                  color: AppColors.primaryMint,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTab(String title, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 24.0, bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.primaryMint : AppColors.textGrey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, Widget content) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryMint,
                  fontSize: 13)),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  Widget _buildHoursList() {
    return Column(
      children: [
        _buildTimeRow('Mon - Fri', '8:00 AM - 8:00 PM'),
        const SizedBox(height: 8),
        _buildTimeRow('Sat - Sun', '9:00 AM - 6:00 PM'),
      ],
    );
  }

  Widget _buildTimeRow(String day, String hours) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(day,
            style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 12,
                fontWeight: FontWeight.w500)),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            hours,
            textAlign: TextAlign.end,
            style: const TextStyle(color: AppColors.textDark, fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildAmenitiesList() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildAmenityItem(Icons.wifi, 'Free WiFi')),
            Expanded(child: _buildAmenityItem(Icons.local_parking, 'Parking')),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildAmenityItem(Icons.coffee, 'Lounge')),
            Expanded(child: _buildAmenityItem(Icons.accessible, 'Elevator')),
          ],
        ),
      ],
    );
  }

  Widget _buildAmenityItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textDark),
        const SizedBox(width: 4),
        Expanded(
          child: Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textDark, fontSize: 11)),
        ),
      ],
    );
  }
}
