import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/clinic.dart';
import '../../models/doctor.dart';
import '../../models/treatment_model.dart';

class MockRepository {
  Future<List<dynamic>> _loadJsonList(String path) async {
    final response = await rootBundle.loadString(path);
    return json.decode(response) as List<dynamic>;
  }

  Future<List<Treatment>> loadTreatments() async {
    try {
      final data = await _loadJsonList('assets/mock/items.json');

      return data
          .map((jsonItem) => Treatment(
                id: jsonItem['id'].toString(),
                title: jsonItem['title'],
                category: jsonItem['category'],
                price: jsonItem['price'],
                rating: jsonItem['rating'].toString(),
                imageUrl: jsonItem['imageUrl'],
                duration: jsonItem['duration'],
              ))
          .toList();
    } catch (e) {
      return _loadTreatmentFallback();
    }
  }

  Future<List<Treatment>> _loadTreatmentFallback() async {
    try {
      final data = await _loadJsonList('assets/mock/treatments.json');

      return data
          .map((jsonItem) => Treatment(
                id: jsonItem['id'].toString(),
                title: (jsonItem['title'] ?? jsonItem['name']).toString(),
                category: jsonItem['category'].toString(),
                price: '\$${jsonItem['price']}',
                rating: (jsonItem['rating'] ?? 4.8).toString(),
                imageUrl: (jsonItem['imageUrl'] ?? '').toString(),
                duration: '${jsonItem['duration']}m',
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Doctor>> loadDoctors() async {
    try {
      final data = await _loadJsonList('assets/mock/doctors.json');

      return data
          .map((jsonItem) => Doctor(
                id: jsonItem['id'].toString(),
                name: jsonItem['name'].toString(),
                specialty: jsonItem['specialty'].toString(),
                experience: jsonItem['experience'] as int,
                rating: (jsonItem['rating'] as num).toDouble(),
                patients: jsonItem['patients'] as int,
                clinic: jsonItem['clinic'].toString(),
                about: jsonItem['about'].toString(),
                imageUrl: (jsonItem['imageUrl'] ?? '').toString(),
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Clinic>> loadClinics() async {
    try {
      final data = await _loadJsonList('assets/mock/branches.json');

      return data
          .map((jsonItem) => Clinic(
                id: jsonItem['id'].toString(),
                name: jsonItem['name'].toString(),
                specialty: jsonItem['specialty'].toString(),
                address: jsonItem['address'].toString(),
                distance: jsonItem['distance'].toString(),
                rating: (jsonItem['rating'] as num).toDouble(),
                reviewCount: jsonItem['reviewCount'] as int,
                tags: (jsonItem['tags'] as List<dynamic>)
                    .map((tag) => tag.toString())
                    .toList(),
                isOpen: jsonItem['isOpen'] as bool,
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
