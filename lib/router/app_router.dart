import 'package:go_router/go_router.dart';
import '../features/home/home_screen.dart';
import '../features/treatment_detail/treatment_detail_screen.dart';
import '../features/detail/clinic_detail_screen.dart';
import '../features/doctor_profile/doctor_profile_screen.dart';

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
    ],
  );
}
