import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Weather Alert (56px height from design spec)
          _buildWeatherAlert(context),

          // Map Section (288px height from design spec)
          _buildMapSection(context),

          // Points of Interest Section
          _buildPOISection(context),
        ],
      ),
    );
  }

  Widget _buildWeatherAlert(BuildContext context) {
    return Container(
      height: 56, // Weather alert height from design spec
      width: double.infinity,
      color: const Color(0xFFFEF3C7), // Yellow-100 background
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            const Icon(
              Icons.warning,
              size: 20,
              color: Color(0xFFCA8A04), // Yellow-600
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Heavy rain expected. Plan your travel accordingly.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFFCA8A04), // Yellow-600
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection(BuildContext context) {
    return Container(
      height: 288, // Map section height from design spec
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFDCFCE7), // Green-100 background
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF16A34A), // Green-600
            width: 2,
          ),
        ),
      ),
      child: Stack(
        children: [
          // User Location Indicator (centered)
          Center(
            child: Container(
              width: 64, // User location indicator diameter
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(
                      Icons.location_pin,
                      size: 32, // Map icon size from design spec
                      color: Color(0xFFDC2626), // Red-500
                    ),
                  ),
                  // Pulse Indicator
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2563EB), // Blue-500
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Offline Badge (top-right)
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF16A34A), // Green-600
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.wifi_off, size: 12, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    'Offline',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Location Info Card (bottom)
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Guwahati, Assam',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Last updated: 2 minutes ago',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF6B7280), // Gray-500
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPOISection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16), // Content padding from design spec
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              const Icon(Icons.navigation, size: 20, color: Color(0xFF030213)),
              const SizedBox(width: 8),
              Text(
                'Nearby POIs',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // POI Cards
          _buildPOICard(
            context,
            icon: Icons.restaurant,
            title: 'Traditional Assamese Restaurant',
            subtitle: '0.5 km • 4.5 ⭐',
            iconColor: const Color(0xFF2563EB), // Blue-600
            iconBackground: const Color(0xFFDBEAFE), // Blue-100
          ),
          const SizedBox(height: 12),

          _buildPOICard(
            context,
            icon: Icons.local_hospital,
            title: 'Guwahati Medical College',
            subtitle: '1.2 km • Hospital',
            iconColor: const Color(0xFFDC2626), // Red-600
            iconBackground: const Color(0xFFFEE2E2), // Red-100
          ),
          const SizedBox(height: 12),

          _buildPOICard(
            context,
            icon: Icons.temple_buddhist,
            title: 'Kamakhya Temple',
            subtitle: '5.8 km • Heritage Site',
            iconColor: const Color(0xFF9333EA), // Purple-600
            iconBackground: const Color(0xFFF3E8FF), // Purple-100
          ),
        ],
      ),
    );
  }

  Widget _buildPOICard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required Color iconBackground,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x1A000000)), // 10% Black border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Container (64px total width including margin)
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 12),

          // Content (Flex-1)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF6B7280), // Gray-500
                  ),
                ),
              ],
            ),
          ),

          // Action Button (80px width)
          SizedBox(
            width: 80,
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: Implement navigation
              },
              icon: const Icon(Icons.navigation, size: 12),
              label: const Text('Go', style: TextStyle(fontSize: 12)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
