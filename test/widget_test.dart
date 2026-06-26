import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jong_sart/main.dart';
import 'package:jong_sart/models/booking.dart';
import 'package:jong_sart/router/app_router.dart';
import 'package:jong_sart/state/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // No backend - persistence is local. Use empty mock storage in tests.
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const JongSartApp(),
      ),
    );
  }

  testWidgets('renders the home screen', (WidgetTester tester) async {
    await pumpApp(tester);

    expect(find.text('JongSart'), findsOneWidget);
    expect(find.text('Search clinics, treatments, doctors...'), findsOneWidget);
  });

  testWidgets('main mobile screens render without layout errors',
      (WidgetTester tester) async {
    await pumpApp(tester);

    final routes = [
      '/',
      '/search',
      '/map',
      '/favorites',
      '/promo',
      '/chat',
      '/booking',
      '/my-bookings',
      '/booking-detail/missing_id',
      '/clinic-staff',
      '/reviews',
      '/skin-profile',
      '/clinic-detail',
      '/doctor-profile',
      '/treatment-detail',
    ];

    for (final route in routes) {
      AppRouter.router.go(route);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull, reason: route);
    }
  });

  test('a submitted booking request starts as pending', () {
    final state = AppState();
    final booking = state.submitBookingRequest(
      patientName: 'Test Patient',
      phone: '012345678',
      concern: 'Acne & Breakouts',
      treatmentId: '1',
      treatmentName: 'Hydra-Laser Revive',
      clinicId: 'clinic_lumina',
      clinicName: 'Lumina Skin Institute',
      date: 'Mon 30',
      time: '09:00 AM',
      note: '',
    );

    expect(booking.status, BookingStatus.pending);
    expect(state.bookings.length, 1);

    state.staffConfirm(booking.id);
    expect(state.bookingById(booking.id)?.status, BookingStatus.confirmed);

    state.staffComplete(booking.id);
    expect(state.bookingById(booking.id)?.status, BookingStatus.completed);
  });
}
