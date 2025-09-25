import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String selectedLanguage = 'English';
  bool emergencyAlertsEnabled = true;
  bool locationSharingEnabled = true;
  bool sosButtonEnabled = true;
  bool womenSafetyFeaturesEnabled = false;
  bool emergencyContactsEnabled = true;

  final List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English', 'native': 'English'},
    {'code': 'as', 'name': 'Assamese', 'native': 'অসমীয়া'},
    {'code': 'hi', 'name': 'Hindi', 'native': 'हिन्दी'},
    {'code': 'bn', 'name': 'Bengali', 'native': 'বাংলা'},
    {'code': 'te', 'name': 'Telugu', 'native': 'తెలుగు'},
    {'code': 'ta', 'name': 'Tamil', 'native': 'தமிழ்'},
    {'code': 'mr', 'name': 'Marathi', 'native': 'मराठी'},
    {'code': 'gu', 'name': 'Gujarati', 'native': 'ગુજરાતી'},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Card
          _buildProfileCard(context),

          const SizedBox(height: 16),

          // Language Settings
          _buildLanguageSettings(context),

          const SizedBox(height: 16),

          // Safety Settings
          _buildSafetySettings(context),

          const SizedBox(height: 16),

          // Women's Safety Section
          _buildWomensSafetySection(context),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16), // Content padding from design spec
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24), // Card padding from design spec
          child: Row(
            children: [
              // Avatar (64px from design spec)
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFDBEAFE), // Blue-100
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'JD',
                    style: TextStyle(
                      color: Color(0xFF2563EB), // Blue-600
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // User Info (Flex-1)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_pin,
                          size: 12,
                          color: Color(0xFF6B7280), // Gray-500
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Guwahati, Assam',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: const Color(0xFF6B7280), // Gray-500
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.email,
                          size: 16,
                          color: Color(0xFF6B7280), // Gray-500
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'john.doe@example.com',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: const Color(0xFF6B7280), // Gray-500
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          size: 16,
                          color: Color(0xFF6B7280), // Gray-500
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '+91 98765 43210',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: const Color(0xFF6B7280), // Gray-500
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Edit Button (80px width from design spec)
              SizedBox(
                width: 80,
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: Implement edit profile
                  },
                  child: const Text('Edit', style: TextStyle(fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSettings(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Header
              Row(
                children: [
                  const Icon(
                    Icons.language,
                    size: 16,
                    color: Color(0xFF030213),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Language Settings',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Language Selector
              Row(
                children: [
                  Text(
                    'App Language:',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 128, // Select width from design spec
                    child: DropdownButtonFormField<String>(
                      initialValue: selectedLanguage,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      items: languages
                          .map(
                            (language) => DropdownMenuItem(
                              value: language['name'],
                              child: Text(
                                language['native']!,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedLanguage = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSafetySettings(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Header
              Row(
                children: [
                  const Icon(
                    Icons.security,
                    size: 16,
                    color: Color(0xFF030213),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Safety Settings',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Safety Toggle Items
              _buildToggleItem(
                context,
                'Emergency Alerts',
                'Receive emergency notifications',
                emergencyAlertsEnabled,
                (value) => setState(() => emergencyAlertsEnabled = value),
                isEnabled: true,
              ),
              _buildToggleItem(
                context,
                'Location Sharing',
                'Share location with emergency contacts',
                locationSharingEnabled,
                (value) => setState(() => locationSharingEnabled = value),
                isEnabled: true,
              ),
              _buildToggleItem(
                context,
                'SOS Button',
                'Enable quick access SOS button',
                sosButtonEnabled,
                (value) => setState(() => sosButtonEnabled = value),
                isEnabled: true,
              ),
              _buildToggleItem(
                context,
                'Emergency Contacts',
                'Auto-notify contacts in emergency',
                emergencyContactsEnabled,
                (value) => setState(() => emergencyContactsEnabled = value),
                isEnabled: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWomensSafetySection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFFE879F9)), // Purple-300 border
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Header
              Row(
                children: [
                  const Icon(
                    Icons.woman,
                    size: 16,
                    color: Color(0xFF7C3AED), // Purple-700
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Women\'s Safety Features',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF7C3AED), // Purple-700
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Women's Safety Toggle Items with purple background
              Container(
                padding: const EdgeInsets.all(12), // Padding from design spec
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF4FF), // Purple-50
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _buildToggleItem(
                      context,
                      'Women\'s Safety Mode',
                      'Enhanced safety features for women',
                      womenSafetyFeaturesEnabled,
                      (value) =>
                          setState(() => womenSafetyFeaturesEnabled = value),
                      backgroundColor: const Color(0xFFFDF4FF), // Purple-50
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

  Widget _buildToggleItem(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged, {
    bool isEnabled = true,
    Color? backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: backgroundColor,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF6B7280), // Gray-500
                  ),
                ),
              ],
            ),
          ),

          // Badge for enabled features
          if (isEnabled && value)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFD1FAE5), // Green-100
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Active',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF065F46), // Green-700
                  fontSize: 10,
                ),
              ),
            ),

          // Switch
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF030213), // Primary color
          ),
        ],
      ),
    );
  }
}
