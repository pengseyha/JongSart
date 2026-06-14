part of '../app_flows/app_flow_screens.dart';

class SkinProfileScreen extends StatelessWidget {
  const SkinProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final latestBooking = state.bookings.isEmpty ? null : state.bookings.first;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: _flowAppBar(context, 'Profile'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _profileHeader(state),
          const SizedBox(height: 16),
          _skinScoreCard(state),
          const SizedBox(height: 16),
          if (latestBooking != null)
            _upcomingBookingCard(context, latestBooking)
          else
            _emptyBookingCard(context),
          const SizedBox(height: 18),
          _sectionTitle('Clinical Match Recommendations'),
          const SizedBox(height: 10),
          ...state.skinRecommendations.map(
            (recommendation) => _recommendationCard(context, recommendation),
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

Widget _profileHeader(AppState state) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: _panelDecoration(),
    child: Column(
      children: [
        const CircleAvatar(
          radius: 34,
          backgroundColor: Color(0xFFB5F0E6),
          child: Icon(Icons.person, color: Color(0xFF007D68), size: 34),
        ),
        const SizedBox(height: 10),
        const Text(
          'Seyha Peng',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
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
    decoration: _panelDecoration(),
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
    decoration: _panelDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upcoming Consultation',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        _summaryRow(Icons.healing_outlined, 'Concern', booking.concern),
        _summaryRow(Icons.calendar_today_outlined, 'Date', booking.date),
        _summaryRow(Icons.schedule, 'Time', booking.time),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => context.push('/chat'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007D68),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Message Reception'),
          ),
        ),
      ],
    ),
  );
}
