import 'package:flutter/material.dart';
import 'package:safetravel_app/core/widgets/custom_text_field.dart';

class StepTravel extends StatelessWidget {
  const StepTravel({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Identity Documents',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Please provide either passport number or Aadhaar number for identification.',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          const CustomTextField(
            labelText: 'Passport Number',
            hintText: 'Required for international travel',
          ),
          const SizedBox(height: 16),
          const CustomTextField(
            labelText: 'Aadhaar Number',
            hintText: 'e.g., 1234 5678 9012',
          ),
          const SizedBox(height: 24),
          const Text(
            'Preferred Language for Communication *',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          const CustomTextField(
            labelText: '',
            hintText: 'English',
            isReadOnly: true,
            suffixIcon: Icon(Icons.arrow_drop_down),
          ),
          const SizedBox(height: 8),
          Text(
            'Language for emergency communications and app notifications.',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }
}
