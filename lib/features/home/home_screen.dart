import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../theme/app_colors.dart';
import '../../state/app_state.dart';
import '../../widgets/app_bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'JongSart',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryMint),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.location_on_outlined,
                                  size: 16, color: AppColors.primaryMint),
                              SizedBox(width: 4),
                              Text('Phnom Penh',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textDark,
                                      fontWeight: FontWeight.w500)),
                              Icon(Icons.keyboard_arrow_down,
                                  size: 16, color: AppColors.textDark),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: () => context.push('/promo'),
                          icon: const Icon(Icons.notifications_none,
                              color: AppColors.textDark),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderGrey),
                  ),
                  child: TextField(
                    readOnly: true,
                    onTap: () => context.go('/search'),
                    decoration: const InputDecoration(
                      hintText: 'Search clinics, treatments, doctors...',
                      hintStyle:
                          TextStyle(color: AppColors.textGrey, fontSize: 13),
                      prefixIcon: Icon(Icons.search, color: AppColors.textGrey),
                      suffixIcon:
                          Icon(Icons.tune, color: AppColors.primaryMint),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildClinicBanner(context),
            ),
            SliverToBoxAdapter(
              child: _buildSectionHeader('Skin Concerns', null),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.15,
                ),
                delegate: SliverChildListDelegate([
                  _buildConcernCard(
                      'Acne',
                      Icons.spa_outlined,
                      Colors.redAccent.withValues(alpha: 0.1),
                      Colors.redAccent),
                  _buildConcernCard(
                      'Pigmentation',
                      Icons.wb_sunny_outlined,
                      Colors.orangeAccent.withValues(alpha: 0.1),
                      Colors.orangeAccent),
                  _buildConcernCard(
                      'Aging',
                      Icons.access_time,
                      Colors.blueAccent.withValues(alpha: 0.1),
                      Colors.blueAccent),
                  _buildConcernCard('Hydration', Icons.water_drop_outlined,
                      Colors.cyan.withValues(alpha: 0.1), Colors.cyan),
                ]),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildSectionHeader(
                  'Top Dermatologists', () => context.go('/search')),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 250,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: [
                    _buildDoctorCard(context, 'Dr. Sarah Chen', 'MEDICAL LASER',
                        4.9, 'SC', AppColors.primaryMint),
                    const SizedBox(width: 16),
                    _buildDoctorCard(context, 'Dr. James Wilson',
                        'DERMATO-SURGERY', 4.8, 'JW', const Color(0xFF2563EB)),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildSectionHeader('Popular Treatments', null),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: [
                    _buildFilterChip('All', true),
                    _buildFilterChip('Facial', false),
                    _buildFilterChip('Laser', false),
                    _buildFilterChip('Peeling', false),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: state.isLoading
                  ? const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Center(
                            child: CircularProgressIndicator(
                                color: AppColors.primaryMint)),
                      ),
                    )
                  : state.treatments.isEmpty
                      ? const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Center(
                                child: Text(
                                    'No treatments found. Please check back soon.',
                                    style:
                                        TextStyle(color: AppColors.textGrey))),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final treatment = state.treatments[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: InkWell(
                                  onTap: () =>
                                      context.push('/treatment-detail'),
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                          color: AppColors.borderGrey),
                                    ),
                                    child: Row(
                                      children: [
                                        Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(16),
                                                      bottomLeft:
                                                          Radius.circular(16)),
                                              child: CachedNetworkImage(
                                                imageUrl: treatment.imageUrl,
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(
                                                            width: 100,
                                                            height: 100,
                                                            color: Colors
                                                                .grey.shade200,
                                                            child: const Icon(
                                                                Icons.error)),
                                              ),
                                            ),
                                            Positioned(
                                              top: 8,
                                              left: 8,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primaryMint,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  treatment.duration,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(treatment.title,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                        color:
                                                            AppColors.textDark),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                                const SizedBox(height: 2),
                                                const Text(
                                                    'Luminaire Aesthetics',
                                                    style: TextStyle(
                                                        color:
                                                            AppColors.textGrey,
                                                        fontSize: 11)),
                                                const SizedBox(height: 6),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text('FROM',
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .textGrey,
                                                            fontSize: 8,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Text(treatment.price,
                                                        style: const TextStyle(
                                                            color: AppColors
                                                                .primaryMint,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            fontSize: 15)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Icon(Icons.arrow_forward,
                                              size: 20,
                                              color: AppColors.textGrey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: state.treatments.length,
                          ),
                        ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }

  Widget _buildClinicBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: CachedNetworkImageProvider(
              'https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&q=80&w=800'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              AppColors.primaryMint.withValues(alpha: 0.9),
              Colors.transparent
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, size: 14, color: AppColors.primaryMint),
                      SizedBox(width: 4),
                      Text('Editor\'s Pick',
                          style: TextStyle(
                              color: AppColors.primaryMint,
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Luminaire Aesthetics',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Elite Laser & Anti-Aging Specialists',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 12)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryMint,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    minimumSize: const Size(110, 36),
                  ),
                  onPressed: () => context.push('/clinic-detail'),
                  child: const Text('View Clinic',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ),
                Row(
                  children: [
                    Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.5),
                            shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.5),
                            shape: BoxShape.circle)),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback? onSeeAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark)),
          ),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              child: const Text('See all',
                  style: TextStyle(
                      color: AppColors.primaryMint,
                      fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  Widget _buildConcernCard(
      String title, IconData icon, Color bgColor, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 12),
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                  fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildDoctorAvatar(String initials, Color color) {
    return CircleAvatar(
      radius: 36,
      backgroundColor: color.withValues(alpha: 0.12),
      child: Text(
        initials,
        style:
            TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, String name, String specialty,
      double rating, String initials, Color avatarColor) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              _buildDoctorAvatar(initials, avatarColor),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: const CircleAvatar(
                    radius: 10,
                    backgroundColor: AppColors.primaryMint,
                    child: Icon(Icons.check, color: Colors.white, size: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(name,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.textDark),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12)),
            child: Text(specialty,
                style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 0.5)),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: AppColors.primaryMint, size: 14),
              const SizedBox(width: 4),
              Text(rating.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push('/doctor-profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF0F766E), // Darker green for book button
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Book',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryMint : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: isSelected ? AppColors.primaryMint : AppColors.borderGrey),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textGrey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
