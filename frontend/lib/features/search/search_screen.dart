import '../../core/utils/screen_imports.dart';

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
    final treatments = state.searchTreatments(_query);
    final doctors = state.searchDoctors(_query);
    final hasResults =
        clinics.isNotEmpty || treatments.isNotEmpty || doctors.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: flowAppBar(context, 'Search'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          editableSearchField(
            'Search clinics, treatments, doctors...',
            onChanged: (value) => setState(() => _query = value),
          ),
          const SizedBox(height: 16),
          filterPanel(),
          const SizedBox(height: 18),
          if (!hasResults)
            emptyState(
              Icons.search_off,
              'No results found',
              'Try another skin concern or clinic name.',
            )
          else ...[
            if (treatments.isNotEmpty) ...[
              _searchSectionLabel('Treatments (${treatments.length})'),
              const SizedBox(height: 10),
              ...treatments.map(
                (treatment) => _treatmentResultCard(context, treatment),
              ),
              const SizedBox(height: 8),
            ],
            if (clinics.isNotEmpty) ...[
              _searchSectionLabel('Clinics (${clinics.length})'),
              const SizedBox(height: 10),
              ...clinics.map((clinic) => clinicResultCard(context, clinic)),
              const SizedBox(height: 8),
            ],
            if (doctors.isNotEmpty) ...[
              _searchSectionLabel('Doctors (${doctors.length})'),
              const SizedBox(height: 10),
              ...doctors.map(
                (doctor) => _doctorResultCard(context, doctor),
              ),
              const SizedBox(height: 8),
            ],
          ],
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

Widget _searchSectionLabel(String label) {
  return Text(
    label,
    style: const TextStyle(
      color: AppColors.textDark,
      fontSize: 14,
      fontWeight: FontWeight.w800,
    ),
  );
}

Widget _treatmentResultCard(BuildContext context, Treatment treatment) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: panelDecoration(),
    child: Row(
      children: [
        imageTile(Icons.spa_outlined),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(treatment.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: titleStyle()),
              const SizedBox(height: 4),
              Text(treatment.category,
                  style:
                      const TextStyle(color: AppColors.textGrey, fontSize: 12)),
              const SizedBox(height: 4),
              Text('From ${treatment.price}',
                  style: const TextStyle(
                      color: AppColors.primaryMint,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
            ],
          ),
        ),
        TextButton(
          onPressed: () => context.push(
            '/treatment-detail?id=${Uri.encodeComponent(treatment.id)}',
          ),
          child: const Text('View'),
        ),
      ],
    ),
  );
}

Widget _doctorResultCard(BuildContext context, Doctor doctor) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: panelDecoration(),
    child: Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.primaryMintLight,
          child: Text(
            doctor.name.replaceAll('Dr. ', '').substring(0, 1),
            style: const TextStyle(
                color: AppColors.primaryMint, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(doctor.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: titleStyle()),
              const SizedBox(height: 4),
              Text('${doctor.specialty} - ${doctor.clinic}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(color: AppColors.textGrey, fontSize: 12)),
            ],
          ),
        ),
        TextButton(
          onPressed: () => context.push(
            '/doctor-profile?id=${Uri.encodeComponent(doctor.id)}',
          ),
          child: const Text('View'),
        ),
      ],
    ),
  );
}
