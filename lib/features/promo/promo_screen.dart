part of '../app_flows/app_flow_screens.dart';

class PromoScreen extends StatelessWidget {
  const PromoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final offers = state.offers;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: _flowAppBar(context, 'Promotions'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Curated Offers',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Premium clinical treatments at special rates.',
            style: TextStyle(color: AppColors.textGrey, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Flash Deals',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE7EA),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  '02:45:30',
                  style: TextStyle(
                    color: Color(0xFFD4465D),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _flashDeal(context, offers.first),
          const SizedBox(height: 18),
          _sectionTitle('Treatment Bundles'),
          const SizedBox(height: 10),
          ...offers.skip(1).map((offer) => _bundleCard(context, offer)),
          const SizedBox(height: 12),
          _giftWellnessCard(context),
          const SizedBox(height: 18),
          _sectionTitle('Your Coupons'),
          const SizedBox(height: 10),
          _couponCard(),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
    );
  }
}
