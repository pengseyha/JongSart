import '../../core/utils/screen_imports.dart';

class SkinProfileScreen extends StatelessWidget {
  const SkinProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final latestBooking = state.bookings.isEmpty ? null : state.bookings.first;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: flowAppBar(context, 'Profile'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          _profileHeader(context, state),
          const SizedBox(height: 16),
          skinScoreCard(state),
          const SizedBox(height: 16),
          _concernSelector(context, state),
          const SizedBox(height: 16),
          if (latestBooking != null)
            _upcomingBookingCard(context, latestBooking)
          else
            _emptyBookingCard(context),
          const SizedBox(height: 12),
          _profileActions(context),
          const SizedBox(height: 18),
          sectionTitle('Clinical Match Recommendations'),
          const SizedBox(height: 10),
          ...state.skinRecommendations.map(
            (recommendation) => recommendationCard(context, recommendation),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => context.push('/reviews'),
            icon: const Icon(Icons.rate_review_outlined),
            label: const Text('View Patient Experiences'),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
    );
  }
}

Widget _concernSelector(BuildContext context, AppState state) {
  const concerns = [
    'Acne & Breakouts',
    'Dark Spots',
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
        sectionTitle('My Skin Concern'),
        const SizedBox(height: 4),
        const Text(
          'Select your main concern. We save it for your next booking.',
          style: TextStyle(color: AppColors.textGrey, fontSize: 12),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: concerns
              .map((concern) => timeChip(
                    concern,
                    state.selectedConcern == concern,
                    onTap: () =>
                        context.read<AppState>().selectConcern(concern),
                  ))
              .toList(),
        ),
      ],
    ),
  );
}

Widget _profileHeader(BuildContext context, AppState state) {
  final displayName =
      state.userName.trim().isEmpty ? 'Seyha Peng' : state.userName.trim();
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: panelDecoration(),
    child: Column(
      children: [
        Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFEFFFFB), Color(0xFFB5F0E6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryMint.withValues(alpha: 0.16),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.person,
              color: AppColors.brandDarkGreen, size: 36),
        ),
        const SizedBox(height: 12),
        Text(
          displayName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          state.skinProfileSummary,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textGrey,
            fontSize: 12,
            height: 1.4,
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

Widget _profileActions(BuildContext context) {
  return Row(
    children: [
      Expanded(
        child: OutlinedButton.icon(
          onPressed: () => context.push('/my-bookings'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.brandDarkGreen,
            side: const BorderSide(color: AppColors.borderGrey),
            padding: const EdgeInsets.symmetric(vertical: 13),
          ),
          icon: const Icon(Icons.event_note_outlined, size: 18),
          label: const Text('Bookings'),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: OutlinedButton.icon(
          onPressed: () => _switchAccount(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.brandDarkGreen,
            side: const BorderSide(color: AppColors.borderGrey),
            padding: const EdgeInsets.symmetric(vertical: 13),
          ),
          icon: const Icon(Icons.switch_account_outlined, size: 18),
          label: const Text('Switch'),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: ElevatedButton.icon(
          onPressed: () => _switchAccount(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.brandDarkGreen,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 13),
          ),
          icon: const Icon(Icons.logout, size: 18),
          label: const Text('Logout'),
        ),
      ),
    ],
  );
}

Future<void> _switchAccount(BuildContext context) async {
  await context.read<AppState>().logout();
  if (!context.mounted) return;
  context.go('/login');
}

Widget _profileStat(String value, String label) {
  return Column(
    children: [
      Text(
        value,
        style: const TextStyle(
          color: Color(0xFF007D68),
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 3),
      Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: AppColors.textGrey,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
        ),
      ),
    ],
  );
}

Widget _emptyBookingCard(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: panelDecoration(),
    child: Row(
      children: [
        const CircleAvatar(
          backgroundColor: AppColors.primaryMintLight,
          child: Icon(Icons.calendar_today_outlined, color: Color(0xFF007D68)),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'No upcoming consultation',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 3),
              Text(
                'Book a visit to complete your treatment plan.',
                style: TextStyle(color: AppColors.textGrey, fontSize: 12),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () => context.push('/booking'),
          child: const Text('Book'),
        ),
      ],
    ),
  );
}

Widget _upcomingBookingCard(BuildContext context, Booking booking) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: panelDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Latest Booking',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            statusBadge(booking.status),
          ],
        ),
        const SizedBox(height: 10),
        summaryRow(Icons.local_hospital_outlined, 'Clinic', booking.clinicName),
        summaryRow(Icons.healing_outlined, 'Concern', booking.concern),
        summaryRow(Icons.calendar_today_outlined, 'Date', booking.date),
        summaryRow(Icons.schedule, 'Time', booking.time),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => context.push('/booking-detail/${booking.id}'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007D68),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('View Booking'),
          ),
        ),
      ],
    ),
  );
}
