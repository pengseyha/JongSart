/// Configuration for the local NestJS mock backend.
///
/// The app currently runs on local/mock data. This config only prepares the
/// network layer so it can be switched on later.
///
/// Base URL guide:
/// - Flutter web / Chrome:   http://localhost:3000
/// - Android emulator:       http://10.0.2.2:3000
/// - Real device / LAN:      http://<your-computer-ip>:3000
///
/// To switch environments, change [baseUrl] (one place).
class ApiConfig {
  const ApiConfig._();

  /// Default base URL for Chrome / Flutter web.
  static const String baseUrl = 'http://localhost:3000';

  /// Convenience constant for the Android emulator. Assign it to [baseUrl]
  /// when running on an emulator:
  ///   static const String baseUrl = ApiConfig.androidEmulatorBaseUrl;
  static const String androidEmulatorBaseUrl = 'http://10.0.2.2:3000';

  /// Simple request timeout so a stopped backend fails fast instead of hanging.
  static const Duration timeout = Duration(seconds: 10);
}
