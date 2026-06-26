part of '../app_flows/app_flow_screens.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: _flowAppBar(context, 'Patient Reviews'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Patient Experiences',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Transparent feedback from our clinical community.',
            style: TextStyle(color: AppColors.textGrey, fontSize: 13),
          ),
          const SizedBox(height: 18),
          _ratingSummary(state),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _choicePill('ALL', true),
                const SizedBox(width: 8),
                _choicePill('FACIALS', false),
                const SizedBox(width: 8),
                _choicePill('LASER', false),
                const SizedBox(width: 8),
                _choicePill('ACNE', false),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...state.reviews.map(_reviewCard),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
    );
  }
}
