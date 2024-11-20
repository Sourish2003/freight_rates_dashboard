import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool includeNearbyOriginPorts = false;
  bool includeNearbyDestinationPorts = false;
  bool fcl = true;
  bool lcl = false;
  String selectedContainerSize = '40\' Standard';
  String selectedCommodity = 'wastepaper';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/assets/images/img.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Main content container with rounded corners
          Row(
            children: [
              const SidebarNavigation(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9), // Adjust opacity if needed
                      borderRadius: BorderRadius.circular(20), // Rounded corners
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
                        const SizedBox(height: 20),
                        _buildHeader(),
                        const SizedBox(height: 30),
                        _buildSearchFields(),
                        const SizedBox(height: 20),
                        _buildCommodityAndCutoffRow(),
                        const SizedBox(height: 20),
                        _buildShipmentTypeAndContainerSize(),
                        const SizedBox(height: 20),
                        _buildContainerDimensions(),
                        const Spacer(),
                        _buildSearchButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
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
            // Implement history functionality
          },
          icon: const Icon(Icons.history),
          label: const Text('History'),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.location_on_outlined),
          ),
        ),
        Row(
          children: [
            Checkbox(
              value: includeNearby,
              onChanged: (bool? value) {
                onChanged(value ?? false);
              },
            ),
            Text('Include nearby $label ports'),
          ],
        ),
      ],
    );
  }

  Widget _buildCommodityAndCutoffRow() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Commodity',
              border: OutlineInputBorder(),
            ),
            value: selectedCommodity,
            items: ['wastepaper', 'metal']
                .map((commodity) => DropdownMenuItem(
                      value: commodity,
                      child: Text(commodity),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedCommodity = value!;
              });
            },
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
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Shipment Type:'),
              Row(
                children: [
                  Checkbox(
                    value: fcl,
                    onChanged: (bool? value) =>
                        setState(() => fcl = value ?? false),
                  ),
                  const Text('FCL'),
                  const SizedBox(width: 20),
                  Checkbox(
                    value: lcl,
                    onChanged: (bool? value) =>
                        setState(() => lcl = value ?? false),
                  ),
                  const Text('LCL'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
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
    lengthController.text = dimensions['length']!.toStringAsFixed(2);
    widthController.text = dimensions['width']!.toStringAsFixed(2);
    heightController.text = dimensions['height']!.toStringAsFixed(2);
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
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Implement search functionality
        },
        child: const Text('Search'),
      ),
    );
  }
}

class SidebarNavigation extends StatelessWidget {
  const SidebarNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Colors.blueGrey[900],
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildListTile(
            icon: Icons.search_rounded,
            title: 'Bookings',
          ),
          _buildListTile(
            icon: Icons.note,
            title: 'Quotations',
          ),
          _buildListTile(
            icon: Icons.settings,
            title: 'Settings',
          ),
          const Spacer(),
          _buildProfileTile(),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTile() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),
          SizedBox(height: 4),
          Text(
            'Profile',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const FreightDashboardApp());
// }
//
// class FreightDashboardApp extends StatelessWidget {
//   const FreightDashboardApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Freight Dashboard',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: Colors.grey[100],
//       ),
//       home: const DashboardScreen(),
//     );
//   }
// }
//
// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});
//
//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }
//
// class _DashboardScreenState extends State<DashboardScreen> {
//   bool includeNearbyOriginPorts = false;
//   bool includeNearbyDestinationPorts = false;
//   bool fcl = true;
//   bool lcl = false;
//   String selectedContainer = '40\' Standard';
//   final TextEditingController lengthController = TextEditingController(text: '39.46');
//   final TextEditingController widthController = TextEditingController(text: '7.70');
//   final TextEditingController heightController = TextEditingController(text: '7.84');
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         children: [
//           // Sidebar Navigation
//           Container(
//             width: 80,
//             color: Colors.white,
//             child: Column(
//               children: [
//                 const SizedBox(height: 20),
//                 Image.asset('assets/logo.png', width: 40, height: 40),
//                 const SizedBox(height: 40),
//                 _buildNavItem(Icons.bookmark_border, 'Bookings'),
//                 _buildNavItem(Icons.description_outlined, 'Quotations'),
//                 _buildNavItem(Icons.settings_outlined, 'Settings'),
//                 const Spacer(),
//                 _buildNavItem(Icons.person_outline, 'Profile'),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//           // Main Content
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         'Search the best Freight Rates',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       TextButton.icon(
//                         onPressed: () {},
//                         icon: const Icon(Icons.history),
//                         label: const Text('History'),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 30),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _buildLocationField(
//                           'Origin',
//                           includeNearbyOriginPorts,
//                               (value) => setState(() => includeNearbyOriginPorts = value),
//                         ),
//                       ),
//                       const SizedBox(width: 20),
//                       Expanded(
//                         child: _buildLocationField(
//                           'Destination',
//                           includeNearbyDestinationPorts,
//                               (value) => setState(() => includeNearbyDestinationPorts = value),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _buildDropdownField('Commodity'),
//                       ),
//                       const SizedBox(width: 20),
//                       Expanded(
//                         child: _buildDateField('Cut Off Date'),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     'Shipment Type:',
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                   Row(
//                     children: [
//                       Checkbox(
//                         value: fcl,
//                         onChanged: (value) => setState(() => fcl = value!),
//                       ),
//                       const Text('FCL'),
//                       const SizedBox(width: 20),
//                       Checkbox(
//                         value: lcl,
//                         onChanged: (value) => setState(() => lcl = value!),
//                       ),
//                       const Text('LCL'),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _buildDropdownField('Container Size',
//                             value: selectedContainer),
//                       ),
//                       const SizedBox(width: 20),
//                       const Expanded(
//                         child: TextField(
//                           decoration: InputDecoration(
//                             labelText: 'No of Boxes',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 20),
//                       Expanded(
//                         child: TextField(
//                           decoration: const InputDecoration(
//                             labelText: 'Weight (Kg)',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     'To obtain accurate rate for spot rate with guaranteed space and booking, please ensure your container count and weight per container is accurate.',
//                     style: TextStyle(fontSize: 12, color: Colors.grey),
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     'Container Internal Dimensions:',
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     children: [
//                       _buildDimensionField('Length', lengthController, 'ft'),
//                       const SizedBox(width: 20),
//                       _buildDimensionField('Width', widthController, 'ft'),
//                       const SizedBox(width: 20),
//                       _buildDimensionField('Height', heightController, 'ft'),
//                     ],
//                   ),
//                   const Spacer(),
//                   Center(
//                     child: ElevatedButton.icon(
//                       onPressed: () {},
//                       icon: const Icon(Icons.search),
//                       label: const Text('Search'),
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 32,
//                           vertical: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildNavItem(IconData icon, String label) {
//     return Tooltip(
//       message: label,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         child: Icon(icon, color: Colors.grey),
//       ),
//     );
//   }
//
//   Widget _buildLocationField(
//       String label,
//       bool includeNearby,
//       Function(bool) onChanged,
//       ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextField(
//           decoration: InputDecoration(
//             labelText: label,
//             border: const OutlineInputBorder(),
//             prefixIcon: const Icon(Icons.location_on_outlined),
//           ),
//         ),
//         Row(
//           children: [
//             Checkbox(
//               value: includeNearby,
//               onChanged: (value) => onChanged(value!),
//             ),
//             Text('Include nearby $label ports'),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDropdownField(String label, {String? value}) {
//     return TextField(
//       decoration: InputDecoration(
//         labelText: label,
//         border: const OutlineInputBorder(),
//         suffixIcon: const Icon(Icons.arrow_drop_down),
//       ),
//       readOnly: true,
//       controller: TextEditingController(text: value),
//     );
//   }
//
//   Widget _buildDateField(String label) {
//     return TextField(
//       decoration: InputDecoration(
//         labelText: label,
//         border: const OutlineInputBorder(),
//         suffixIcon: const Icon(Icons.calendar_today),
//       ),
//       readOnly: true,
//     );
//   }
//
//   Widget _buildDimensionField(
//       String label,
//       TextEditingController controller,
//       String unit,
//       ) {
//     return Expanded(
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//           suffixText: unit,
//         ),
//       ),
//     );
//   }
// }
