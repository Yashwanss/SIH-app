import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'emergency_screen.dart';
import 'profile_screen.dart';

class SafeTravelDashboard extends StatefulWidget {
  final String digitalId;

  const SafeTravelDashboard({super.key, required this.digitalId});

  @override
  State<SafeTravelDashboard> createState() => _SafeTravelDashboardState();
}

class _SafeTravelDashboardState extends State<SafeTravelDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const EmergencyScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(
        64,
      ), // Header height from design spec
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Color(0x1A000000), // 10% Black border
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000), // 10% Black shadow
              offset: Offset(0, 1),
              blurRadius: 3,
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Text(
                  'SafeTravel',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: const Color(0xFF1F2937), // Gray-800
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),

                // Digital ID Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16A34A), // Success Green
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.verified_user,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'ID: ${widget.digitalId}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 84, // Bottom navigation height from design spec
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0x1A000000), // 10% Black border
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000), // 10% Black shadow
            offset: Offset(0, -4),
            blurRadius: 6,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              Expanded(child: _buildNavItem(0, Icons.home, 'Home')),
              Expanded(child: _buildNavItem(1, Icons.emergency, 'Emergency')),
              Expanded(child: _buildNavItem(2, Icons.person, 'Profile')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final bool isActive = _currentIndex == index;
    final bool isEmergency = index == 1;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        height: 64, // Navigation item height from design spec
        decoration: BoxDecoration(
          color: isActive
              ? (isEmergency
                    ? const Color(0xFFDC2626)
                    : const Color(0xFF030213))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24, // Icon size from design spec
              color: isActive
                  ? Colors.white
                  : (isEmergency
                        ? const Color(0xFFDC2626)
                        : const Color(0xFF717182)),
            ),
            const SizedBox(height: 4), // Gap between icon and text
            Text(
              label,
              style: TextStyle(
                fontSize: 12, // Text size from design spec
                fontWeight: FontWeight.w500,
                color: isActive
                    ? Colors.white
                    : (isEmergency
                          ? const Color(0xFFDC2626)
                          : const Color(0xFF717182)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
