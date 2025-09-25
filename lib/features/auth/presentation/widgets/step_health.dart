import 'package:flutter/material.dart';
import 'package:safetravel_app/core/widgets/custom_text_field.dart';

class StepHealth extends StatefulWidget {
  final Function(bool)? onConsentChanged;
  final Function(bool)? onValidationChanged;

  const StepHealth({
    super.key,
    this.onConsentChanged,
    this.onValidationChanged,
  });

  @override
  State<StepHealth> createState() => _StepHealthState();
}

class _StepHealthState extends State<StepHealth> {
  bool _consentChecked = false;

  void _validateForm() {
    // For health step, only privacy consent is required
    // Health information fields are optional
    final isValid = _consentChecked;

    if (widget.onValidationChanged != null) {
      widget.onValidationChanged!(isValid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Health & Safety Information',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Share any health conditions, medical needs, or special requirements to help us provide appropriate assistance.',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          const CustomTextField(
            labelText: 'Health Information or Medical Conditions',
            hintText:
                'List any medical conditions, allergies, medications, or health concerns...',
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          const CustomTextField(
            labelText: 'Special Assistance Requirements',
            hintText: 'Describe any special assistance you may need...',
            maxLines: 4,
          ),
          const SizedBox(height: 24),
          const Text(
            'Location Tracking & Privacy',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text(
              'I consent to real-time location tracking for safety purposes *',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'This allows our emergency response team to locate you quickly if needed. You can disable this at any time in your account settings.',
              style: TextStyle(color: Colors.grey[600]),
            ),
            value: _consentChecked,
            onChanged: (bool? value) {
              setState(() {
                _consentChecked = value ?? false;
              });
              // Notify parent about consent change
              if (widget.onConsentChanged != null) {
                widget.onConsentChanged!(_consentChecked);
              }
              // Validate form
              _validateForm();
            },
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            activeColor: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Privacy Notice',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your health information is encrypted and only accessible to authorized emergency response personnel. Location data is used solely for safety purposes and is automatically deleted after your trip unless you choose to keep it for future reference.',
                  style: TextStyle(color: Colors.grey[700], fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
