import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/university.dart';

final universitySearchProvider = StateNotifierProvider<UniversitySearchNotifier, AsyncValue<List<University>>>((ref) {
  return UniversitySearchNotifier();
});

class UniversitySearchNotifier extends StateNotifier<AsyncValue<List<University>>> {
  UniversitySearchNotifier() : super(const AsyncValue.data([]));

  Future<void> searchUniversities(String query) async {
    if (query.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();

    try {
      final response = await http.get(
        Uri.parse('http://universities.hipolabs.com/search?name=$query'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final universities = jsonData.map((json) => University.fromJson(json)).toList();
        state = AsyncValue.data(universities);
      } else {
        throw Exception('Failed to load universities');
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}