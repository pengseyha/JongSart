import '../../core/utils/screen_imports.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final favoriteClinics = state.favoriteClinics;
    final favoriteRecommendations = state.favoriteRecommendations;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: flowAppBar(context, 'Favorites'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          _favoritesSummary(
            favoriteClinics.length + favoriteRecommendations.length,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: tabLabel('Clinics', true)),
              Expanded(child: tabLabel('Treatments', false)),
            ],
          ),
          const SizedBox(height: 18),
          if (favoriteClinics.isEmpty && favoriteRecommendations.isEmpty)
            _emptyFavorites(context)
          else ...[
            ...favoriteClinics
                .map((clinic) => favoriteClinicCard(context, clinic)),
            if (favoriteRecommendations.isNotEmpty) ...[
              const SizedBox(height: 8),
              sectionTitle('Saved Treatments'),
              const SizedBox(height: 10),
            ],
            ...favoriteRecommendations.map(
              (recommendation) =>
                  favoriteRecommendationCard(context, recommendation),
            ),
            const SizedBox(height: 14),
            _recommendedForYou(context, state),
          ],
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
    );
  }
}

Widget _favoritesSummary(int count) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.primaryMintLight,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFD6EEE8)),
    ),
    child: Row(
      children: [
        const CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.favorite, color: AppColors.brandDarkGreen),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$count saved item${count == 1 ? '' : 's'}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 3),
              const Text(
                'Your demo shortlist for clinics and treatments.',
                style: TextStyle(color: AppColors.textGrey, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _emptyFavorites(BuildContext context) {
  return Column(
    children: [
      emptyState(
        Icons.favorite_border,
        'No favorites yet',
        'Save clinics and treatments to compare them later.',
      ),
      const SizedBox(height: 12),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => context.push('/search'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.brandDarkGreen,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: const Icon(Icons.search),
          label: const Text('Browse Clinics'),
        ),
      ),
    ],
  );
}

Widget _recommendedForYou(BuildContext context, AppState state) {
  final recommendations = state.skinRecommendations
      .where((item) => !state.isFavorite(item.id))
      .take(2)
      .toList();
  if (recommendations.isEmpty) return const SizedBox.shrink();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      sectionTitle('Recommended for You'),
      const SizedBox(height: 10),
      ...recommendations.map(
        (recommendation) => favoriteRecommendationCard(context, recommendation),
      ),
    ],
  );
}
