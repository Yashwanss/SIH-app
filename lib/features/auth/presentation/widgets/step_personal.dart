import 'package:flutter/material.dart';
import 'package:safetravel_app/core/widgets/custom_text_field.dart';
import 'package:intl/intl.dart'; // Add intl package to pubspec.yaml for date formatting

class StepPersonal extends StatefulWidget {
  final Function(bool)? onValidationChanged;

  const StepPersonal({super.key, this.onValidationChanged});

  @override
  State<StepPersonal> createState() => _StepPersonalState();
}

class _StepPersonalState extends State<StepPersonal> {
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String? _selectedNationality;
  String? _selectedGender;

  // In a real app, this list would be more comprehensive
  final List<String> _nationalities = [
    'United States',
    'Canada',
    'India',
    'United Kingdom',
    'Australia',
    'France',
    'Germany',
  ];
  final List<String> _genders = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
    // 'Unicorn 🦄',
  ];

  @override
  void dispose() {
    _dobController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final isValid =
        _nameController.text.trim().isNotEmpty &&
        _dobController.text.trim().isNotEmpty &&
        _selectedNationality != null &&
        _selectedGender != null;

    if (widget.onValidationChanged != null) {
      widget.onValidationChanged!(isValid);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
      _validateForm();
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
            'Personal Information',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Please provide your personal details for identity verification and safety purposes.',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _nameController,
            onChanged: (_) => _validateForm(),
            decoration: InputDecoration(
              labelText: 'Full Name *',
              hintText: 'Enter your full name as on passport',
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
          CustomTextField(
            controller: _dobController,
            labelText: 'Date of Birth *',
            hintText: 'DD/MM/YYYY',
            isReadOnly: true,
            onTap: () => _selectDate(context),
            suffixIcon: const Icon(Icons.calendar_today_outlined),
          ),
          const SizedBox(height: 16),

          // Nationality Dropdown
          const Text(
            'Nationality *',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _selectedNationality,
            hint: const Text('Select your nationality'),
            decoration: const InputDecoration(),
            items: _nationalities.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedNationality = newValue;
              });
              _validateForm();
            },
          ),

          const SizedBox(height: 16),

          // Gender Dropdown
          const Text(
            'Gender *',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _selectedGender,
            hint: const Text('Select gender'),
            decoration: const InputDecoration(),
            items: _genders.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedGender = newValue;
              });
              _validateForm();
            },
          ),
        ],
      ),
    );
  }
}
