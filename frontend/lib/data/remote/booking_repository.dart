import 'package:flutter/foundation.dart';

import '../../models/booking.dart';
import 'backend_api_service.dart';

/// Best-effort bridge between the local booking flow and the NestJS mock API.
///
/// Every method is SAFE: it never throws to the UI. On any failure it returns
/// `null` / an empty list and (in debug) logs why. The app keeps working on
/// local SharedPreferences data regardless of backend state.
class BookingRepository {
  BookingRepository({BackendApiService? api})
      : _api = api ?? BackendApiService();

  final BackendApiService _api;

  /// GET /bookings — returns backend bookings, or an empty list on failure.
  Future<List<Booking>> getBackendBookings() async {
    final result = await _api.getBookings();
    if (result.isFailure) {
      _log('getBackendBookings failed: ${result.error}');
      return const <Booking>[];
    }
    final data = result.data ?? const [];
    try {
      return data
          .whereType<Map>()
          .map((item) =>
              _bookingFromBackendJson(Map<String, dynamic>.from(item)))
          .toList();
    } catch (e) {
      _log('getBackendBookings mapping failed: $e');
      return const <Booking>[];
    }
  }

  /// POST /bookings — sends a locally-created booking to the backend.
  /// Returns the backend booking (with its own id) or null on failure.
  Future<Booking?> createBackendBooking(Booking booking) async {
    final result = await _api.createBooking(_toBackendPayload(booking));
    if (result.isFailure || result.data == null) {
      _log('createBackendBooking failed: ${result.error}');
      return null;
    }
    try {
      return _bookingFromBackendJson(result.data!);
    } catch (e) {
      _log('createBackendBooking mapping failed: $e');
      return null;
    }
  }

  /// PATCH /bookings/:id/status — updates status on the backend.
  /// [statusLabel] must be a backend label, e.g. "Confirmed" (use
  /// [BookingStatus.label]). Returns the updated booking or null on failure.
  Future<Booking?> updateBackendBookingStatus(
    String id,
    String statusLabel,
  ) async {
    final result = await _api.updateBookingStatus(id, statusLabel);
    if (result.isFailure || result.data == null) {
      _log('updateBackendBookingStatus failed: ${result.error}');
      return null;
    }
    try {
      return _bookingFromBackendJson(result.data!);
    } catch (e) {
      _log('updateBackendBookingStatus mapping failed: $e');
      return null;
    }
  }

  // --- Mapping ----------------------------------------------------------
  /// Maps a local [Booking] to the backend's CreateBooking body. The backend
  /// only stores a subset of fields; the rest stays local.
  Map<String, dynamic> _toBackendPayload(Booking booking) {
    return {
      'patientName': booking.patientName,
      'phone': booking.phone,
      'treatmentName': booking.treatmentName,
      'clinicName': booking.clinicName,
      if (booking.doctorName != null) 'doctorName': booking.doctorName,
      'date': booking.date,
      'time': booking.time,
      'note': booking.note,
    };
  }

  Booking _bookingFromBackendJson(Map<String, dynamic> json) {
    return Booking(
      id: (json['id'] ?? '').toString(),
      patientName: (json['patientName'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      telegramOrWhatsapp: json['telegramOrWhatsapp']?.toString(),
      // These fields are not stored by the backend yet — keep safe defaults.
      concern: (json['concern'] ?? '').toString(),
      treatmentId: (json['treatmentId'] ?? '').toString(),
      treatmentName: (json['treatmentName'] ?? '').toString(),
      clinicId: (json['clinicId'] ?? '').toString(),
      clinicName: (json['clinicName'] ?? '').toString(),
      doctorId: json['doctorId']?.toString(),
      doctorName: json['doctorName']?.toString(),
      date: (json['date'] ?? '').toString(),
      time: (json['time'] ?? '').toString(),
      note: (json['note'] ?? '').toString(),
      status: _statusFromLabel(json['status']?.toString()),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.tryParse(json['updatedAt'].toString()),
    );
  }

  /// Backend uses full labels ("Pending Confirmation"), the app uses an enum.
  BookingStatus _statusFromLabel(String? label) {
    switch (label) {
      case 'Confirmed':
        return BookingStatus.confirmed;
      case 'Rescheduled':
        return BookingStatus.rescheduled;
      case 'Cancelled':
        return BookingStatus.cancelled;
      case 'Completed':
        return BookingStatus.completed;
      case 'Pending Confirmation':
      default:
        return BookingStatus.pending;
    }
  }

  void _log(String message) {
    if (kDebugMode) debugPrint('[BookingRepository] $message');
  }
}
