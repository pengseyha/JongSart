part of '../app_flows/app_flow_screens.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final clinics = state.searchClinics(_query);

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: _flowAppBar(context, 'Nearby Clinics'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Nearby Clinics',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                'Sort by',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 16),
              Text(
                'Nearest',
                style: TextStyle(
                  color: Color(0xFF007D68),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Icon(Icons.keyboard_arrow_down,
                  size: 16, color: Color(0xFF007D68)),
            ],
          ),
          const SizedBox(height: 16),
          _filterPanel(),
          const SizedBox(height: 18),
          _editableSearchField(
            'Search clinics or treatments',
            onChanged: (value) => setState(() => _query = value),
          ),
          const SizedBox(height: 14),
          if (clinics.isEmpty)
            _emptyState(
              Icons.search_off,
              'No clinics found',
              'Try another skin concern, treatment, or specialty.',
            )
          else
            ...clinics.map((clinic) => _clinicResultCard(context, clinic)),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => context.go('/map'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007D68),
                foregroundColor: Colors.white,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.map_outlined, size: 18),
              label: const Text('Map View'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }
}
