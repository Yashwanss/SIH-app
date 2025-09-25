import 'package:flutter/material.dart';

class EmergencyContact {
  String? fullName;
  String? relationship;
  String? phoneNumber;
  String? emailAddress;

  EmergencyContact({
    this.fullName,
    this.relationship,
    this.phoneNumber,
    this.emailAddress,
  });
}

class StepEmergency extends StatefulWidget {
  const StepEmergency({super.key});

  @override
  State<StepEmergency> createState() => _StepEmergencyState();
}

class _StepEmergencyState extends State<StepEmergency> {
  List<EmergencyContact> emergencyContacts = [EmergencyContact()];

  final List<String> relationships = [
    'Parent',
    'Spouse',
    'Sibling',
    'Child',
    'Grandparent',
    'Friend',
    'Colleague',
    'Other Family Member',
    'Guardian',
    'Partner',
  ];

  void _addEmergencyContact() {
    if (emergencyContacts.length < 5) {
      // Limit to 5 contacts
      setState(() {
        emergencyContacts.add(EmergencyContact());
      });
    }
  }

  void _removeEmergencyContact(int index) {
    if (emergencyContacts.length > 1) {
      // Keep at least one contact
      setState(() {
        emergencyContacts.removeAt(index);
      });
    }
  }

  Widget _buildEmergencyContactForm(int index) {
    final contact = emergencyContacts[index];
    final contactNumber = index + 1;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Emergency Contact $contactNumber',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (emergencyContacts.length > 1)
                IconButton(
                  onPressed: () => _removeEmergencyContact(index),
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: Colors.red,
                  ),
                  tooltip: 'Remove Contact',
                ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            onChanged: (value) {
              contact.fullName = value;
            },
            decoration: InputDecoration(
              labelText: 'Full Name *',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Relationship Dropdown
          DropdownButtonFormField<String>(
            initialValue: contact.relationship,
            hint: const Text('Select Relationship *'),
            items: relationships.map((String relationship) {
              return DropdownMenuItem<String>(
                value: relationship,
                child: Text(relationship),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                contact.relationship = newValue;
              });
            },
            decoration: InputDecoration(
              labelText: 'Relationship *',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Phone Number with +91 prefix
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                  color: Colors.grey.shade50,
                ),
                child: const Text(
                  '+91',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    contact.phoneNumber = '+91$value';
                  },
                  decoration: InputDecoration(
                    labelText: 'Phone Number *',
                    hintText: '987654XXXX',
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              contact.emailAddress = value;
            },
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: 'example@email.com',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
          ...emergencyContacts.asMap().entries.map((entry) {
            return _buildEmergencyContactForm(entry.key);
          }),
          const SizedBox(height: 16),
          if (emergencyContacts.length < 5)
            OutlinedButton.icon(
              onPressed: _addEmergencyContact,
              icon: const Icon(Icons.add),
              label: const Text('Add Emergency Contact'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                foregroundColor: Theme.of(context).primaryColor,
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          if (emergencyContacts.length >= 5)
            Text(
              'Maximum 5 emergency contacts allowed',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          const SizedBox(height: 16),
          Text(
            'At least one emergency contact is required. We recommend adding at least two contacts.',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }
}
