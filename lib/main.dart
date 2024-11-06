import 'package:flutter/material.dart';
import 'dashboard.dart';


void main() {
  runApp(const FreightDashboardApp());
}

class FreightDashboardApp extends StatelessWidget {
  const FreightDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Freight Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const DashboardScreen(),
    );
  }
}






