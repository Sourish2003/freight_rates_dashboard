import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SidebarNavigation extends StatelessWidget {
  const SidebarNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentPath = GoRouterState.of(context).fullPath ?? '';

    return Container(
      width: 100,
      color: Colors.white70,
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildDemoTile(),
          _buildListTile(
            context: context,
            icon: Icons.search_rounded,
            title: 'Bookings',
            path: '/bookings',
            isSelected: currentPath == '/bookings',
          ),
          _buildListTile(
            context: context,
            icon: Icons.note,
            title: 'Quotations',
            path: '/quotations',
            isSelected: currentPath == '/quotations',
          ),
          _buildListTile(
            context: context,
            icon: Icons.settings,
            title: 'Settings',
            path: '/settings',
            isSelected: currentPath == '/settings',
          ),
          const Spacer(),
          _buildProfileTile(
            context: context,
            isSelected: currentPath == '/profile',
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String path,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => context.go(path),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: isSelected ? Colors.blue : Colors.transparent,
              width: 4,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blue : Colors.black,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.black,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
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

  Widget _buildProfileTile({
    required BuildContext context,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => context.go('/profile'),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: isSelected ? Colors.blue : Colors.transparent,
              width: 4,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage:
              const AssetImage('lib/assets/images/profile_placeholder.png'),
              backgroundColor: isSelected ? Colors.blue.withOpacity(0.1) : null,
            ),
            const SizedBox(height: 4),
            Text(
              'Profile',
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.black,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}