import 'package:flutter/material.dart';
import '../core/storage/local_storage_service.dart';
import '../data/mock/mock_repository.dart';
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

  List<Treatment> _treatments = [];
  bool _isLoading = true;

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

  final List<Clinic> _clinics = const [
    Clinic(
      id: 'clinic_lumina',
      name: 'Lumina Skin Institute',
      specialty: 'Laser dermatology and clinical facials',
      address: 'Russian Federation Blvd, Phnom Penh',
      distance: '0.9 km',
      rating: 4.9,
      reviewCount: 1221,
      tags: ['Dermatology', 'Laser', 'Open'],
      isOpen: true,
    ),
    Clinic(
      id: 'clinic_emerald',
      name: 'Emerald Medical Spa',
      specialty: 'Hydration, anti-aging, and recovery care',
      address: 'BKK1, Phnom Penh',
      distance: '2.7 km',
      rating: 4.8,
      reviewCount: 836,
      tags: ['Cosmetic', 'Hydrafacial'],
      isOpen: true,
    ),
    Clinic(
      id: 'clinic_north_peak',
      name: 'North Peak Surgical',
      specialty: 'Surgical dermatology and scar support',
      address: 'Toul Kork, Phnom Penh',
      distance: '4.8 km',
      rating: 4.7,
      reviewCount: 612,
      tags: ['Surgical', 'Pediatric'],
      isOpen: false,
    ),
  ];

  final List<Doctor> _doctors = const [
    Doctor(
      id: 'doctor_frances',
      name: 'Dr. Frances',
      specialty: 'Dermatologist',
      experience: 12,
      rating: 4.9,
      patients: 847,
      clinic: 'Lumina Skin Institute',
      about: 'Specialist in clinical skincare and gentle facial treatments.',
      imageUrl: '',
    ),
    Doctor(
      id: 'doctor_sarah',
      name: 'Dr. Sarah Chen',
      specialty: 'Medical Laser',
      experience: 9,
      rating: 4.8,
      patients: 532,
      clinic: 'Lumina Skin Institute',
      about: 'Focused on laser therapy for pigmentation and acne scars.',
      imageUrl: '',
    ),
    Doctor(
      id: 'doctor_lina',
      name: 'Dr. Lina Sok',
      specialty: 'Cosmetic Care',
      experience: 7,
      rating: 4.8,
      patients: 410,
      clinic: 'Emerald Medical Spa',
      about: 'Hydration and anti-aging treatments with a gentle approach.',
      imageUrl: '',
    ),
  ];

  final List<Offer> _offers = const [
    Offer(
      id: 'offer_flash_facial',
      title: 'Advanced Lactic Facial',
      subtitle: 'Flash deal for sensitive glow care',
      price: '\$85',
      badge: '40% Off',
    ),
    Offer(
      id: 'offer_radiance_trio',
      title: 'The Radiance Trio',
      subtitle: '3 clinical sessions with aftercare',
      price: '\$120',
      badge: 'Bundle',
    ),
    Offer(
      id: 'offer_age_reverse',
      title: 'Age-Reverse Cycle',
      subtitle: 'Laser, recovery, and barrier repair',
      price: '\$180',
      badge: 'Premium',
    ),
  ];

  List<PatientReview> _reviews = const [
    PatientReview(
      id: 'review_elena',
      name: 'Elena Morn',
      label: 'Chemical Peel',
      body:
          'The consultation after just one session was incredible. My skin feels calm, clean, and hydrated.',
      rating: 5.0,
    ),
    PatientReview(
      id: 'review_julien',
      name: 'Julien Smith',
      label: 'Laser Therapy',
      body:
          'Excellent results for my acne scarring. The clinical explanation made me confident.',
      rating: 4.9,
    ),
    PatientReview(
      id: 'review_sarah',
      name: 'Sarah Chen',
      label: 'HydraFacial',
      body:
          'Professional, calming, and clean. I loved the follow-up recommendations.',
      rating: 4.8,
    ),
  ];

  final List<SkinRecommendation> _skinRecommendations = const [
    SkinRecommendation(
      id: 'treatment_hydra',
      title: 'Bio-Restorative HydraFacial',
      match: '92% match',
      description:
          'Medical-grade hydration treatment for dry, congested combination skin.',
      price: '\$120',
    ),
    SkinRecommendation(
      id: 'treatment_blue_light',
      title: 'Blue Light Detox Therapy',
      match: '89% match',
      description:
          'Targeted blemish support for sensitive and breakout-prone skin.',
      price: '\$95',
    ),
    SkinRecommendation(
      id: 'treatment_lactic_peel',
      title: 'Lactic Silk Peel',
      match: '85% match',
      description: 'Gentle polish and glow support for uneven skin texture.',
      price: '\$115',
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

  AppState() {
    _bootstrap();
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

    final accounts = await _store.loadAccounts();
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

    _applySession(role: 'customer', name: name, phone: phoneNumber, email: mail);
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
    final accounts = await _store.loadAccounts();

    Map<String, String>? match;
    for (final account in accounts) {
      final accountPhone = (account['phone'] ?? '').toLowerCase();
      final accountEmail = (account['email'] ?? '').toLowerCase();
      if ((accountPhone == id || (accountEmail.isNotEmpty && accountEmail == id)) &&
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
