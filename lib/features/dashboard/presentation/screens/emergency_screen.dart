import 'package:flutter/material.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  bool _sosPressed = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // SOS Section
          _buildSOSSection(context),

          // Emergency Services Grid
          _buildEmergencyServices(context),

          // Local Emergency Contacts
          _buildLocalContacts(context),
        ],
      ),
    );
  }

  Widget _buildSOSSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFDC2626), // Red-500
            Color(0xFFB91C1C), // Red-600
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // SOS Button (144px diameter from design spec)
          GestureDetector(
            onTap: _handleSOSPress,
            child: Container(
              width: 144, // w-36 from design spec
              height: 144, // h-36 from design spec
              decoration: BoxDecoration(
                color: _sosPressed
                    ? Colors.white
                    : const Color(0xFF991B1B), // Red-700
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 10),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _sosPressed ? '🚨' : 'SOS',
                  style: TextStyle(
                    fontSize: 24, // text-2xl from design spec
                    fontWeight: FontWeight.w700, // bold
                    color: _sosPressed ? const Color(0xFFDC2626) : Colors.white,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Press for emergency assistance',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Location Share Button
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: TextButton.icon(
              onPressed: _shareLocation,
              icon: const Icon(
                Icons.share_location,
                size: 16,
                color: Colors.white,
              ),
              label: Text(
                'Share Location',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEmergencyServices(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Emergency Services',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          // Grid of emergency services (2 columns)
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildServiceCard(
                context,
                icon: Icons.local_police,
                serviceName: 'Police',
                number: '100',
                color: const Color(0xFF2563EB), // Blue-600
              ),
              _buildServiceCard(
                context,
                icon: Icons.medical_services,
                serviceName: 'Ambulance',
                number: '108',
                color: const Color(0xFFDC2626), // Red-600
              ),
              _buildServiceCard(
                context,
                icon: Icons.local_fire_department,
                serviceName: 'Fire',
                number: '101',
                color: const Color(0xFFEA580C), // Orange-600
              ),
              _buildServiceCard(
                context,
                icon: Icons.woman,
                serviceName: 'Women Safety',
                number: '1091',
                color: const Color(0xFF9333EA), // Purple-600
              ),
              _buildServiceCard(
                context,
                icon: Icons.tour,
                serviceName: 'Tourist Helpline',
                number: '1363',
                color: const Color(0xFF16A34A), // Green-600
              ),
              _buildServiceCard(
                context,
                icon: Icons.phone,
                serviceName: 'General Help',
                number: '112',
                color: const Color(0xFF6B7280), // Gray-500
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required IconData icon,
    required String serviceName,
    required String number,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () => _makeCall(context, number),
      child: Container(
        height: 96, // h-24 from design spec
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12), // rounded-xl
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 4),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24, // Icon size from design spec
              color: Colors.white,
            ),
            const SizedBox(height: 4),
            Text(
              serviceName,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              number,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(
                  0.9,
                ), // 90% opacity from design spec
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocalContacts(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.phone, size: 16, color: Color(0xFF030213)),
                  const SizedBox(width: 8),
                  Text(
                    'Local Emergency Contacts',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildContactItem(
                context,
                name: 'Guwahati Police Control Room',
                number: '+91-361-2540048',
              ),
              const SizedBox(height: 8),
              _buildContactItem(
                context,
                name: 'Assam Tourism Helpline',
                number: '+91-361-2347102',
              ),
              const SizedBox(height: 8),
              _buildContactItem(
                context,
                name: 'GMCH Emergency',
                number: '+91-361-2570145',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context, {
    required String name,
    required String number,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB), // Gray-50
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                Text(
                  number,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF6B7280), // Gray-500
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: () => _makeCall(context, number),
            icon: const Icon(Icons.phone, size: 12),
            label: const Text('Call'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSOSPress() {
    setState(() {
      _sosPressed = true;
    });

    // Auto-reset after 5 seconds (from design spec)
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _sosPressed = false;
        });
      }
    });

    // Show emergency alert
    _showEmergencyAlert();
  }

  void _shareLocation() {
    // Show location shared notification (from design spec)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Location shared with emergency contacts'),
        backgroundColor: Color(0xFF16A34A),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showEmergencyAlert() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Alert Activated'),
        content: const Text(
          'Your emergency contacts have been notified. Emergency services will be contacted if needed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _makeCall(BuildContext context, String phoneNumber) {
    // Show calling dialog instead of actual phone call
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Calling $phoneNumber'),
        content: Text('In a real app, this would dial $phoneNumber'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
