import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';

class DoctorProfileScreen extends StatefulWidget {
  final String? doctorId;

  const DoctorProfileScreen({super.key, this.doctorId});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  int _selectedDateIndex = 0;
  int _selectedTimeIndex = 3; // Default to 12:30 PM based on UI

  final List<Map<String, String>> _dates = [
    {'day': 'MON', 'date': '24'},
    {'day': 'TUE', 'date': '25'},
    {'day': 'WED', 'date': '26'},
    {'day': 'THU', 'date': '27'},
    {'day': 'FRI', 'date': '28'},
    {'day': 'SAT', 'date': '29'},
  ];

  final List<Map<String, dynamic>> _times = [
    {'time': '09:00 AM', 'available': true},
    {'time': '10:30 AM', 'available': true},
    {'time': '11:00 AM', 'available': false},
    {'time': '12:30 PM', 'available': true},
    {'time': '02:00 PM', 'available': true},
    {'time': '03:30 PM', 'available': true},
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final doctor = state.doctorById(widget.doctorId ?? '') ??
        (state.doctors.isNotEmpty ? state.doctors.first : null);
    final doctorId = doctor?.id ?? 'doctor_frances';
    final doctorName = doctor?.name ?? 'Dr. Frances';
    final specialty = doctor?.specialty ?? 'Dermatologist';
    final clinicName = doctor?.clinic ?? 'JongSart Clinic';
    final about = doctor?.about ??
        'Specialist in clinical skincare and gentle facial treatments.';
    final experience = doctor?.experience ?? 12;
    final rating = doctor?.rating.toStringAsFixed(1) ?? '4.9';
    final patients = doctor?.patients ?? 847;
    final initials = doctorName
        .replaceAll('Dr. ', '')
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => part[0])
        .take(2)
        .join()
        .toUpperCase();
    final isFavorite = state.isFavorite(doctorId);

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryMint),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Doctor Profile',
          style: TextStyle(
              color: AppColors.primaryMint,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: AppColors.primaryMint,
            ),
            onPressed: () => context.read<AppState>().toggleFavorite(doctorId),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.borderGrey, height: 1.0),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              // Avatar with verification tag
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: AppColors.primaryMint, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primaryMintLight,
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: AppColors.primaryMint,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryMint,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(Icons.verified,
                        color: Colors.white, size: 16),
                  )
                ],
              ),
              const SizedBox(height: 16),
              // Name and Specialty
              Text(
                doctorName,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryMint,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  specialty.toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1),
                ),
              ),
              const SizedBox(height: 8),
              // Localized Clinic Name
              Text(
                clinicName,
                style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 24),
              // Stats Block
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderGrey),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatColumn('$experience Yrs', 'EXPERIENCE'),
                      Container(
                          width: 1, height: 30, color: AppColors.borderGrey),
                      _buildStatColumn('$rating★', 'RATING'),
                      Container(
                          width: 1, height: 30, color: AppColors.borderGrey),
                      _buildStatColumn('$patients', 'PATIENTS'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Languages with clean localized Khmer badge
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildLanguageChip('ភាសាខ្មែរ'),
                    _buildLanguageChip('English'),
                    _buildLanguageChip('French'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // About Summary Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('About',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark)),
                    const SizedBox(height: 8),
                    Text(
                      about,
                      style: const TextStyle(
                          color: AppColors.textGrey, fontSize: 14, height: 1.5),
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      children: [
                        Text('Read More',
                            style: TextStyle(
                                color: AppColors.primaryMint,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                        Icon(Icons.keyboard_arrow_down,
                            color: AppColors.primaryMint, size: 16),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Available Slots Selector Header
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Available Slots',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark)),
                    ),
                    SizedBox(width: 12),
                    Text('June 2026',
                        style: TextStyle(
                            color: AppColors.textGrey,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Horizontal Calendar Picker
              SizedBox(
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _dates.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedDateIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedDateIndex = index),
                      child: Container(
                        width: 55,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryMint
                              : AppColors.borderGrey.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryMint
                                  : AppColors.borderGrey),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _dates[index]['day']!,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textGrey,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _dates[index]['date']!,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textDark,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Time Grid Chip Selector
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _times.length,
                  itemBuilder: (context, index) {
                    final time = _times[index];
                    final isSelected = _selectedTimeIndex == index;
                    final isAvailable = time['available'] as bool;

                    return GestureDetector(
                      onTap: isAvailable
                          ? () => setState(() => _selectedTimeIndex = index)
                          : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryMint
                              : isAvailable
                                  ? Colors.white
                                  : AppColors.borderGrey.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryMint
                                  : AppColors.borderGrey),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          time['time'] as String,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : isAvailable
                                    ? AppColors.textDark
                                    : AppColors.textGrey.withValues(alpha: 0.5),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              // Reviews Feed Block
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Reviews',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark)),
                    TextButton(
                      onPressed: () => context.push('/reviews'),
                      child: const Text('See All',
                          style: TextStyle(
                              color: AppColors.primaryMint,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    _buildReviewCard(
                        'SM',
                        'Sarah M.',
                        '2 days ago',
                        'Dr. Frances is amazing! My skin has never looked better. Highly professional.',
                        5,
                        Colors.blue.shade100),
                    const SizedBox(height: 12),
                    _buildReviewCard(
                        'JL',
                        'James L.',
                        '1 week ago',
                        'The clinic is beautiful and the treatment was very detailed. Very satisfied.',
                        4,
                        Colors.teal.shade200),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      // Sticky Bottom Booking Button Panel
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -5)),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Row(
            children: [
              const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CONSULTATION',
                      style: TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5)),
                  SizedBox(height: 2),
                  Text('\$120.00',
                      style: TextStyle(
                          color: AppColors.primaryMint,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F766E),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    onPressed: () => context.push(
                      '/booking?doctorId=${Uri.encodeComponent(doctorId)}',
                    ),
                    child: Text('Book with $doctorName',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: AppColors.primaryMint,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(
                color: AppColors.textGrey,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5)),
      ],
    );
  }

  Widget _buildLanguageChip(String language) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Text(language,
          style: const TextStyle(color: AppColors.textDark, fontSize: 12)),
    );
  }

  Widget _buildReviewCard(String initials, String name, String time,
      String content, int rating, Color avatarColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: avatarColor,
                child: Text(initials,
                    style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                            fontSize: 14)),
                    Row(
                      children: List.generate(
                          5,
                          (index) => Icon(
                                index < rating ? Icons.star : Icons.star_border,
                                color: AppColors.primaryMint,
                                size: 12,
                              )),
                    )
                  ],
                ),
              ),
              Text(time,
                  style:
                      const TextStyle(color: AppColors.textGrey, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '"$content"',
            style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 13,
                fontStyle: FontStyle.italic,
                height: 1.4),
          ),
        ],
      ),
    );
  }
}
