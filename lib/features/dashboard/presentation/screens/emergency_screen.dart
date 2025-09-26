import 'package:flutter/material.dart';
import '../../domain/models/emergency_contact.dart';
import '../../domain/services/emergency_service.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  bool _sosPressed = false;
  bool _isSendingSOS = false;
  List<EmergencyContact> _emergencyContacts = [];
  final EmergencyService _emergencyService = EmergencyService();

  @override
  void initState() {
    super.initState();
    _loadEmergencyContacts();
  }

  Future<void> _loadEmergencyContacts() async {
    try {
      final contacts = await _emergencyService.getSavedEmergencyContacts();
      if (mounted) {
        setState(() {
          _emergencyContacts = contacts;
        });
      }
    } catch (e) {
      print('Error loading emergency contacts: $e');
    }
  }

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
            onTap: _isSendingSOS ? null : _handleSOSPress,
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
                child: _isSendingSOS
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      )
                    : Text(
                        _sosPressed ? '🚨' : 'SOS',
                        style: TextStyle(
                          fontSize: 24, // text-2xl from design spec
                          fontWeight: FontWeight.w700, // bold
                          color: _sosPressed
                              ? const Color(0xFFDC2626)
                              : Colors.white,
                        ),
                      ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            _isSendingSOS
                ? 'Sending emergency alert...'
                : 'Press to send SOS with your location',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
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
      onTap: () => _makeEmergencyCall(context, number, serviceName),
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
                    'Saved Emergency Contacts',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (_emergencyContacts.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.contacts,
                        size: 48,
                        color: Color(0xFF6B7280),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No emergency contacts saved',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Add contacts in settings',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                )
              else
                ..._emergencyContacts.map(
                  (contact) => Column(
                    children: [
                      _buildContactItem(context, contact: contact),
                      if (contact != _emergencyContacts.last)
                        const SizedBox(height: 8),
                    ],
                  ),
                ),

              // Debug section - remove in production
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🐛 Debug Tools',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Use these buttons to test SMS and call functionality',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _debugContacts,
                            icon: const Icon(Icons.bug_report, size: 16),
                            label: const Text(
                              'Debug Contacts',
                              style: TextStyle(fontSize: 12),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _testSMS,
                            icon: const Icon(Icons.sms, size: 16),
                            label: const Text(
                              'Test SMS',
                              style: TextStyle(fontSize: 12),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context, {
    EmergencyContact? contact,
    String? name,
    String? number,
  }) {
    final contactName = contact?.name ?? name ?? '';
    final contactNumber = contact?.phoneNumber ?? number ?? '';
    final relation = contact?.relation;

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
                  contactName,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                Row(
                  children: [
                    Text(
                      contactNumber,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF6B7280), // Gray-500
                      ),
                    ),
                    if (relation != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          relation,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: const Color(0xFF2563EB),
                                fontSize: 10,
                              ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: () =>
                _makeContactCall(context, contactNumber, contactName),
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

  Future<void> _handleSOSPress() async {
    setState(() {
      _sosPressed = true;
      _isSendingSOS = true;
    });

    try {
      // Send SOS message to emergency contacts
      final success = await _emergencyService.sendSOSMessage();

      if (mounted) {
        if (success) {
          _showEmergencyAlert(
            title: 'SOS Alert Sent!',
            message:
                'Emergency message with your location has been sent to all saved contacts.',
            isSuccess: true,
          );
        } else {
          _showEmergencyAlert(
            title: 'SOS Failed',
            message:
                'Failed to send SOS message. Please ensure you have emergency contacts saved and SMS permissions are granted.',
            isSuccess: false,
          );
        }
      }
    } catch (e) {
      print('Error sending SOS: $e');
      if (mounted) {
        _showEmergencyAlert(
          title: 'SOS Error',
          message:
              'An error occurred while sending SOS. Please try again or contact emergency services directly.',
          isSuccess: false,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSendingSOS = false;
        });

        // Auto-reset SOS button after 5 seconds
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) {
            setState(() {
              _sosPressed = false;
            });
          }
        });
      }
    }
  }

  Future<void> _makeEmergencyCall(
    BuildContext context,
    String phoneNumber,
    String serviceName,
  ) async {
    try {
      final success = await _emergencyService.makePhoneCall(phoneNumber);

      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Unable to call $serviceName. Please dial $phoneNumber manually.',
            ),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      print('Error making emergency call: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error calling $serviceName. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _makeContactCall(
    BuildContext context,
    String phoneNumber,
    String contactName,
  ) async {
    try {
      final success = await _emergencyService.makePhoneCall(phoneNumber);

      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Unable to call $contactName. Please dial $phoneNumber manually.',
            ),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      print('Error making contact call: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error calling $contactName. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showEmergencyAlert({
    required String title,
    required String message,
    required bool isSuccess,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: isSuccess ? Colors.green : Colors.red,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          if (!isSuccess)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _makeEmergencyCall(context, '112', 'Emergency Services');
              },
              child: const Text('Call 112'),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Debug methods for testing
  Future<void> _debugContacts() async {
    print('=== DEBUG BUTTON PRESSED ===');
    await _emergencyService.debugSavedContacts();
  }

  Future<void> _testSMS() async {
    print('=== TEST SMS BUTTON PRESSED ===');
    try {
      final success = await _emergencyService.sendSOSMessage();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'SMS test completed' : 'SMS test failed'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error in SMS test: $e');
    }
  }
}
