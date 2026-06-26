import 'package:go_router/go_router.dart';
import '../../features/booking/booking_detail_screen.dart';
import '../../features/booking/booking_screen.dart';
import '../../features/booking/my_bookings_screen.dart';
import '../../features/chat/chat_screen.dart';
import '../../features/clinic_detail/clinic_detail_screen.dart';
import '../../features/clinic_staff/clinic_staff_screen.dart';
import '../../features/doctor_profile/doctor_profile_screen.dart';
import '../../features/favorites/favorites_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/map/map_screen.dart';
import '../../features/promo/promo_screen.dart';
import '../../features/reviews/reviews_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/skin_profile/skin_profile_screen.dart';
import '../../features/treatment_detail/treatment_detail_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/treatment-detail',
        builder: (context, state) => TreatmentDetailScreen(
          treatmentId: state.uri.queryParameters['id'],
        ),
      ),
      GoRoute(
        path: '/clinic-detail',
        builder: (context, state) => ClinicDetailScreen(
          clinicId: state.uri.queryParameters['id'],
        ),
      ),
      GoRoute(
        path: '/doctor-profile',
        builder: (context, state) => DoctorProfileScreen(
          doctorId: state.uri.queryParameters['id'],
        ),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/map',
        builder: (context, state) => const MapScreen(),
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/promo',
        builder: (context, state) => const PromoScreen(),
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(
        path: '/booking',
        builder: (context, state) => BookingScreen(
          clinicId: state.uri.queryParameters['clinicId'],
          treatmentId: state.uri.queryParameters['treatmentId'],
          doctorId: state.uri.queryParameters['doctorId'],
        ),
      ),
      GoRoute(
        path: '/my-bookings',
        builder: (context, state) => const MyBookingsScreen(),
      ),
      GoRoute(
        path: '/booking-detail/:id',
        builder: (context, state) => BookingDetailScreen(
          bookingId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/clinic-staff',
        builder: (context, state) => const ClinicStaffScreen(),
      ),
      GoRoute(
        path: '/reviews',
        builder: (context, state) => const ReviewsScreen(),
      ),
      GoRoute(
        path: '/skin-profile',
        builder: (context, state) => const SkinProfileScreen(),
      ),
    ],
  );
}
