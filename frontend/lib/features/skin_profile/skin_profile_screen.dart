import '../../core/utils/screen_imports.dart';

class SkinProfileScreen extends StatelessWidget {
  const SkinProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final latestBooking = state.bookings.isEmpty ? null : state.bookings.first;
    final recommendations = state.skinRecommendations.take(2).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: flowAppBar(context, 'Profile'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 168),
        children: [
          _profileHeader(context, state),
          const SizedBox(height: 14),
          _skinProfileCard(context, state),
          const SizedBox(height: 14),
          _appointmentCard(context, latestBooking),
          const SizedBox(height: 14),
          _accountActionsCard(context),
          const SizedBox(height: 18),
          sectionTitle('Recommended for Your Skin'),
          const SizedBox(height: 10),
          ...recommendations.map(
            (recommendation) =>
                _compactRecommendationCard(context, recommendation),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
    );
  }
}

Widget _profileHeader(BuildContext context, AppState state) {
  final displayName =
      state.userName.trim().isEmpty ? 'Seyha Peng' : state.userName.trim();
  final phone = state.phone.trim().isEmpty ? 'No phone add' : state.phone;
  final emailValue = state.email?.trim();
  final email = emailValue == null || emailValue.isEmpty ? null : emailValue;

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: panelDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFB9F4EA), Color(0xFF007D68)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryMint.withValues(alpha: 0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.person_rounded,
                  color: Colors.white, size: 35),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  _profileInfoRow(Icons.phone_outlined, phone),
                  if (email != null) ...[
                    const SizedBox(height: 4),
                    _profileInfoRow(Icons.mail_outline_rounded, email),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () => _showDemoMessage(context, 'Edit profile'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF007D68),
                side: const BorderSide(color: AppColors.borderGrey),
                minimumSize: const Size(0, 34),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              child: const Text(
                'Edit',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryMintLight.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            state.skinProfileSummary,
            style: const TextStyle(
              color: Color(0xFF315D56),
              fontSize: 12,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(child: _profileStat('${state.favoriteCount}', 'Saved')),
            Expanded(child: _profileStat('${state.bookings.length}', 'Visits')),
            Expanded(
              child: _profileStat(
                state.averageReviewRating.toStringAsFixed(1),
                'Rating',
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _skinProfileCard(BuildContext context, AppState state) {
  const concerns = [
    'Acne & Breakout',
    'Dark Spot',
    'Sensitive Skin',
    'Dry Skin',
    'Anti-aging',
    'Scar Treatment',
  ];

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: panelDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle('My Skin Profile'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _skinMetricCard('Skin type', 'Combination Oily'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _skinMetricCard('Hydration', '46% Low hydration'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Wrap(
          spacing: 7,
          runSpacing: 7,
          children: [
            _StaticProfileChip(label: 'Congested Pores'),
            _StaticProfileChip(label: 'Uneven Texture'),
            _StaticProfileChip(label: 'Sensitivity'),
          ],
        ),
        const SizedBox(height: 14),
        const Text(
          'Selected concern',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: concerns
              .map(
                (concern) => _concernChip(
                  concern,
                  state.selectedConcern == concern,
                  onTap: () => context.read<AppState>().selectConcern(concern),
                ),
              )
              .toList(),
        ),
      ],
    ),
  );
}

Widget _appointmentCard(BuildContext context, Booking? booking) {
  return Container(
    padding: const EdgeInsets.all(15),
    decoration: panelDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 41,
              height: 41,
              decoration: BoxDecoration(
                color: AppColors.primaryMintLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.calendar_month_outlined,
                  color: Color(0xFF007D68)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking == null
                        ? 'No upcoming consultation'
                        : 'Upcoming consultation',
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    booking == null
                        ? 'Book a visit to complete treatment plan.'
                        : '${booking.clinicName} • ${booking.date}, ${booking.time}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            if (booking != null) statusBadge(booking.status),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            if (booking != null) ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      context.push('/booking-detail/${booking.id}'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF007D68),
                    side: const BorderSide(color: AppColors.borderGrey),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('View Booking'),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: ElevatedButton(
                onPressed: () => context.push('/booking'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007D68),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Book Consultation'),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _accountActionsCard(BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 6),
    decoration: panelDecoration(),
    child: Column(
      children: [
        _actionRow(
          icon: Icons.event_note_outlined,
          title: 'My Bookings',
          subtitle: 'View requests, status, and visit history',
          onTap: () => context.push('/my-bookings'),
        ),
        const Divider(height: 1, indent: 54, color: AppColors.borderGrey),
        _actionRow(
          icon: Icons.favorite_border_rounded,
          title: 'Favorites',
          subtitle: 'Saved clinics and treatments',
          onTap: () => context.push('/favorites'),
        ),
        const Divider(height: 1, indent: 54, color: AppColors.borderGrey),
        _actionRow(
          icon: Icons.switch_account_outlined,
          title: 'Switch Account',
          subtitle: 'Return to login and use another account',
          onTap: () => _switchAccount(context),
        ),
        const Divider(height: 1, indent: 54, color: AppColors.borderGrey),
        _actionRow(
          icon: Icons.logout_rounded,
          title: 'Logout',
          subtitle: 'End this local demo ',
          isDanger: true,
          onTap: () => _switchAccount(context),
        ),
      ],
    ),
  );
}

Widget _compactRecommendationCard(
  BuildContext context,
  SkinRecommendation recommendation,
) {
  final state = context.watch<AppState>();
  final isFavorite = state.isFavorite(recommendation.id);

  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: panelDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                recommendation.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () =>
                  context.read<AppState>().toggleFavorite(recommendation.id),
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color:
                      isFavorite ? const Color(0xFFD4465D) : AppColors.textGrey,
                  size: 21,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          recommendation.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.textGrey,
            fontSize: 12,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primaryMintLight,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                recommendation.match,
                style: const TextStyle(
                  color: Color(0xFF007D68),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                recommendation.price,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => context.push('/booking'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007D68),
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size(70, 34),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              child: const Text(
                'Book',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _profileInfoRow(IconData icon, String text) {
  return Row(
    children: [
      Icon(icon, color: AppColors.textGrey, size: 14),
      const SizedBox(width: 5),
      Expanded(
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.textGrey,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );
}

Widget _profileStat(String value, String label) {
  return Column(
    children: [
      Text(
        value,
        style: const TextStyle(
          color: Color(0xFF007D68),
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
      const SizedBox(height: 3),
      Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: AppColors.textGrey,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.8,
        ),
      ),
    ],
  );
}

Widget _skinMetricCard(String label, String value) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFF7FBFA),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.borderGrey),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textGrey,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF007D68),
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    ),
  );
}

Widget _concernChip(
  String label,
  bool selected, {
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(999),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF007D68) : Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: selected ? const Color(0xFF007D68) : AppColors.borderGrey,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : AppColors.textDark,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );
}

Widget _actionRow({
  required IconData icon,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
  bool isDanger = false,
}) {
  final color = isDanger ? const Color(0xFFD4465D) : const Color(0xFF007D68);

  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: isDanger
                  ? const Color(0xFFFFE7EA)
                  : AppColors.primaryMintLight,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDanger ? color : AppColors.textDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded,
              color: isDanger ? color : AppColors.textGrey),
        ],
      ),
    ),
  );
}

void _showDemoMessage(BuildContext context, String feature) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('$feature is not available in demo mode.')),
  );
}

Future<void> _switchAccount(BuildContext context) async {
  await context.read<AppState>().logout();
  if (!context.mounted) return;
  context.go('/login');
}

class _StaticProfileChip extends StatelessWidget {
  const _StaticProfileChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.primaryMintLight.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF007D68),
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
