part of '../app_flows/app_flow_screens.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final concerns = [
      (Icons.face_retouching_natural, 'Acne & Breakouts'),
      (Icons.auto_awesome, 'Anti-Aging'),
      (Icons.blur_on, 'Hyperpigmentation'),
      (Icons.healing_outlined, 'Sensitive Skin'),
    ];
    final dates = ['Mon 24', 'Tue 25', 'Wed 26', 'Thu 27', 'Fri 28'];
    final times = ['09:00 AM', '10:30 AM', '12:30 PM', '02:00 PM', '03:30 PM'];

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: _flowAppBar(context, 'Book Consultation'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _bookingStepper(state.activeBookingStep),
          const SizedBox(height: 18),
          const Text(
            'What brings you in today?',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...concerns.map(
            (concern) => _concernOption(
              concern.$1,
              concern.$2,
              state.selectedConcern == concern.$2,
              onTap: () => context.read<AppState>().selectConcern(concern.$2),
            ),
          ),
          const SizedBox(height: 16),
          _sectionTitle('Select Date'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: dates
                .map((date) => _timeChip(
                      date,
                      state.selectedDate == date,
                      onTap: () => context.read<AppState>().selectDate(date),
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
          _sectionTitle('Select Time'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: times
                .map((time) => _timeChip(
                      time,
                      state.selectedTime == time,
                      onTap: () => context.read<AppState>().selectTime(time),
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
          _bookingSummary(state),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () {
              final booking = context.read<AppState>().confirmBooking();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      '${booking.status}: ${booking.date} at ${booking.time}'),
                ),
              );
              context.push('/chat');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryMint,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Confirm Booking',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
