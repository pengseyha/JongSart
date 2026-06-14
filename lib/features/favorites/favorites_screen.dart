part of '../app_flows/app_flow_screens.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final favoriteClinics = state.favoriteClinics;
    final favoriteRecommendations = state.favoriteRecommendations;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: _flowAppBar(context, 'Favorites'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(child: _tabLabel('Clinics', true)),
              Expanded(child: _tabLabel('Treatments', false)),
            ],
          ),
          const SizedBox(height: 18),
          if (favoriteClinics.isEmpty && favoriteRecommendations.isEmpty)
            _emptyState(
              Icons.favorite_border,
              'No favorites yet',
              'Save clinics and treatments to compare them later.',
            )
          else ...[
            ...favoriteClinics
                .map((clinic) => _favoriteClinicCard(context, clinic)),
            if (favoriteRecommendations.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Treatments',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
            ],
            ...favoriteRecommendations.map(
              (recommendation) =>
                  _favoriteRecommendationCard(context, recommendation),
            ),
          ],
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
    );
  }
}
