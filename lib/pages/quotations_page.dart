import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/autocomplete_field.dart';

class QuotationsPage extends StatefulWidget {
  const QuotationsPage({super.key});

  @override
  State<QuotationsPage> createState() => _QuotationsPageState();
}

class _QuotationsPageState extends State<QuotationsPage> {
  bool includeNearbyOriginPorts = false;
  bool includeNearbyDestinationPorts = false;
  bool fcl = true;
  bool lcl = false;
  String selectedContainerSize = '40\' Standard';
  String? selectedCommodity;
  final TextEditingController lengthController =
  TextEditingController(text: '39.46');
  final TextEditingController widthController =
  TextEditingController(text: '7.70');
  final TextEditingController heightController =
  TextEditingController(text: '7.84');
  DateTime cutOffDate = DateTime.now();

  final Map<String, Map<String, double>> containerDimensions = {
    '40\' Standard': {'length': 39.46, 'width': 7.70, 'height': 7.84},
    '40\' Dry': {'length': 40.0, 'width': 7.83, 'height': 7.85},
    '40\' Dry High': {'length': 40.0, 'width': 7.83, 'height': 8.58},
    '45\' Dry High': {'length': 44.80, 'width': 7.83, 'height': 8.58},
  };

  // For managing the history of previous searches
  List<Map<String, dynamic>> searchHistory = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          color: Colors.white.withOpacity(0.8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Search the best Freight Rates',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  _showSearchHistory();
                },
                icon: const Icon(Icons.history),
                label: const Text('History'),
              ),
            ],
          ),
        ),

        // Main content area with 25% gap at the bottom
        Expanded(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: MediaQuery.of(context).size.height * 0.25,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSearchFields(),
                        const SizedBox(height: 20),
                        _buildCommodityAndCutoffRow(),
                        const SizedBox(height: 20),
                        _buildShipmentTypeAndContainerSize(),
                        const SizedBox(height: 20),
                        _buildContainerDimensions(),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _buildSearchButton(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchFields() {
    return Row(
      children: [
        Expanded(
          child: _buildLocationField(
            'Origin',
            includeNearbyOriginPorts,
                (bool? value) =>
                setState(() => includeNearbyOriginPorts = value ?? false),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildLocationField(
            'Destination',
            includeNearbyDestinationPorts,
                (bool? value) =>
                setState(() => includeNearbyDestinationPorts = value ?? false),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationField(
      String label, bool includeNearby, ValueChanged<bool?> onChanged) {
    return AutocompleteField(
      label: label,
      includeNearby: includeNearby,
      onNearbyChanged: onChanged,
    );
  }

  Widget _buildCommodityAndCutoffRow() {
    return Row(
      children: [
        Expanded(
          child: InputDecorator(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Commodity',
            ),
            child: DropdownButton<String>(
              value: selectedCommodity,
              hint: const Text('Commodity'),
              isExpanded: true,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(
                  value: 'wastepaper',
                  child: Text('wastepaper'),
                ),
                DropdownMenuItem(
                  value: 'metal',
                  child: Text('metal'),
                ),
              ],
              onChanged: (String? value) {
                setState(() {
                  selectedCommodity = value;
                });
              },
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Cut Off Date',
              border: const OutlineInputBorder(),
              suffixIcon: GestureDetector(
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: cutOffDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      cutOffDate = selectedDate;
                    });
                  }
                },
                child: const Icon(Icons.calendar_today),
              ),
            ),
            controller: TextEditingController(
              text: DateFormat('dd/MM/yyyy').format(cutOffDate),
            ),
            readOnly: true,
          ),
        ),
      ],
    );
  }

  Widget _buildShipmentTypeAndContainerSize() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Shipment Type:'),
        Row(
          children: [
            Checkbox(
              value: fcl,
              onChanged: (bool? value) => setState(() => fcl = value ?? false),
            ),
            const Text('FCL'),
            const SizedBox(width: 20),
            Checkbox(
              value: lcl,
              onChanged: (bool? value) => setState(() => lcl = value ?? false),
            ),
            const Text('LCL'),
          ],
        ),
        const SizedBox(height: 20),

        // New Row with Container Size, No of Boxes, and Weight fields
        Row(
          children: [
            // Container Size Dropdown
            Expanded(
              flex: 2,
              child: _buildDropdownField(
                'Container Size',
                selectedContainerSize,
                    (String value) {
                  setState(() {
                    selectedContainerSize = value;
                    _updateContainerDimensions();
                  });
                },
              ),
            ),
            const SizedBox(width: 20),

            // No of Boxes TextField
            const Flexible(
              flex: 1,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'No of Boxes',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 20),

            // Weight TextField
            const Flexible(
              flex: 1,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Weight (Kg)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }



  Widget _buildDropdownField(
      String label, String value, ValueChanged<String> onChanged) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.arrow_drop_down),
      ),
      readOnly: true,
      controller: TextEditingController(text: value),
      onTap: () {
        _showContainerSizeMenu(onChanged);
      },
    );
  }

  void _showContainerSizeMenu(ValueChanged<String> onChanged) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Container Size'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: containerDimensions.keys.map((size) {
              return ListTile(
                title: Text(size),
                onTap: () {
                  onChanged(size);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _updateContainerDimensions() {
    final dimensions = containerDimensions[selectedContainerSize]!;

    setState(() {
      lengthController.text = dimensions['length']!.toStringAsFixed(2);
      widthController.text = dimensions['width']!.toStringAsFixed(2);
      heightController.text = dimensions['height']!.toStringAsFixed(2);
    });
  }

  Widget _buildContainerDimensions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Container Internal Dimensions:'),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildDimensionField('Length', lengthController, 'ft'),
            const SizedBox(width: 20),
            _buildDimensionField('Width', widthController, 'ft'),
            const SizedBox(width: 20),
            _buildDimensionField('Height', heightController, 'ft'),
          ],
        ),
      ],
    );
  }

  Widget _buildDimensionField(
      String label, TextEditingController controller, String unit) {
    return Expanded(
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: '$label ($unit)',
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return SizedBox(
      child: ElevatedButton.icon(
        onPressed: () {
          _performSearch();
        },
        icon: const Icon(Icons.search),
        label: const Text('Search'),
      ),
    );
  }

  void _performSearch() {
    // Add your search functionality here
    final searchParams = {
      'origin': includeNearbyOriginPorts,
      'destination': includeNearbyDestinationPorts,
      'shipmentType': fcl ? 'FCL' : 'LCL',
      'containerSize': selectedContainerSize,
      'commodity': selectedCommodity,
      'cutOffDate': DateFormat('dd/MM/yyyy').format(cutOffDate),
    };

    // Add the search params to the history
    setState(() {
      searchHistory.add(searchParams);
    });

    // Implement the logic to perform the search
    // For example, call an API or display the results
    print('Performing search with: $searchParams');
  }

  // Function to show previous search history
  void _showSearchHistory() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search History'),
          content: SizedBox(
            height: 300,
            width: 300,
            child: ListView.builder(
              itemCount: searchHistory.length,
              itemBuilder: (context, index) {
                final historyItem = searchHistory[index];
                return ListTile(
                  title: Text('Origin: ${historyItem['origin']}'),
                  subtitle: Text('Destination: ${historyItem['destination']}'),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
