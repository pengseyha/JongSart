import '../../models/clinic.dart';
import '../../models/doctor.dart';
import '../../models/offer.dart';
import '../../models/treatment_model.dart';
import 'backend_api_service.dart';

/// Read-only catalog (clinics, doctors, treatments, offers) mapped from the
/// backend into the app's existing models.
class RemoteCatalog {
  final List<Clinic> clinics;
  final List<Doctor> doctors;
  final List<Treatment> treatments;
  final List<Offer> offers;

  const RemoteCatalog({
    required this.clinics,
    required this.doctors,
    required this.treatments,
    required this.offers,
  });
}

/// Thrown when the backend catalog cannot be fully loaded. The caller is
/// expected to catch this and fall back to local/mock data.
class CatalogException implements Exception {
  final String message;
  const CatalogException(this.message);
  @override
  String toString() => message;
}

/// Loads the read-only catalog from the NestJS mock backend and maps the JSON
/// to the app's models. This layer never touches local storage or app state —
/// it only fetches + maps, so it is easy to test and easy to fall back from.
class CatalogRepository {
  CatalogRepository({BackendApiService? api})
      : _api = api ?? BackendApiService();

  final BackendApiService _api;

  // A neutral skincare image used when the backend treatment has no image.
  static const String _defaultTreatmentImage =
      'https://images.unsplash.com/photo-1512290923902-8a9f81dc236c?w=500';

  /// Fetches every catalog list. If ANY call fails, throws [CatalogException]
  /// so the app can fall back to local data atomically (no mixed sources).
  Future<RemoteCatalog> fetchCatalog() async {
    final clinicsRes = await _api.getClinics();
    final doctorsRes = await _api.getDoctors();
    final treatmentsRes = await _api.getTreatments();
    final promosRes = await _api.getPromotions();

    if (clinicsRes.isFailure) throw CatalogException(clinicsRes.error!);
    if (doctorsRes.isFailure) throw CatalogException(doctorsRes.error!);
    if (treatmentsRes.isFailure) throw CatalogException(treatmentsRes.error!);
    if (promosRes.isFailure) throw CatalogException(promosRes.error!);

    final clinics = _mapList(clinicsRes.data, _clinicFromJson);
    final doctors = _mapList(doctorsRes.data, _doctorFromJson);
    final treatments = _mapList(treatmentsRes.data, _treatmentFromJson);
    final offers = _mapList(promosRes.data, _offerFromJson);

    // If the backend somehow returns empty catalog lists, treat it as "no
    // usable backend data" and fall back to the local demo content instead.
    if (clinics.isEmpty || treatments.isEmpty) {
      throw const CatalogException('Backend returned an empty catalog.');
    }

    return RemoteCatalog(
      clinics: clinics,
      doctors: doctors,
      treatments: treatments,
      offers: offers,
    );
  }

  List<T> _mapList<T>(
    List<dynamic>? data,
    T Function(Map<String, dynamic>) map,
  ) {
    if (data == null) return <T>[];
    return data
        .whereType<Map>()
        .map((item) => map(Map<String, dynamic>.from(item)))
        .toList();
  }

  Clinic _clinicFromJson(Map<String, dynamic> json) => Clinic(
        id: _string(json['id']),
        name: _string(json['name'], fallback: 'Clinic'),
        specialty: _string(json['specialty']),
        address: _string(json['address'], fallback: 'Phnom Penh'),
        distance: _string(json['distance']),
        rating: _toDouble(json['rating'], 4.8),
        // Backend has no review count yet — default safely.
        reviewCount: _toInt(json['reviewCount'], 0),
        tags: _stringList(json['tags']),
        isOpen: json['isOpen'] is bool ? json['isOpen'] as bool : true,
      );

  Doctor _doctorFromJson(Map<String, dynamic> json) => Doctor(
        id: _string(json['id']),
        name: _string(json['name'], fallback: 'Doctor'),
        specialty: _string(json['specialty'], fallback: 'Consultation'),
        experience: _toInt(json['experienceYears'] ?? json['experience'], 0),
        rating: _toDouble(json['rating'], 4.8),
        patients: _toInt(json['patients'], 0),
        clinic: _string(json['clinicName'] ?? json['clinic']),
        about: _string(
          json['about'],
          fallback:
              'Provides skin health consultation and gentle care. Clinic staff will confirm suitability before treatment.',
        ),
        imageUrl: _string(json['imageUrl']),
      );

  Treatment _treatmentFromJson(Map<String, dynamic> json) => Treatment(
        id: _string(json['id']),
        title: _string(json['title'], fallback: 'Treatment'),
        category: _string(json['category']),
        price: _string(json['price']),
        rating: _string(json['rating'], fallback: '4.8'),
        imageUrl: _string(json['imageUrl'], fallback: _defaultTreatmentImage),
        duration: _string(json['duration']),
      );

  Offer _offerFromJson(Map<String, dynamic> json) => Offer(
        id: _string(json['id']),
        title: _string(json['title'], fallback: 'Offer'),
        subtitle: _string(json['subtitle']),
        price: _string(json['price']),
        badge: _string(json['badge']),
      );

  // --- Safe value helpers ----------------------------------------------
  String _string(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    final text = value.toString();
    return text.isEmpty ? fallback : text;
  }

  List<String> _stringList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return const <String>[];
  }

  double _toDouble(dynamic value, double fallback) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? fallback;
    return fallback;
  }

  int _toInt(dynamic value, int fallback) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }
}
