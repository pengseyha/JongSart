import 'package:flutter/material.dart';
import '../models/treatment_model.dart';
import '../data/mock_repository.dart';

class AppState extends ChangeNotifier {
  final MockRepository _repository = MockRepository();
  
  List<Treatment> _treatments = [];
  bool _isLoading = true;
  final List<String> _favoriteIds = [];

  List<Treatment> get treatments => _treatments;
  bool get isLoading => _isLoading;
  List<String> get favoriteIds => _favoriteIds;

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
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
  }

  bool isFavorite(String id) => _favoriteIds.contains(id);
}
