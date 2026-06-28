import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jong_sart/app.dart';
import 'package:jong_sart/models/booking.dart';
import 'package:jong_sart/models/clinic.dart';
import 'package:jong_sart/models/treatment_model.dart';
import 'package:jong_sart/core/router/app_router.dart';
import 'package:jong_sart/data/remote/booking_repository.dart';
import 'package:jong_sart/data/remote/catalog_repository.dart';
import 'package:jong_sart/state/app_state.dart';

/// Catalog repository that always fails, to simulate an offline backend.
class _FailingCatalogRepository extends CatalogRepository {
  @override
  Future<RemoteCatalog> fetchCatalog() async {
    throw const CatalogException('Backend offline (test).');
  }
}

/// Catalog repository that returns fixed backend data.
class _FakeCatalogRepository extends CatalogRepository {
  @override
  Future<RemoteCatalog> fetchCatalog() async {
    return RemoteCatalog(
      clinics: const [
        Clinic(
          id: 'c1',
          name: 'Backend Clinic',
          specialty: 'Consultation',
          address: 'BKK1, Phnom Penh',
          distance: '1 km',
          rating: 4.5,
          reviewCount: 0,
          tags: ['Dermatology'],
          isOpen: true,
        ),
      ],
      doctors: const [],
      treatments: [
        Treatment(
          id: 't1',
          title: 'Backend Treatment',
          category: 'Facial',
          price: r'$20',
          rating: '4.5',
          imageUrl: '',
          duration: '30 min',
        ),
      ],
      offers: const [],
    );
  }
}

/// Booking repository that always behaves like an offline backend.
class _FailingBookingRepository extends BookingRepository {
  @override
  Future<List<Booking>> getBackendBookings() async => const [];

  @override
  Future<Booking?> createBackendBooking(Booking booking) async => null;

  @override
  Future<Booking?> updateBackendBookingStatus(
    String id,
    String statusLabel,
  ) async =>
      null;
}

/// Booking repository that accepts create, but fails later status PATCH calls.
class _CreateThenFailStatusBookingRepository extends BookingRepository {
  @override
  Future<List<Booking>> getBackendBookings() async => const [];

  @override
  Future<Booking?> createBackendBooking(Booking booking) async {
    return Booking(
      id: 'backend_${booking.id}',
      patientName: booking.patientName,
      phone: booking.phone,
      telegramOrWhatsapp: booking.telegramOrWhatsapp,
      concern: booking.concern,
      treatmentId: booking.treatmentId,
      treatmentName: booking.treatmentName,
      clinicId: booking.clinicId,
      clinicName: booking.clinicName,
      doctorId: booking.doctorId,
      doctorName: booking.doctorName,
      date: booking.date,
      time: booking.time,
      note: booking.note,
      status: booking.status,
      createdAt: booking.createdAt,
    );
  }

  @override
  Future<Booking?> updateBackendBookingStatus(
    String id,
    String statusLabel,
  ) async =>
      null;
}

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
        create: (_) => AppState(autoLoadRemoteCatalog: false),
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
    final state = AppState(
      bookingRepository: _FailingBookingRepository(),
      autoLoadRemoteCatalog: false,
    );
    final booking = state.submitBookingRequest(
      patientName: 'Test Patient',
      phone: '012345678',
      concern: 'Acne & Breakouts',
      treatmentId: '1',
      treatmentName: 'Hydra Facial Care',
      clinicId: 'clinic_lumina',
      clinicName: 'JongSart Skin Clinic',
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

  test('booking can still be created when backend is unavailable', () async {
    final state = AppState(
      bookingRepository: _FailingBookingRepository(),
      autoLoadRemoteCatalog: false,
    );

    final booking = state.submitBookingRequest(
      patientName: 'Dara Sok',
      phone: '012345678',
      concern: 'Acne & Breakouts',
      treatmentId: '1',
      treatmentName: 'Hydra Facial Care',
      clinicId: 'clinic_lumina',
      clinicName: 'JongSart Skin Clinic',
      date: 'Mon 30',
      time: '09:00 AM',
      note: 'Sensitive skin',
    );

    expect(booking.status, BookingStatus.pending);
    expect(state.bookings, contains(booking));

    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(state.bookingSyncSource, 'local');
    expect(state.bookingSyncError, contains('saved locally'));
  });

  test('staff status update stays local if backend status sync fails',
      () async {
    final state = AppState(
      bookingRepository: _CreateThenFailStatusBookingRepository(),
      autoLoadRemoteCatalog: false,
    );

    final booking = state.submitBookingRequest(
      patientName: 'Dara Sok',
      phone: '012345678',
      concern: 'Acne & Breakouts',
      treatmentId: '1',
      treatmentName: 'Hydra Facial Care',
      clinicId: 'clinic_lumina',
      clinicName: 'JongSart Skin Clinic',
      date: 'Mon 30',
      time: '09:00 AM',
      note: 'Sensitive skin',
    );

    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    expect(state.bookingSyncSource, 'backend');

    state.staffConfirm(booking.id);
    expect(state.bookingById(booking.id)?.status, BookingStatus.confirmed);

    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(state.bookingById(booking.id)?.status, BookingStatus.confirmed);
    expect(state.bookingSyncError, contains('status update failed'));
  });

  test('customer can sign up, log out, and log back in', () async {
    final state = AppState(autoLoadRemoteCatalog: false);

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
    final state = AppState(autoLoadRemoteCatalog: false);

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
    final state = AppState(autoLoadRemoteCatalog: false);
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
    final state = AppState(autoLoadRemoteCatalog: false);

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
    final state = AppState(autoLoadRemoteCatalog: false);

    final error = await state.loginWithRole(
      identifier: 'pengseyha0000@gmail.com',
      password: '12345678',
    );

    expect(error, isNull);
    expect(state.isCustomer, isTrue);
    expect(state.userName, 'Seyha Peng');
    expect(state.email, 'pengseyha0000@gmail.com');
  });

  test('catalog falls back to local data when backend is unavailable',
      () async {
    final state = AppState(
      catalogRepository: _FailingCatalogRepository(),
      autoLoadRemoteCatalog: false,
    );

    // Local data is present before any backend attempt.
    expect(state.clinics, isNotEmpty);
    expect(state.catalogSource, 'local');

    // A failed backend load must not crash and must keep local data.
    await state.refreshCatalog();

    expect(state.catalogSource, 'local');
    expect(state.isUsingBackendCatalog, isFalse);
    expect(state.clinics.first.name, 'JongSart Skin Clinic');
    expect(state.catalogError, isNotNull);
  });

  test('catalog uses backend data when available', () async {
    final state = AppState(
      catalogRepository: _FakeCatalogRepository(),
      autoLoadRemoteCatalog: false,
    );

    await state.refreshCatalog();

    expect(state.catalogSource, 'backend');
    expect(state.isUsingBackendCatalog, isTrue);
    expect(state.clinics.first.name, 'Backend Clinic');
    expect(state.treatments.first.title, 'Backend Treatment');
  });
}
