import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/booking.dart';
import '../../models/chat_message.dart';
import '../../models/patient_review.dart';

/// Simple wrapper around shared_preferences that handles JSON serialization
/// for the app's local state. No backend - everything lives on the device.
class LocalStorageService {
  static const _kBookings = 'jongsart_bookings';
  static const _kFavorites = 'jongsart_favorites';
  static const _kClaimedOffers = 'jongsart_claimed_offers';
  static const _kSkinConcern = 'jongsart_skin_concern';
  static const _kChatMessages = 'jongsart_chat_messages';
  static const _kReviews = 'jongsart_reviews';
  static const _kAuth = 'jongsart_auth';
  static const _kAccounts = 'jongsart_accounts';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _instance async =>
      _prefs ??= await SharedPreferences.getInstance();

  // --- Bookings ---------------------------------------------------------
  Future<void> saveBookings(List<Booking> bookings) async {
    final prefs = await _instance;
    final encoded =
        jsonEncode(bookings.map((booking) => booking.toJson()).toList());
    await prefs.setString(_kBookings, encoded);
  }

  Future<List<Booking>> loadBookings() async {
    final prefs = await _instance;
    final raw = prefs.getString(_kBookings);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> data = jsonDecode(raw);
      return data
          .map((item) => Booking.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // --- Favorites --------------------------------------------------------
  Future<void> saveFavorites(Set<String> ids) async {
    final prefs = await _instance;
    await prefs.setStringList(_kFavorites, ids.toList());
  }

  Future<Set<String>> loadFavorites() async {
    final prefs = await _instance;
    return prefs.getStringList(_kFavorites)?.toSet() ?? {};
  }

  // --- Claimed offers ---------------------------------------------------
  Future<void> saveClaimedOffers(Set<String> ids) async {
    final prefs = await _instance;
    await prefs.setStringList(_kClaimedOffers, ids.toList());
  }

  Future<Set<String>> loadClaimedOffers() async {
    final prefs = await _instance;
    return prefs.getStringList(_kClaimedOffers)?.toSet() ?? {};
  }

  // --- Skin concern -----------------------------------------------------
  Future<void> saveSkinConcern(String concern) async {
    final prefs = await _instance;
    await prefs.setString(_kSkinConcern, concern);
  }

  Future<String?> loadSkinConcern() async {
    final prefs = await _instance;
    return prefs.getString(_kSkinConcern);
  }

  // --- Reviews ----------------------------------------------------------
  Future<void> saveReviews(List<PatientReview> reviews) async {
    final prefs = await _instance;
    final encoded =
        jsonEncode(reviews.map((review) => review.toJson()).toList());
    await prefs.setString(_kReviews, encoded);
  }

  Future<List<PatientReview>?> loadReviews() async {
    final prefs = await _instance;
    final raw = prefs.getString(_kReviews);
    if (raw == null || raw.isEmpty) return null;
    try {
      final List<dynamic> data = jsonDecode(raw);
      return data
          .map((item) => PatientReview.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  // --- Auth session -----------------------------------------------------
  Future<void> saveAuth(Map<String, dynamic> auth) async {
    final prefs = await _instance;
    await prefs.setString(_kAuth, jsonEncode(auth));
  }

  Future<Map<String, dynamic>?> loadAuth() async {
    final prefs = await _instance;
    final raw = prefs.getString(_kAuth);
    if (raw == null || raw.isEmpty) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<void> clearAuth() async {
    final prefs = await _instance;
    await prefs.remove(_kAuth);
  }

  // --- Registered customer accounts (local only, demo) ------------------
  Future<void> saveAccounts(List<Map<String, String>> accounts) async {
    final prefs = await _instance;
    await prefs.setString(_kAccounts, jsonEncode(accounts));
  }

  Future<List<Map<String, String>>> loadAccounts() async {
    final prefs = await _instance;
    final raw = prefs.getString(_kAccounts);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> data = jsonDecode(raw);
      return data
          .map((item) => (item as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value?.toString() ?? '')))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // --- Chat messages ----------------------------------------------------
  Future<void> saveChatMessages(List<ChatMessage> messages) async {
    final prefs = await _instance;
    final encoded =
        jsonEncode(messages.map((message) => message.toJson()).toList());
    await prefs.setString(_kChatMessages, encoded);
  }

  Future<List<ChatMessage>?> loadChatMessages() async {
    final prefs = await _instance;
    final raw = prefs.getString(_kChatMessages);
    if (raw == null || raw.isEmpty) return null;
    try {
      final List<dynamic> data = jsonDecode(raw);
      return data
          .map((item) => ChatMessage.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }
}
