import 'dart:async';

import 'package:flutter/material.dart';
import '../core/storage/local_storage_service.dart';
import '../data/mock/mock_repository.dart';
import '../data/remote/catalog_repository.dart';
import '../models/booking.dart';
import '../models/chat_message.dart';
import '../models/clinic.dart';
import '../models/doctor.dart';
import '../models/offer.dart';
import '../models/patient_review.dart';
import '../models/skin_recommendation.dart';
import '../models/treatment_model.dart';

class AppState extends ChangeNotifier {
  final MockRepository _repository = MockRepository();
  final LocalStorageService _store = LocalStorageService();
  final CatalogRepository _catalogRepository;

  /// When true, the app tries to load the read-only catalog from the backend
  /// during bootstrap. Disabled in tests for determinism.
  final bool _autoLoadRemoteCatalog;

  List<Treatment> _treatments = [];
  bool _isLoading = true;

  // --- Read-only backend catalog state ----------------------------------
  bool _isCatalogLoading = false;
  // 'local' = using bundled/mock data, 'backend' = loaded from NestJS API.
  String _catalogSource = 'local';
  String? _catalogError;
  bool _disposed = false;

  // --- Auth state (local only, no backend) ------------------------------
  bool _authLoaded = false;
  bool _isLoggedIn = false;
  String? _userRole; // 'customer' or 'staff'
  String _userName = '';
  String _phone = '';
  String? _email;

  // Mock staff account (no public staff registration).
  static const String _staffUsername = 'staff@jongsart.com';
  static const String _staffPassword = 'staff123';

  // Demo customer account for presentation login without signing up again.
  static const Map<String, String> _demoCustomerAccount = {
    'name': 'Seyha Peng',
    'phone': '010000000',
    'email': 'pengseyha0000@gmail.com',
    'password': '12345678',
  };

  Set<String> _favoriteIds = {'clinic_lumina', 'treatment_hydra'};
  Set<String> _claimedOfferIds = {};
  List<Booking> _bookings = [];

  List<ChatMessage> _chatMessages = [
    ChatMessage(
      id: 'm1',
      text:
          'Hello! Welcome to JongSart. I am Sophea, your clinic receptionist. How can I help you today?',
      isMe: false,
      sentAt: DateTime(2026, 6, 7, 9, 15),
    ),
    ChatMessage(
      id: 'm2',
      text:
          'Hi, I am interested in a facial treatment. Is it okay for sensitive skin?',
      isMe: true,
      sentAt: DateTime(2026, 6, 7, 9, 17),
    ),
    ChatMessage(
      id: 'm3',
      text:
          'Of course. We usually start with a short consultation to review your skin before recommending a treatment.',
      isMe: false,
      sentAt: DateTime(2026, 6, 7, 9, 18),
    ),
  ];

  String _selectedConcern = 'Acne & Breakouts';

  // Mutable so the read-only backend catalog can replace it when available.
  List<Clinic> _clinics = const [
    Clinic(
      id: 'clinic_lumina',
      name: 'JongSart Skin Clinic',
      specialty: 'Dermatology consultation and clinical facials',
      address: 'BKK1, Phnom Penh',
      distance: '0.9 km',
      rating: 4.9,
      reviewCount: 320,
      tags: ['Dermatology', 'Facial', 'Open'],
      isOpen: true,
    ),
    Clinic(
      id: 'clinic_emerald',
      name: 'Sovanna Aesthetic Clinic',
      specialty: 'Facial care and skin health consultation',
      address: 'Toul Kork, Phnom Penh',
      distance: '2.7 km',
      rating: 4.8,
      reviewCount: 215,
      tags: ['Acne Care', 'Hydra Facial'],
      isOpen: true,
    ),
    Clinic(
      id: 'clinic_north_peak',
      name: 'Mekong Dermatology Center',
      specialty: 'Pigmentation care and scar care consultation',
      address: 'Sen Sok, Phnom Penh',
      distance: '4.8 km',
      rating: 4.7,
      reviewCount: 168,
      tags: ['Pigmentation', 'Scar Care'],
      isOpen: false,
    ),
  ];

  List<Doctor> _doctors = const [
    Doctor(
      id: 'doctor_frances',
      name: 'Dr. Sok Vicheka',
      specialty: 'Dermatology Consultation',
      experience: 12,
      rating: 4.9,
      patients: 840,
      clinic: 'JongSart Skin Clinic',
      about:
          'Provides skin health consultation and gentle facial care. May help customers understand suitable care options. Clinic staff will confirm suitability before any treatment.',
      imageUrl: '',
    ),
    Doctor(
      id: 'doctor_sarah',
      name: 'Dr. Lim Rachana',
      specialty: 'Laser & Pigmentation Care',
      experience: 9,
      rating: 4.8,
      patients: 530,
      clinic: 'JongSart Skin Clinic',
      about:
          'Focuses on pigmentation care and scar care consultation. Each visit starts with a short consultation to recommend a suitable care option.',
      imageUrl: '',
    ),
    Doctor(
      id: 'doctor_lina',
      name: 'Dr. Chan Sopheak',
      specialty: 'Acne & Sensitive Skin Care',
      experience: 7,
      rating: 4.8,
      patients: 410,
      clinic: 'Sovanna Aesthetic Clinic',
      about:
          'Supports acne and sensitive skin care with a gentle approach. Clinic staff will check the skin condition first before recommending care.',
      imageUrl: '',
    ),
  ];

  List<Offer> _offers = const [
    Offer(
      id: 'offer_flash_facial',
      title: 'First Visit Consultation Discount',
      subtitle: 'For new customers booking through JongSart',
      price: '\$12',
      badge: 'New',
    ),
    Offer(
      id: 'offer_radiance_trio',
      title: 'Weekend Facial Offer',
      subtitle: 'Deep cleansing facial care on weekends',
      price: '\$30',
      badge: 'Weekend',
    ),
    Offer(
      id: 'offer_age_reverse',
      title: 'Student Skin Care Package',
      subtitle: 'Consultation and basic facial for students',
      price: '\$20',
      badge: 'Student',
    ),
  ];

  List<PatientReview> _reviews = const [
    PatientReview(
      id: 'review_elena',
      name: 'Sreyneang',
      label: 'Deep Cleansing Facial',
      body:
          'The staff explained the facial process clearly and the clinic was clean. Booking through the app was simple.',
      rating: 5.0,
    ),
    PatientReview(
      id: 'review_julien',
      name: 'Dara',
      label: 'Acne Consultation',
      body:
          'I liked that the appointment was pending first, then staff contacted me to confirm the time.',
      rating: 4.8,
    ),
    PatientReview(
      id: 'review_sarah',
      name: 'Pisey',
      label: 'Skin Consultation',
      body:
          'The consultation helped me understand which treatment was suitable for my skin concern.',
      rating: 4.9,
    ),
  ];

  final List<SkinRecommendation> _skinRecommendations = const [
    SkinRecommendation(
      id: 'treatment_hydra',
      title: 'Hydra Facial Care',
      match: '92% match',
      description:
          'A hydrating facial care option that may help dry or combination skin. Clinic staff will confirm suitability first.',
      price: '\$45',
    ),
    SkinRecommendation(
      id: 'treatment_blue_light',
      title: 'Acne Care Consultation',
      match: '89% match',
      description:
          'A recommended care option for acne and breakout-prone skin, starting with a short consultation.',
      price: '\$15',
    ),
    SkinRecommendation(
      id: 'treatment_lactic_peel',
      title: 'Brightening Facial Care',
      match: '85% match',
      description:
          'A gentle facial care option that may help with uneven or dull skin tone.',
      price: '\$40',
    ),
  ];

  // --- Getters ----------------------------------------------------------
  List<Treatment> get treatments => _treatments;
  bool get isLoading => _isLoading;

  // --- Auth getters -----------------------------------------------------
  bool get authLoaded => _authLoaded;
  bool get isLoggedIn => _isLoggedIn;
  String? get userRole => _userRole;
  bool get isCustomer => _userRole == 'customer';
  bool get isStaff => _userRole == 'staff';
  String get userName => _userName;
  String get phone => _phone;
  String? get email => _email;
  List<String> get favoriteIds => _favoriteIds.toList();
  List<Clinic> get clinics => List.unmodifiable(_clinics);
  List<Doctor> get doctors => List.unmodifiable(_doctors);
  List<Offer> get offers => _offers
      .map((offer) =>
          offer.copyWith(isClaimed: _claimedOfferIds.contains(offer.id)))
      .toList();
  List<Booking> get bookings => List.unmodifiable(_bookings);
  List<ChatMessage> get chatMessages => List.unmodifiable(_chatMessages);
  List<PatientReview> get reviews => List.unmodifiable(_reviews);
  List<SkinRecommendation> get skinRecommendations =>
      List.unmodifiable(_skinRecommendations);
  String get selectedConcern => _selectedConcern;
  int get claimedOfferCount => _claimedOfferIds.length;
  int get favoriteCount => _favoriteIds.length;
  double get averageReviewRating => _reviews.isEmpty
      ? 0
      : _reviews.fold<double>(0, (sum, review) => sum + review.rating) /
          _reviews.length;

  // --- Catalog (read-only backend) getters ------------------------------
  bool get isCatalogLoading => _isCatalogLoading;
  String get catalogSource => _catalogSource;
  bool get isUsingBackendCatalog => _catalogSource == 'backend';
  String? get catalogError => _catalogError;

  /// Friendly label for an optional "data source" indicator in the UI.
  String get catalogSourceLabel =>
      _catalogSource == 'backend' ? 'Backend API' : 'Local demo data';

  AppState({
    CatalogRepository? catalogRepository,
    bool autoLoadRemoteCatalog = true,
  })  : _catalogRepository = catalogRepository ?? CatalogRepository(),
        _autoLoadRemoteCatalog = autoLoadRemoteCatalog {
    _bootstrap();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  /// notifyListeners that is safe to call from async work after disposal.
  void _safeNotify() {
    if (!_disposed) notifyListeners();
  }

  Future<void> _bootstrap() async {
    _isLoading = true;
    notifyListeners();

    _treatments = await _repository.loadTreatments();

    // Restore persisted auth session (no backend).
    final savedAuth = await _store.loadAuth();
    if (savedAuth != null && savedAuth['isLoggedIn'] == true) {
      _isLoggedIn = true;
      _userRole = savedAuth['userRole'] as String?;
      _userName = (savedAuth['userName'] as String?) ?? '';
      _phone = (savedAuth['phone'] as String?) ?? '';
      _email = savedAuth['email'] as String?;
    }
    _authLoaded = true;

    // Restore persisted local state (no backend).
    final savedFavorites = await _store.loadFavorites();
    if (savedFavorites.isNotEmpty) _favoriteIds = savedFavorites;

    _claimedOfferIds = await _store.loadClaimedOffers();
    _bookings = await _store.loadBookings();

    final savedConcern = await _store.loadSkinConcern();
    if (savedConcern != null && savedConcern.isNotEmpty) {
      _selectedConcern = savedConcern;
    }

    final savedChat = await _store.loadChatMessages();
    if (savedChat != null && savedChat.isNotEmpty) _chatMessages = savedChat;

    final savedReviews = await _store.loadReviews();
    if (savedReviews != null && savedReviews.isNotEmpty) {
      _reviews = savedReviews;
    }

    _isLoading = false;
    notifyListeners();

    // Try the read-only backend catalog in the background. The app is already
    // usable with local data; this only upgrades to backend data if reachable.
    if (_autoLoadRemoteCatalog) {
      unawaited(_loadRemoteCatalog());
    }
  }

  // --- Read-only backend catalog ----------------------------------------
  /// Public entry point (e.g. for a future pull-to-refresh) to (re)load the
  /// catalog from the backend with automatic fallback to local data.
  Future<void> refreshCatalog() => _loadRemoteCatalog();

  /// Loads clinics, doctors, treatments, and offers from the backend. On ANY
  /// failure it keeps the existing local/mock data silently — the demo never
  /// breaks if the backend is offline or slow.
  Future<void> _loadRemoteCatalog() async {
    _isCatalogLoading = true;
    _safeNotify();
    try {
      final catalog = await _catalogRepository.fetchCatalog();
      _clinics = catalog.clinics;
      _doctors = catalog.doctors;
      _treatments = catalog.treatments;
      _offers = catalog.offers;
      _catalogSource = 'backend';
      _catalogError = null;
    } catch (e) {
      // Keep current local/mock data; just record why for optional debug.
      _catalogSource = 'local';
      _catalogError = e.toString();
    } finally {
      _isCatalogLoading = false;
      _safeNotify();
    }
  }

  // --- Auth -------------------------------------------------------------
  void _applySession({
    required String role,
    required String name,
    required String phone,
    String? email,
  }) {
    _isLoggedIn = true;
    _userRole = role;
    _userName = name;
    _phone = phone;
    _email = (email != null && email.trim().isEmpty) ? null : email?.trim();
  }

  Future<void> _persistSession() async {
    await _store.saveAuth({
      'isLoggedIn': _isLoggedIn,
      'userRole': _userRole,
      'userName': _userName,
      'phone': _phone,
      'email': _email,
    });
  }

  /// Registers a new customer locally and signs them in.
  /// Returns null on success, or an error message on failure.
  Future<String?> signUpCustomer({
    required String fullName,
    required String phone,
    String? email,
    required String password,
  }) async {
    final name = fullName.trim();
    final phoneNumber = phone.trim();
    final mail = email?.trim() ?? '';

    final accounts = await _loadAccountsWithDemoCustomer();
    final duplicate = accounts.any((account) =>
        account['phone'] == phoneNumber ||
        (mail.isNotEmpty && account['email'] == mail));
    if (duplicate) {
      return 'An account with this phone or email already exists.';
    }

    accounts.add({
      'name': name,
      'phone': phoneNumber,
      'email': mail,
      'password': password,
    });
    await _store.saveAccounts(accounts);

    _applySession(
        role: 'customer', name: name, phone: phoneNumber, email: mail);
    await _persistSession();
    notifyListeners();
    return null;
  }

  /// Logs in a previously registered customer by phone or email.
  /// Returns null on success, or an error message on failure.
  Future<String?> loginCustomer({
    required String identifier,
    required String password,
  }) async {
    final id = identifier.trim().toLowerCase();
    final accounts = await _loadAccountsWithDemoCustomer();

    Map<String, String>? match;
    for (final account in accounts) {
      final accountPhone = (account['phone'] ?? '').toLowerCase();
      final accountEmail = (account['email'] ?? '').toLowerCase();
      if ((accountPhone == id ||
              (accountEmail.isNotEmpty && accountEmail == id)) &&
          account['password'] == password) {
        match = account;
        break;
      }
    }

    if (match == null) {
      return 'Invalid phone/email or password.';
    }

    _applySession(
      role: 'customer',
      name: match['name'] ?? '',
      phone: match['phone'] ?? '',
      email: match['email'],
    );
    await _persistSession();
    notifyListeners();
    return null;
  }

  /// Single demo login entry point. Staff credentials open the staff dashboard;
  /// every other account is checked against local customer accounts.
  Future<String?> loginWithRole({
    required String identifier,
    required String password,
  }) async {
    final id = identifier.trim().toLowerCase();
    if (id == _staffUsername) {
      return loginStaff(username: identifier, password: password);
    }
    return loginCustomer(identifier: identifier, password: password);
  }

  Future<List<Map<String, String>>> _loadAccountsWithDemoCustomer() async {
    final accounts = await _store.loadAccounts();
    final hasDemoAccount = accounts.any((account) =>
        (account['email'] ?? '').toLowerCase() ==
        _demoCustomerAccount['email']);

    if (!hasDemoAccount) {
      accounts.add(Map<String, String>.from(_demoCustomerAccount));
      await _store.saveAccounts(accounts);
    }

    return accounts;
  }

  /// Logs in clinic staff against the mock staff account.
  /// Returns null on success, or an error message on failure.
  Future<String?> loginStaff({
    required String username,
    required String password,
  }) async {
    final user = username.trim().toLowerCase();
    if (user == _staffUsername && password == _staffPassword) {
      _applySession(
        role: 'staff',
        name: 'Clinic Staff',
        phone: '',
        email: _staffUsername,
      );
      await _persistSession();
      notifyListeners();
      return null;
    }
    return 'Invalid staff account. Please check your credentials.';
  }

  /// Clears the current session and persisted auth state.
  Future<void> logout() async {
    _isLoggedIn = false;
    _userRole = null;
    _userName = '';
    _phone = '';
    _email = null;
    await _store.clearAuth();
    notifyListeners();
  }

  // --- Favorites --------------------------------------------------------
  void toggleFavorite(String id) {
    if (!_favoriteIds.add(id)) {
      _favoriteIds.remove(id);
    }
    _store.saveFavorites(_favoriteIds);
    notifyListeners();
  }

  bool isFavorite(String id) => _favoriteIds.contains(id);

  List<Clinic> get favoriteClinics =>
      _clinics.where((clinic) => _favoriteIds.contains(clinic.id)).toList();

  List<SkinRecommendation> get favoriteRecommendations => _skinRecommendations
      .where((recommendation) => _favoriteIds.contains(recommendation.id))
      .toList();

  // --- Offers / promos --------------------------------------------------
  void claimOffer(String id) {
    _claimedOfferIds.add(id);
    _store.saveClaimedOffers(_claimedOfferIds);
    notifyListeners();
  }

  bool isOfferClaimed(String id) => _claimedOfferIds.contains(id);

  // --- Skin profile -----------------------------------------------------
  void selectConcern(String concern) {
    _selectedConcern = concern;
    _store.saveSkinConcern(concern);
    notifyListeners();
  }

  String get skinProfileSummary {
    if (_selectedConcern.contains('Acne')) {
      return 'Combination-oily profile with congestion risk and low hydration.';
    } else if (_selectedConcern.contains('Anti') ||
        _selectedConcern.contains('Aging')) {
      return 'Early aging markers with texture unevenness and barrier dryness.';
    } else if (_selectedConcern.contains('Dark') ||
        _selectedConcern.contains('Pigment')) {
      return 'Uneven tone with sun-related dark spots and dullness.';
    } else if (_selectedConcern.contains('Dry')) {
      return 'Dry, dehydrated profile that may benefit from barrier hydration.';
    } else {
      return 'Sensitive profile with mild dehydration and redness triggers.';
    }
  }

  // --- Search -----------------------------------------------------------
  List<Clinic> searchClinics(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return clinics;
    return _clinics.where((clinic) {
      return clinic.name.toLowerCase().contains(normalized) ||
          clinic.specialty.toLowerCase().contains(normalized) ||
          clinic.address.toLowerCase().contains(normalized) ||
          clinic.tags.any((tag) => tag.toLowerCase().contains(normalized));
    }).toList();
  }

  List<Treatment> searchTreatments(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return _treatments;
    return _treatments.where((treatment) {
      return treatment.title.toLowerCase().contains(normalized) ||
          treatment.category.toLowerCase().contains(normalized);
    }).toList();
  }

  List<Doctor> searchDoctors(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return doctors;
    return _doctors.where((doctor) {
      return doctor.name.toLowerCase().contains(normalized) ||
          doctor.specialty.toLowerCase().contains(normalized) ||
          doctor.clinic.toLowerCase().contains(normalized);
    }).toList();
  }

  Clinic? clinicById(String id) {
    for (final clinic in _clinics) {
      if (clinic.id == id) return clinic;
    }
    return null;
  }

  Treatment? treatmentById(String id) {
    for (final treatment in _treatments) {
      if (treatment.id == id) return treatment;
    }
    return null;
  }

  Doctor? doctorById(String id) {
    for (final doctor in _doctors) {
      if (doctor.id == id) return doctor;
    }
    return null;
  }

  // --- Chat -------------------------------------------------------------
  void sendChatMessage(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    _chatMessages.add(ChatMessage(
      id: 'm${DateTime.now().millisecondsSinceEpoch}',
      text: trimmed,
      isMe: true,
      sentAt: DateTime.now(),
    ));

    _chatMessages.add(ChatMessage(
      id: 'm${DateTime.now().millisecondsSinceEpoch + 1}',
      text: _autoReplyFor(trimmed),
      isMe: false,
      sentAt: DateTime.now(),
    ));
    _store.saveChatMessages(_chatMessages);
    notifyListeners();
  }

  /// Clinic staff reply in the shared clinic thread. Stored as a non-customer
  /// message (isMe == false) so it shows on the clinic side for customers and
  /// on the "mine" side when viewed by staff. No auto-reply is generated.
  void sendClinicReply(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    _chatMessages.add(ChatMessage(
      id: 'm${DateTime.now().millisecondsSinceEpoch}',
      text: trimmed,
      isMe: false,
      sentAt: DateTime.now(),
    ));
    _store.saveChatMessages(_chatMessages);
    notifyListeners();
  }

  String _autoReplyFor(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('phone') || lower.contains('number')) {
      return 'Please make sure your phone number is correct so we can reach you.';
    }
    if (lower.contains('urgent') || lower.contains('call')) {
      return 'For urgent booking, please call the clinic directly during opening hours.';
    }
    return 'Thank you for your message. Our staff will check and reply to you soon.';
  }

  /// Adds the automatic clinic notice shown right after a booking request.
  void addBookingChatNotice() {
    _chatMessages.add(ChatMessage(
      id: 'm${DateTime.now().millisecondsSinceEpoch}',
      text:
          'Thank you. Your appointment request is pending confirmation. Our clinic staff will contact you soon.',
      isMe: false,
      sentAt: DateTime.now(),
    ));
    _store.saveChatMessages(_chatMessages);
    notifyListeners();
  }

  // --- Reviews ----------------------------------------------------------
  void addReview(PatientReview review) {
    _reviews = [review, ..._reviews];
    _store.saveReviews(_reviews);
    notifyListeners();
  }

  // --- Bookings ---------------------------------------------------------
  Booking? bookingById(String id) {
    for (final booking in _bookings) {
      if (booking.id == id) return booking;
    }
    return null;
  }

  List<Booking> bookingsByStatus(BookingStatus status) =>
      _bookings.where((booking) => booking.status == status).toList();

  Booking submitBookingRequest({
    required String patientName,
    required String phone,
    String? telegramOrWhatsapp,
    required String concern,
    required String treatmentId,
    required String treatmentName,
    required String clinicId,
    required String clinicName,
    String? doctorId,
    String? doctorName,
    required String date,
    required String time,
    required String note,
  }) {
    final booking = Booking(
      id: 'booking_${DateTime.now().millisecondsSinceEpoch}',
      patientName: patientName,
      phone: phone,
      telegramOrWhatsapp:
          (telegramOrWhatsapp != null && telegramOrWhatsapp.trim().isEmpty)
              ? null
              : telegramOrWhatsapp,
      concern: concern,
      treatmentId: treatmentId,
      treatmentName: treatmentName,
      clinicId: clinicId,
      clinicName: clinicName,
      doctorId: doctorId,
      doctorName: doctorName,
      date: date,
      time: time,
      note: note,
      status: BookingStatus.pending,
      createdAt: DateTime.now(),
    );
    _bookings.insert(0, booking);
    _store.saveBookings(_bookings);
    notifyListeners();
    return booking;
  }

  void _updateBooking(String id, Booking Function(Booking) update) {
    final index = _bookings.indexWhere((booking) => booking.id == id);
    if (index == -1) return;
    _bookings[index] = update(_bookings[index]);
    _store.saveBookings(_bookings);
    notifyListeners();
  }

  /// Customer cancels their own pending request.
  void cancelByCustomer(String id) => _updateBooking(
        id,
        (booking) => booking.copyWith(
          status: BookingStatus.cancelled,
          updatedAt: DateTime.now(),
        ),
      );

  // Clinic staff actions (demo only).
  void staffConfirm(String id) => _updateBooking(
        id,
        (booking) => booking.copyWith(
          status: BookingStatus.confirmed,
          updatedAt: DateTime.now(),
        ),
      );

  void staffCancel(String id) => _updateBooking(
        id,
        (booking) => booking.copyWith(
          status: BookingStatus.cancelled,
          updatedAt: DateTime.now(),
        ),
      );

  void staffComplete(String id) => _updateBooking(
        id,
        (booking) => booking.copyWith(
          status: BookingStatus.completed,
          updatedAt: DateTime.now(),
        ),
      );

  void staffReschedule(String id, String date, String time) => _updateBooking(
        id,
        (booking) => booking.copyWith(
          status: BookingStatus.rescheduled,
          date: date,
          time: time,
          updatedAt: DateTime.now(),
        ),
      );
}
