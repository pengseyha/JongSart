import '../../core/network/api_client.dart';
import '../../core/network/api_result.dart';

/// Talks to the local NestJS mock backend.
///
/// The app still runs safely on local/mock data + SharedPreferences. Catalog
/// reads, booking sync, and chat sync use this service as optional best-effort
/// layers; auth is not connected to the backend yet.
///
/// Every method returns an [ApiResult] so callers never have to try/catch:
/// on success `result.data` is set, on failure `result.error` holds a
/// readable message.
class BackendApiService {
  BackendApiService({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  // --- Read endpoints ---------------------------------------------------
  Future<ApiResult<Map<String, dynamic>>> getHealth() =>
      _guardMap(() => _client.get('/health'));

  Future<ApiResult<List<dynamic>>> getClinics() =>
      _guardList(() => _client.get('/clinics'));

  Future<ApiResult<List<dynamic>>> getDoctors() =>
      _guardList(() => _client.get('/doctors'));

  Future<ApiResult<List<dynamic>>> getTreatments() =>
      _guardList(() => _client.get('/treatments'));

  Future<ApiResult<List<dynamic>>> getPromotions() =>
      _guardList(() => _client.get('/promotions'));

  Future<ApiResult<List<dynamic>>> getBookings() =>
      _guardList(() => _client.get('/bookings'));

  Future<ApiResult<List<dynamic>>> getChats() =>
      _guardList(() => _client.get('/chats'));

  // --- Write endpoints --------------------------------------------------
  Future<ApiResult<Map<String, dynamic>>> createBooking(
    Map<String, dynamic> data,
  ) =>
      _guardMap(() => _client.post('/bookings', data));

  Future<ApiResult<Map<String, dynamic>>> updateBookingStatus(
    String id,
    String status,
  ) =>
      _guardMap(
          () => _client.patch('/bookings/$id/status', {'status': status}));

  Future<ApiResult<Map<String, dynamic>>> sendChatMessage(
    Map<String, dynamic> data,
  ) =>
      _guardMap(() => _client.post('/chats/messages', data));

  // --- Debug helper -----------------------------------------------------
  /// Simple manual check (e.g. from a debug button) that returns a readable
  /// status string instead of throwing. Safe to call; does not touch app state.
  Future<String> debugPingHealth() async {
    final result = await getHealth();
    return result.isSuccess
        ? 'Backend reachable: ${result.data}'
        : 'Backend not reachable: ${result.error}';
  }

  /// Releases the underlying HTTP client.
  void dispose() => _client.close();

  // --- Internal helpers -------------------------------------------------
  Future<ApiResult<List<dynamic>>> _guardList(
    Future<dynamic> Function() call,
  ) async {
    try {
      final data = await call();
      if (data is List) return ApiResult.success(data);
      return const ApiResult.failure(
          'Expected a list response from the server.');
    } on ApiException catch (e) {
      return ApiResult.failure(e.message);
    } catch (e) {
      return ApiResult.failure('Unexpected error: $e');
    }
  }

  Future<ApiResult<Map<String, dynamic>>> _guardMap(
    Future<dynamic> Function() call,
  ) async {
    try {
      final data = await call();
      if (data is Map<String, dynamic>) return ApiResult.success(data);
      if (data is Map) {
        return ApiResult.success(Map<String, dynamic>.from(data));
      }
      return const ApiResult.failure(
        'Expected an object response from the server.',
      );
    } on ApiException catch (e) {
      return ApiResult.failure(e.message);
    } catch (e) {
      return ApiResult.failure('Unexpected error: $e');
    }
  }
}
