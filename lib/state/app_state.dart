import 'package:flutter/material.dart';
import '../data/mock_repository.dart';
import '../models/booking.dart';
import '../models/chat_message.dart';
import '../models/clinic.dart';
import '../models/offer.dart';
import '../models/patient_review.dart';
import '../models/skin_recommendation.dart';
import '../models/treatment_model.dart';

class AppState extends ChangeNotifier {
  final MockRepository _repository = MockRepository();

  List<Treatment> _treatments = [];
  bool _isLoading = true;
  final Set<String> _favoriteIds = {'clinic_lumina', 'treatment_hydra'};
  final Set<String> _claimedOfferIds = {};
  final List<Booking> _bookings = [];
  final List<ChatMessage> _chatMessages = [
    ChatMessage(
      id: 'm1',
      text:
          'Hello! Welcome to DermaCare. I am Sarah, your clinical receptionist. How can I assist you today?',
      isMe: false,
      sentAt: DateTime(2026, 6, 7, 9, 15),
    ),
    ChatMessage(
      id: 'm2',
      text:
          'Hi Sarah, I am interested in the advanced chemical peel treatment. Is it okay for sensitive skin?',
      isMe: true,
      sentAt: DateTime(2026, 6, 7, 9, 17),
    ),
    ChatMessage(
      id: 'm3',
      text:
          'That is a wonderful choice. We usually begin with a consultation and sensitivity review before choosing peel strength.',
      isMe: false,
      sentAt: DateTime(2026, 6, 7, 9, 18),
    ),
  ];

  String _selectedConcern = 'Acne & Breakouts';
  String _selectedDate = 'Mon 24';
  String _selectedTime = '12:30 PM';
  int _activeBookingStep = 0;

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

  final List<PatientReview> _reviews = const [
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

  List<Treatment> get treatments => _treatments;
  bool get isLoading => _isLoading;
  List<String> get favoriteIds => _favoriteIds.toList();
  List<Clinic> get clinics => List.unmodifiable(_clinics);
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
  String get selectedDate => _selectedDate;
  String get selectedTime => _selectedTime;
  int get activeBookingStep => _activeBookingStep;
  int get claimedOfferCount => _claimedOfferIds.length;
  int get favoriteCount => _favoriteIds.length;
  double get averageReviewRating =>
      _reviews.fold<double>(0, (sum, review) => sum + review.rating) /
      _reviews.length;

  AppState() {
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    _isLoading = true;
    notifyListeners();

    _treatments = await _repository.loadTreatments();

    _isLoading = false;
    notifyListeners();
  }

  void toggleFavorite(String id) {
    if (!_favoriteIds.add(id)) {
      _favoriteIds.remove(id);
    }
    notifyListeners();
  }

  bool isFavorite(String id) => _favoriteIds.contains(id);

  void claimOffer(String id) {
    _claimedOfferIds.add(id);
    notifyListeners();
  }

  bool isOfferClaimed(String id) => _claimedOfferIds.contains(id);

  void selectConcern(String concern) {
    _selectedConcern = concern;
    _activeBookingStep = 1;
    notifyListeners();
  }

  void selectDate(String date) {
    _selectedDate = date;
    _activeBookingStep = 2;
    notifyListeners();
  }

  void selectTime(String time) {
    _selectedTime = time;
    _activeBookingStep = 3;
    notifyListeners();
  }

  Booking confirmBooking() {
    final booking = Booking(
      id: 'booking_${_bookings.length + 1}',
      concern: _selectedConcern,
      date: _selectedDate,
      time: _selectedTime,
      doctorName: 'Dr. Frances',
      clinicName: 'JongSart Clinic',
      status: 'Confirmed',
    );
    _bookings.insert(0, booking);
    _activeBookingStep = 4;
    notifyListeners();
    return booking;
  }

  void sendChatMessage(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    _chatMessages.add(ChatMessage(
      id: 'm${_chatMessages.length + 1}',
      text: trimmed,
      isMe: true,
      sentAt: DateTime.now(),
    ));

    _chatMessages.add(ChatMessage(
      id: 'm${_chatMessages.length + 1}',
      text:
          'Thanks for sharing. I added that to your consultation notes and can help you book the next available slot.',
      isMe: false,
      sentAt: DateTime.now(),
    ));
    notifyListeners();
  }

  List<Clinic> searchClinics(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return clinics;
    return _clinics.where((clinic) {
      return clinic.name.toLowerCase().contains(normalized) ||
          clinic.specialty.toLowerCase().contains(normalized) ||
          clinic.tags.any((tag) => tag.toLowerCase().contains(normalized));
    }).toList();
  }

  List<Clinic> get favoriteClinics =>
      _clinics.where((clinic) => _favoriteIds.contains(clinic.id)).toList();

  List<SkinRecommendation> get favoriteRecommendations => _skinRecommendations
      .where((recommendation) => _favoriteIds.contains(recommendation.id))
      .toList();

  String get skinProfileSummary {
    if (_selectedConcern.contains('Acne')) {
      return 'Combination-oily profile with congestion risk and low hydration.';
    } else if (_selectedConcern.contains('Anti')) {
      return 'Early aging markers with texture unevenness and barrier dryness.';
    } else {
      return 'Sensitive profile with mild dehydration and redness triggers.';
    }
  }
}
