import 'package:flutter/material.dart';
import 'sidebar.dart';

class Shell extends StatelessWidget {
  final Widget child;

  const Shell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/img.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            children: [
              const SidebarNavigation(),
              Expanded(child: child),
            ],
          ),
        ],
      ),
    );
  }
}
