import 'package:flutter/material.dart';
import 'package:safetravel_app/core/widgets/custom_text_field.dart';

class StepEmergency extends StatelessWidget {
  const StepEmergency({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Emergency Contacts',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Provide at least two emergency contacts who can be reached in case of an emergency.',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          const Text(
            'Emergency Contact 1',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const CustomTextField(labelText: 'Full Name *'),
          const SizedBox(height: 16),
          const CustomTextField(
            labelText: 'Relationship *',
            isReadOnly: true,
            suffixIcon: Icon(Icons.arrow_drop_down),
          ),
          const SizedBox(height: 16),
          const CustomTextField(
            labelText: 'Phone Number *',
            hintText: 'Include country code',
          ),
          const SizedBox(height: 16),
          const CustomTextField(labelText: 'Email Address'),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Add Emergency Contact'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              foregroundColor: Theme.of(context).primaryColor,
              side: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ],
      ),
    );
  }
}
