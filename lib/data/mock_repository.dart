import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/treatment_model.dart';

class MockRepository {
  Future<List<Treatment>> loadTreatments() async {
    try {
      final String response =
          await rootBundle.loadString('assets/mock/items.json');
      final List<dynamic> data = json.decode(response);

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
      return [];
    }
  }
}
