import '../../core/utils/screen_imports.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: flowAppBar(context, 'Patient Reviews'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          const Text(
            'Customer Reviews',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Feedback from customers who booked through JongSart.',
            style: TextStyle(color: AppColors.textGrey, fontSize: 13),
          ),
          const SizedBox(height: 18),
          ratingSummary(state),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                choicePill('ALL', true),
                const SizedBox(width: 8),
                choicePill('FACIALS', false),
                const SizedBox(width: 8),
                choicePill('LASER', false),
                const SizedBox(width: 8),
                choicePill('ACNE', false),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...state.reviews.map(reviewCard),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: -1),
    );
  }
}
