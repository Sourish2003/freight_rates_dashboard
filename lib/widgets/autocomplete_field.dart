import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/university.dart';

final universitySearchProvider = StateNotifierProvider<UniversitySearchNotifier, AsyncValue<List<University>>>(
      (ref) => UniversitySearchNotifier(),
);

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

class AutocompleteField extends ConsumerWidget {
  final String label;
  final bool includeNearby;
  final ValueChanged<bool?> onNearbyChanged;

  const AutocompleteField({
    super.key,
    required this.label,
    required this.includeNearby,
    required this.onNearbyChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Autocomplete<University>(
          displayStringForOption: (University university) =>
          '${university.name}, ${university.country}',
          optionsBuilder: (textEditingValue) {
            return _searchUniversities(ref, textEditingValue.text);
          },
          onSelected: (University selection) {
            debugPrint('Selected: ${selection.name}, ${selection.country}');
          },
          fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.location_on_outlined),
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            double windowWidth = MediaQuery.of(context).size.width;
            double dropdownMaxWidth = windowWidth * 0.45; // Adjust this factor as needed

            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                    maxWidth: dropdownMaxWidth, // Dynamically set dropdown width
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return InkWell(
                        onTap: () => onSelected(option),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            '${option.name}, ${option.country}',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
        Row(
          children: [
            Checkbox(
              value: includeNearby,
              onChanged: onNearbyChanged,
            ),
            Text('Include nearby $label ports'),
          ],
        ),
      ],
    );
  }

  Future<Iterable<University>> _searchUniversities(WidgetRef ref, String query) async {
    await ref.read(universitySearchProvider.notifier).searchUniversities(query);
    final universitiesAsync = ref.watch(universitySearchProvider);
    return universitiesAsync.whenData((universities) => universities).value ?? [];
  }
}