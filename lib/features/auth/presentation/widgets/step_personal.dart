import 'package:flutter/material.dart';
import 'package:safetravel_app/core/widgets/custom_text_field.dart';

class StepPersonal extends StatelessWidget {
  const StepPersonal({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal Information',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Please provide your personal details for identity verification and safety purposes.',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          const CustomTextField(
            labelText: 'Full Name *',
            hintText: 'Enter your full name as on passport',
          ),
          const SizedBox(height: 16),
          const CustomTextField(
            labelText: 'Date of Birth *',
            hintText: 'DD/MM/YYYY',
            isReadOnly: true, // Should open a date picker
            suffixIcon: Icon(Icons.calendar_today_outlined),
          ),
          const SizedBox(height: 16),
          const CustomTextField(
            labelText: 'Nationality *',
            hintText: 'Select your nationality',
            isReadOnly: true, // Should open a dropdown/selector
            suffixIcon: Icon(Icons.arrow_drop_down),
          ),
          const SizedBox(height: 16),
          const CustomTextField(
            labelText: 'Gender *',
            hintText: 'Select gender',
            isReadOnly: true, // Should open a dropdown/selector
            suffixIcon: Icon(Icons.arrow_drop_down),
          ),
        ],
      ),
    );
  }
}
