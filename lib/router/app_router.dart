import 'package:go_router/go_router.dart';
import '../features/home/home_screen.dart';
import '../features/treatment_detail/treatment_detail_screen.dart';
import '../features/detail/clinic_detail_screen.dart';
import '../features/doctor_profile/doctor_profile_screen.dart';
import '../features/app_flows/app_flow_screens.dart';

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
        builder: (context, state) => const TreatmentDetailScreen(),
      ),
      GoRoute(
        path: '/clinic-detail',
        builder: (context, state) => const ClinicDetailScreen(),
      ),
      GoRoute(
        path: '/doctor-profile',
        builder: (context, state) => const DoctorProfileScreen(),
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
