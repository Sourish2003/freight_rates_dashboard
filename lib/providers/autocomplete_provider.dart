import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final autoCompleteProvider = StateNotifierProvider.family<AutoCompleteNotifier, List<String>, String>((ref, queryType) {
  return AutoCompleteNotifier(queryType);
});

class AutoCompleteNotifier extends StateNotifier<List<String>> {
  AutoCompleteNotifier(String queryType) : super([]) {
    _queryType = queryType;
  }

  String _queryType = '';

  Future<void> updateQuery(String query) async {
    if (query.isEmpty) {
      state = [];
      return;
    }

    final response = await http.get(Uri.parse('http://universities.hipolabs.com/search?name=$query'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      state = data.map((university) => university['name'] as String).toList();
    } else {
      throw Exception('Failed to fetch universities');
    }
  }
}
