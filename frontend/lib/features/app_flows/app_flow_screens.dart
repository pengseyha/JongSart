import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/booking.dart';
import '../../models/clinic.dart';
import '../../models/doctor.dart';
import '../../models/offer.dart';
import '../../models/patient_review.dart';
import '../../models/skin_recommendation.dart';
import '../../models/treatment_model.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_bottom_nav.dart';

part '../search/search_screen.dart';
part '../map/map_screen.dart';
part '../favorites/favorites_screen.dart';
part '../promo/promo_screen.dart';
part '../chat/chat_screen.dart';
part '../booking/booking_screen.dart';
part '../bookings/my_bookings_screen.dart';
part '../bookings/booking_detail_screen.dart';
part '../staff/clinic_staff_screen.dart';
part '../reviews/reviews_screen.dart';
part '../skin_profile/skin_profile_screen.dart';

/// Coloured badge for a booking status, reused across booking screens.
Widget _statusBadge(BookingStatus status) {
  late final Color background;
  late final Color foreground;
  switch (status) {
    case BookingStatus.pending:
      background = const Color(0xFFFFF3DA);
      foreground = const Color(0xFFB7791F);
      break;
    case BookingStatus.confirmed:
      background = AppColors.primaryMintLight;
      foreground = AppColors.primaryMint;
      break;
    case BookingStatus.rescheduled:
      background = const Color(0xFFE6EEFF);
      foreground = const Color(0xFF2563EB);
      break;
    case BookingStatus.cancelled:
      background = const Color(0xFFFFE7EA);
      foreground = const Color(0xFFD4465D);
      break;
    case BookingStatus.completed:
      background = const Color(0xFFE7F4EC);
      foreground = const Color(0xFF15803D);
      break;
  }
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      status.badgeLabel,
      style: TextStyle(
        color: foreground,
        fontSize: 10,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

String _formatDate(DateTime date) =>
    DateFormat('d MMM yyyy, h:mm a').format(date);

PreferredSizeWidget _flowAppBar(BuildContext context, String title) {
  final canPop = Navigator.of(context).canPop();
  return AppBar(
    backgroundColor: AppColors.backgroundWhite,
    elevation: 0,
    centerTitle: false,
    leading: canPop
        ? IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, color: Color(0xFF007D68)),
          )
        : null,
    title: Text(
      title,
      style: const TextStyle(
        color: Color(0xFF007D68),
        fontSize: 13,
        fontWeight: FontWeight.w800,
      ),
    ),
    actions: [
      IconButton(
        onPressed: () => context.push('/chat'),
        icon: const Icon(Icons.notifications_none, color: Color(0xFF173A35)),
      ),
    ],
    bottom: const PreferredSize(
      preferredSize: Size.fromHeight(1),
      child: Divider(height: 1, color: AppColors.borderGrey),
    ),
  );
}

Widget _editableSearchField(String hint,
    {required ValueChanged<String> onChanged}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.borderGrey),
    ),
    child: TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 13),
        prefixIcon: const Icon(Icons.search, color: AppColors.textGrey),
        suffixIcon: const Icon(Icons.tune, color: AppColors.primaryMint),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),
  );
}

Widget _messageInput(
  TextEditingController controller, {
  required ValueChanged<String> onSubmitted,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.borderGrey),
    ),
    child: TextField(
      controller: controller,
      onSubmitted: onSubmitted,
      decoration: const InputDecoration(
        hintText: 'Type your message...',
        hintStyle: TextStyle(color: AppColors.textGrey, fontSize: 13),
        prefixIcon: Icon(Icons.chat_bubble_outline, color: AppColors.textGrey),
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(vertical: 14),
      ),
    ),
  );
}

Widget _filterPanel() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: _panelDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Expanded(
              child: Text(
                'Radius Distance',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
            Text(
              '8km',
              style: TextStyle(
                color: Color(0xFF007D68),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const LinearProgressIndicator(
          value: 0.42,
          minHeight: 5,
          color: Color(0xFF3FCDB5),
          backgroundColor: Color(0xFFD6E4E0),
        ),
        const SizedBox(height: 4),
        const Row(
          children: [
            Text('1km',
                style: TextStyle(color: AppColors.textGrey, fontSize: 9)),
            Spacer(),
            Text('20km',
                style: TextStyle(color: AppColors.textGrey, fontSize: 9)),
          ],
        ),
        const SizedBox(height: 14),
        const Text(
          'Specialties',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 7,
          runSpacing: 8,
          children: [
            _choicePill('Dermatology', true),
            _choicePill('Cosmetic', false),
            _choicePill('Surgical', false),
            _choicePill('Laser', false),
            _choicePill('Pediatric', false),
          ],
        ),
      ],
    ),
  );
}

Widget _clinicResultCard(BuildContext context, Clinic clinic) {
  final state = context.watch<AppState>();
  final isFavorite = state.isFavorite(clinic.id);

  return Container(
    margin: const EdgeInsets.only(bottom: 14),
    decoration: _panelDecoration(),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _clinicImageTile(clinic.id),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clinic.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _titleStyle(),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '★ ${clinic.rating} (${clinic.reviewCount} reviews)',
                      style: const TextStyle(
                        color: Color(0xFF007D68),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: clinic.tags.take(2).map(_smallPill).toList(),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () =>
                    context.read<AppState>().toggleFavorite(clinic.id),
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: const Color(0xFF007D68),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: AppColors.borderGrey),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${clinic.distance} away',
                  style:
                      const TextStyle(color: AppColors.textGrey, fontSize: 11),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007D68),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => context.push(
                  '/clinic-detail?id=${Uri.encodeComponent(clinic.id)}',
                ),
                child: const Text('View Clinic'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _clinicImageTile(String id) {
  final image = id.contains('emerald')
      ? 'https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&w=300&q=80'
      : id.contains('north')
          ? 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&w=300&q=80'
          : 'https://images.unsplash.com/photo-1588776814546-1ffcf47267a5?auto=format&fit=crop&w=300&q=80';
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Image.network(
      image,
      width: 72,
      height: 72,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          _imageTile(Icons.local_hospital),
    ),
  );
}

Widget _choicePill(String label, bool selected) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: selected ? const Color(0xFF007D68) : Colors.white,
      borderRadius: BorderRadius.circular(999),
      border: Border.all(
          color: selected ? const Color(0xFF007D68) : AppColors.borderGrey),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: selected ? Colors.white : AppColors.textDark,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

Widget _mapClinicPreview(BuildContext context, Clinic clinic) {
  return Container(
    width: 260,
    margin: const EdgeInsets.only(right: 12),
    decoration: _panelDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
          child: Image.network(
            'https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&w=500&q=80',
            height: 82,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 82,
              color: AppColors.primaryMintLight,
              child: const Icon(Icons.local_hospital,
                  color: AppColors.primaryMint),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(clinic.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _titleStyle()),
              const SizedBox(height: 3),
              Text('${clinic.distance} away - Open until 7PM',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(color: AppColors.textGrey, fontSize: 11)),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 36,
                child: ElevatedButton(
                  onPressed: () => context.push('/booking'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007D68),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Book Consultation'),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _mapBottomSheet(BuildContext context) {
  final clinics = context.watch<AppState>().clinics;
  return Container(
    padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFFB5CCC7),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Clinics nearby (12)',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ),
            TextButton(
              onPressed: () => context.go('/search'),
              child: const Text('View List'),
            ),
          ],
        ),
        SizedBox(
          height: 205,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: clinics
                .map((clinic) => _mapClinicPreview(context, clinic))
                .toList(),
          ),
        ),
      ],
    ),
  );
}

Widget _emptyState(IconData icon, String title, String body) {
  return Container(
    padding: const EdgeInsets.all(22),
    decoration: _panelDecoration(),
    child: Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.primaryMintLight,
          child: Icon(icon, color: AppColors.primaryMint),
        ),
        const SizedBox(height: 12),
        Text(title, style: _titleStyle()),
        const SizedBox(height: 6),
        Text(
          body,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
        ),
      ],
    ),
  );
}

Widget _mockMap() {
  return Container(
    color: const Color(0xFFF3F8F6),
    child: Stack(
      children: [
        Positioned(
          left: -30,
          top: 80,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 26),
              borderRadius: BorderRadius.circular(180),
            ),
          ),
        ),
        Positioned(
          right: -70,
          top: 160,
          child: Container(
            width: 300,
            height: 160,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 22),
              borderRadius: BorderRadius.circular(120),
            ),
          ),
        ),
        const Positioned(left: 120, top: 190, child: _MapPin(label: 'Y')),
        const Positioned(right: 94, top: 280, child: _MapPin(label: 'H')),
        Positioned(
          left: 80,
          right: 80,
          top: 230,
          child: Container(height: 4, color: AppColors.primaryMint),
        ),
      ],
    ),
  );
}

Widget _favoriteClinicCard(BuildContext context, Clinic clinic) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: _panelDecoration(),
    child: Row(
      children: [
        _clinicImageTile(clinic.id),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                clinic.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _titleStyle(),
              ),
              const SizedBox(height: 4),
              Text(clinic.specialty,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(color: AppColors.textGrey, fontSize: 12)),
              const SizedBox(height: 7),
              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: clinic.tags.take(2).map(_smallPill).toList(),
              ),
              const SizedBox(height: 7),
              Text('${clinic.distance} km',
                  style:
                      const TextStyle(color: AppColors.textGrey, fontSize: 11)),
            ],
          ),
        ),
        Column(
          children: [
            IconButton(
              onPressed: () =>
                  context.read<AppState>().toggleFavorite(clinic.id),
              icon: const Icon(Icons.favorite, color: Color(0xFF007D68)),
            ),
            TextButton(
              onPressed: () => context.push(
                '/clinic-detail?id=${Uri.encodeComponent(clinic.id)}',
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                minimumSize: const Size(48, 30),
              ),
              child: const Text(
                'View Profile',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _tabLabel(String label, bool selected) {
  return Container(
    padding: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: selected ? const Color(0xFF007D68) : AppColors.borderGrey,
          width: selected ? 2 : 1,
        ),
      ),
    ),
    alignment: Alignment.center,
    child: Text(
      label.toUpperCase(),
      style: TextStyle(
        color: selected ? const Color(0xFF007D68) : AppColors.textGrey,
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.1,
      ),
    ),
  );
}

Widget _favoriteRecommendationCard(
  BuildContext context,
  SkinRecommendation recommendation,
) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: _panelDecoration(),
    child: Row(
      children: [
        _imageTile(Icons.spa_outlined),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                recommendation.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _titleStyle(),
              ),
              const SizedBox(height: 4),
              Text(recommendation.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(color: AppColors.textGrey, fontSize: 12)),
              const SizedBox(height: 6),
              Text('${recommendation.match} - ${recommendation.price}',
                  style: const TextStyle(
                      color: AppColors.primaryMint,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
            ],
          ),
        ),
        TextButton(
          onPressed: () => context.push('/booking'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: const Size(48, 36),
          ),
          child: const Text('Book'),
        ),
        IconButton(
          onPressed: () =>
              context.read<AppState>().toggleFavorite(recommendation.id),
          icon: const Icon(Icons.favorite, color: Colors.redAccent),
        ),
      ],
    ),
  );
}

Widget _flashDeal(BuildContext context, Offer offer) {
  return Container(
    height: 170,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      gradient: const LinearGradient(
        colors: [Color(0xFFBFEFE4), Color(0xFF0F766E)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            Colors.black.withValues(alpha: 0.45),
            Colors.black.withValues(alpha: 0.08),
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _smallPill(offer.badge),
          const Spacer(),
          Text(offer.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700)),
          Text(offer.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 12)),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: offer.isClaimed
                  ? () => context.push('/booking')
                  : () => context.read<AppState>().claimOffer(offer.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007D68),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(offer.isClaimed ? 'Book' : 'Claim'),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _bundleCard(BuildContext context, Offer offer) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(12),
    decoration: _panelDecoration(),
    child: Row(
      children: [
        _clinicImageTile(offer.id),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(offer.title, style: _titleStyle()),
              Text(offer.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(color: AppColors.textGrey, fontSize: 12)),
              const SizedBox(height: 4),
              Text(offer.price,
                  style: const TextStyle(
                      color: Color(0xFF007D68), fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        IconButton(
          onPressed: () => context.read<AppState>().claimOffer(offer.id),
          icon: Icon(
            offer.isClaimed ? Icons.check_circle : Icons.add_circle_outline,
            color: const Color(0xFF007D68),
          ),
        ),
      ],
    ),
  );
}

Widget _couponCard() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFF3FCDB5)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Expanded(
              child: Text('\$20 OFF',
                  style: TextStyle(fontWeight: FontWeight.w800)),
            ),
            Text('EXPIRES OCT 31',
                style: TextStyle(
                    color: Color(0xFFD4465D),
                    fontSize: 10,
                    fontWeight: FontWeight.w800)),
          ],
        ),
        const SizedBox(height: 4),
        const Text('First-time Consultation',
            style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F5F3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Expanded(
                child: Text('DERMA-NEW-20',
                    style:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
              ),
              Icon(Icons.copy, size: 14, color: Color(0xFF007D68)),
              SizedBox(width: 4),
              Text('Copy',
                  style: TextStyle(color: Color(0xFF007D68), fontSize: 10)),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _giftWellnessCard(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFFDDF9F3),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.card_giftcard, color: Color(0xFF007D68)),
            Spacer(),
            Text('DIGITAL VOUCHER',
                style: TextStyle(
                    color: Color(0xFF007D68),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1)),
          ],
        ),
        const SizedBox(height: 18),
        const Text('Select Denomination',
            style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: [
            _choicePill('\$50', false),
            _choicePill('\$100', true),
            _choicePill('\$250', false),
            _choicePill('\$500', false),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Gift voucher prepared.')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF123447),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Send as Gift'),
          ),
        ),
      ],
    ),
  );
}

Widget _timeChip(String time, bool selected, {required VoidCallback onTap}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: selected ? AppColors.primaryMint : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: selected ? AppColors.primaryMint : AppColors.borderGrey),
      ),
      child: Text(
        time,
        style: TextStyle(
          color: selected ? Colors.white : AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

Widget _summaryRow(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Icon(icon, color: AppColors.primaryMint, size: 18),
        const SizedBox(width: 8),
        Text('$label: ',
            style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _ratingSummary(AppState state) {
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: _panelDecoration(),
    child: Column(
      children: [
        Text(state.averageReviewRating.toStringAsFixed(1),
            style: const TextStyle(
                fontSize: 20,
                color: Color(0xFF007D68),
                fontWeight: FontWeight.bold)),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                5,
                (_) => const Icon(Icons.star,
                    color: Color(0xFF3FCDB5), size: 18))),
        const Text(
          '1,240 Reviews',
          style: TextStyle(color: AppColors.textGrey, fontSize: 10),
        ),
        const SizedBox(height: 16),
        _ratingBar('Cleanliness', 0.97),
        _ratingBar('Staff Expertise', 0.95),
        _ratingBar('Treatment Results', 0.92),
      ],
    ),
  );
}

Widget _ratingBar(String label, double value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        SizedBox(
            width: 132,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700))),
        Expanded(
          child: LinearProgressIndicator(
            value: value,
            minHeight: 6,
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFF007D68),
            backgroundColor: AppColors.borderGrey,
          ),
        ),
      ],
    ),
  );
}

Widget _reviewCard(PatientReview review) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: _panelDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
                backgroundColor: AppColors.primaryMintLight,
                child: Text(review.name.substring(0, 1),
                    style: const TextStyle(color: Color(0xFF007D68)))),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(review.name, style: _titleStyle()),
                  Text('SEP ${review.id.length + 10}, 2023',
                      style: const TextStyle(
                          color: AppColors.textGrey, fontSize: 9)),
                ],
              ),
            ),
            Row(
              children: List.generate(
                5,
                (_) =>
                    const Icon(Icons.star, color: Color(0xFF3FCDB5), size: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _smallPill(review.label.toUpperCase()),
        const SizedBox(height: 12),
        Text(review.body,
            style: const TextStyle(
                color: AppColors.textGrey, fontSize: 13, height: 1.45)),
      ],
    ),
  );
}

Widget _skinScoreCard(AppState state) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: _panelDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Expanded(
              child: Text(
                'Combination-Oily',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                '42% Low hydration',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: AppColors.primaryMint, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _smallPill('Congested Pores'),
            _smallPill('Uneven Texture'),
            _smallPill('Sensitivity'),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.primaryMint,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            state.skinProfileSummary,
            style: const TextStyle(
                color: Colors.white, fontSize: 13, height: 1.45),
          ),
        ),
      ],
    ),
  );
}

Widget _recommendationCard(
  BuildContext context,
  SkinRecommendation recommendation,
) {
  final isFavorite = context.watch<AppState>().isFavorite(recommendation.id);

  return Container(
    margin: const EdgeInsets.only(bottom: 14),
    decoration: _panelDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 130,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            gradient:
                LinearGradient(colors: [Color(0xFFCFEFE7), Color(0xFF7BC5A8)]),
          ),
          child: Center(
              child: Icon(Icons.spa_outlined,
                  color: Colors.white.withValues(alpha: 0.85), size: 54)),
        ),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(recommendation.title, style: _titleStyle())),
                  _smallPill(recommendation.match),
                ],
              ),
              const SizedBox(height: 8),
              Text(recommendation.description,
                  style: const TextStyle(
                      color: AppColors.textGrey, fontSize: 13, height: 1.4)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.push('/booking'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F766E),
                          foregroundColor: Colors.white),
                      child: Text('Book ${recommendation.price}'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    onPressed: () => context
                        .read<AppState>()
                        .toggleFavorite(recommendation.id),
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.redAccent : AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _sectionTitle(String title) {
  return Text(
    title,
    style: const TextStyle(
      color: AppColors.textDark,
      fontSize: 17,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget _imageTile(IconData icon) {
  return Container(
    width: 64,
    height: 64,
    decoration: BoxDecoration(
      color: AppColors.primaryMintLight,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Icon(icon, color: AppColors.primaryMint, size: 30),
  );
}

Widget _smallPill(String label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: AppColors.primaryMintLight,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      label,
      style: const TextStyle(
        color: AppColors.primaryMint,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

TextStyle _titleStyle() {
  return const TextStyle(
    color: AppColors.textDark,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
}

BoxDecoration _panelDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: AppColors.borderGrey),
  );
}

class _MapPin extends StatelessWidget {
  final String label;

  const _MapPin({required this.label});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: AppColors.primaryMint,
      child: Text(label,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;

  const _ChatBubble({required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.72,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primaryMint : AppColors.primaryMintLight,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isMe ? Colors.white : AppColors.textDark,
            fontSize: 13,
            height: 1.45,
          ),
        ),
      ),
    );
  }
}
