import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jong_sart/app.dart';
import 'package:jong_sart/models/booking.dart';
import 'package:jong_sart/core/router/app_router.dart';
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

    // App now boots on the splash screen; navigate to the customer home.
    AppRouter.router.go('/');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Search clinics, treatments, doctors...'), findsOneWidget);

    // Drain the splash branding timer so no timers stay pending.
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('main mobile screens render without layout errors',
      (WidgetTester tester) async {
    await pumpApp(tester);

    final routes = [
      '/role-selection',
      '/login',
      '/signup',
      '/staff-login',
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

    // Drain the splash branding timer so no timers stay pending.
    await tester.pump(const Duration(seconds: 2));
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

  test('customer can sign up, log out, and log back in', () async {
    final state = AppState();

    final signupError = await state.signUpCustomer(
      fullName: 'Dara Sok',
      phone: '012345678',
      email: 'dara@example.com',
      password: 'secret123',
    );

    expect(signupError, isNull);
    expect(state.isLoggedIn, isTrue);
    expect(state.isCustomer, isTrue);
    expect(state.userName, 'Dara Sok');

    await state.logout();
    expect(state.isLoggedIn, isFalse);
    expect(state.userRole, isNull);

    // Wrong password is rejected.
    final wrong = await state.loginCustomer(
      identifier: '012345678',
      password: 'nope',
    );
    expect(wrong, isNotNull);
    expect(state.isLoggedIn, isFalse);

    // Login by email works.
    final loginError = await state.loginCustomer(
      identifier: 'dara@example.com',
      password: 'secret123',
    );
    expect(loginError, isNull);
    expect(state.isCustomer, isTrue);
  });

  test('duplicate customer phone is rejected on sign up', () async {
    final state = AppState();

    final first = await state.signUpCustomer(
      fullName: 'First User',
      phone: '011111111',
      password: 'secret123',
    );
    expect(first, isNull);

    final duplicate = await state.signUpCustomer(
      fullName: 'Second User',
      phone: '011111111',
      password: 'another123',
    );
    expect(duplicate, isNotNull);
  });

  test('customer and clinic share one chat thread', () async {
    final state = AppState();
    final initialCount = state.chatMessages.length;

    // Customer message adds the message plus an auto acknowledgement.
    state.sendChatMessage('Is the facial okay for sensitive skin?');
    expect(state.chatMessages.length, initialCount + 2);
    expect(state.chatMessages.last.isMe, isFalse); // clinic auto-reply

    // Staff reply lands in the same thread as a clinic message.
    state.sendClinicReply('Yes, we start with a gentle consultation.');
    expect(state.chatMessages.last.isMe, isFalse);
    expect(state.chatMessages.last.text,
        'Yes, we start with a gentle consultation.');
  });

  test('staff login only accepts the mock staff account', () async {
    final state = AppState();

    final bad = await state.loginStaff(
      username: 'staff@jongsart.com',
      password: 'wrong',
    );
    expect(bad, isNotNull);
    expect(state.isLoggedIn, isFalse);

    final ok = await state.loginStaff(
      username: 'staff@jongsart.com',
      password: 'staff123',
    );
    expect(ok, isNull);
    expect(state.isStaff, isTrue);
    expect(state.isCustomer, isFalse);
  });

  test('demo customer can log in without signing up first', () async {
    final state = AppState();

    final error = await state.loginWithRole(
      identifier: 'pengseyha0000@gmail.com',
      password: '12345678',
    );

    expect(error, isNull);
    expect(state.isCustomer, isTrue);
    expect(state.userName, 'Seyha Peng');
    expect(state.email, 'pengseyha0000@gmail.com');
  });
}
