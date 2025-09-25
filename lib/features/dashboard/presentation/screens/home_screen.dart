import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

          // Emergency Services Quick Access
          _buildEmergencyServicesWidget(context),

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

  Widget _buildEmergencyServicesWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(
                Icons.local_hospital,
                color: Color(0xFFDC2626), // Emergency red
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Emergency Services',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF030213),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Buttons Row
          Row(
            children: [
              // Hospital Button
              Expanded(
                child: _buildEmergencyButton(
                  context,
                  icon: Icons.local_hospital,
                  label: 'Hospital',
                  color: const Color(0xFFDC2626), // Emergency red
                  onPressed: () =>
                      _handleEmergencyButtonPress(context, 'hospital'),
                ),
              ),

              const SizedBox(width: 12),

              // Police Station Button
              Expanded(
                child: _buildEmergencyButton(
                  context,
                  icon: Icons.local_police,
                  label: 'Police station',
                  color: const Color(0xFF2563EB), // Blue
                  onPressed: () =>
                      _handleEmergencyButtonPress(context, 'police'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Future<void> _handleEmergencyButtonPress(
    BuildContext context,
    String type,
  ) async {
    print('Emergency button pressed: $type');

    // Show immediate feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Opening ${type == 'hospital' ? 'Hospital' : 'Police Station'} locations...',
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: type == 'hospital'
            ? const Color(0xFFDC2626)
            : const Color(0xFF2563EB),
        action: SnackBarAction(
          label: 'Cancel',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );

    try {
      // Open Google Maps
      await _openGoogleMaps(type);
    } catch (e) {
      print('Error in _handleEmergencyButtonPress: $e');

      // Show error feedback - check if context is still valid
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to open maps app. Error: $e'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openGoogleMaps(String type) async {
    String query;

    switch (type) {
      case 'hospital':
        query = 'hospital';
        break;
      case 'police':
        query = 'police station';
        break;
      default:
        query = 'emergency services';
    }

    // For Android virtual devices, we need to use specific URL schemes
    final List<Uri> urlsToTry = [
      // Try Google Maps app with specific package intent (Android)
      Uri.parse('https://maps.google.com/maps?q=$query+near+me'),
      // Try geo scheme (should work on emulator)
      Uri.parse('geo:0,0?q=$query+near+me'),
      // Try Google Maps with navigation scheme
      Uri.parse('google.navigation:q=$query+near+me'),
      // Fallback to web version
      Uri.parse('https://www.google.com/maps/search/$query+near+me'),
    ];

    bool opened = false;

    // Try each URL scheme until one works
    for (int i = 0; i < urlsToTry.length; i++) {
      final url = urlsToTry[i];
      try {
        print('Trying URL $i: $url');

        if (await canLaunchUrl(url)) {
          print('URL $i can be launched, attempting to launch...');

          final result = await launchUrl(
            url,
            mode: LaunchMode.externalApplication,
          );

          if (result) {
            print('Successfully launched URL $i');
            opened = true;
            break;
          } else {
            print(
              'Failed to launch URL $i despite canLaunchUrl returning true',
            );
          }
        } else {
          print('URL $i cannot be launched');
        }
      } catch (e) {
        print('Error with URL $i: $e');
        continue;
      }
    }

    if (!opened) {
      print(
        'Could not launch any Google Maps URL for $type - all attempts failed',
      );
      // Try one more time with a direct intent-based approach for Android
      try {
        final androidIntent = Uri.parse(
          'intent://maps.google.com/maps?q=$query+near+me#Intent;scheme=https;package=com.google.android.apps.maps;end',
        );
        if (await canLaunchUrl(androidIntent)) {
          await launchUrl(androidIntent, mode: LaunchMode.externalApplication);
          opened = true;
        }
      } catch (e) {
        print('Android intent approach also failed: $e');
      }
    }

    if (!opened) {
      print('All Google Maps launch attempts failed for $type');
    }
  }
}
