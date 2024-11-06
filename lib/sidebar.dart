import 'package:flutter/material.dart';

class SidebarNavigation extends StatelessWidget {
  const SidebarNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      color: Colors.white70,
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildDemoTile(),
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
          Icon(icon, color: Colors.black, size: 24),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(color: Colors.black, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Image.asset(
        'lib/assets/images/demo_logo.png',
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
            backgroundImage: AssetImage('lib/assets/images/profile_placeholder.png'),
          ),
          SizedBox(height: 4),
          Text(
            'Profile',
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
        ],
      ),
    );
  }
}