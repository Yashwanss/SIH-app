import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:safetravel_app/core/constants/api_constants.dart';

class StepTravel extends StatefulWidget {
  final Function(bool)? onValidationChanged;

  const StepTravel({super.key, this.onValidationChanged});

  @override
  State<StepTravel> createState() => _StepTravelState();
}

class _StepTravelState extends State<StepTravel> {
  String? _selectedLanguage = 'English';
  final TextEditingController _stayingAtController = TextEditingController();
  final TextEditingController _passportController = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();

  final List<String> _languages = [
    'English',
    'Hindi',
    'Spanish',
    'French',
    'German',
    'Mandarin',
    'Japanese',
    'Russian',
    'Arabic',
  ];

  @override
  void dispose() {
    _stayingAtController.dispose();
    _passportController.dispose();
    _aadhaarController.dispose();
    super.dispose();
  }

  void _validateForm() {
    // At least one identity document is required (passport OR aadhaar)
    final hasIdentityDoc =
        _passportController.text.trim().isNotEmpty ||
        _aadhaarController.text.trim().isNotEmpty;

    // Language must be selected (but we have a default value, so this is always valid)
    final hasLanguage = _selectedLanguage != null;

    final isValid = hasIdentityDoc && hasLanguage;

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
            'Identity Documents',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Please provide either passport number or Aadhaar number for identification.',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _passportController,
            onChanged: (_) => _validateForm(),
            decoration: InputDecoration(
              labelText: 'Passport Number',
              hintText: 'Required for international travel',
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
          TextFormField(
            controller: _aadhaarController,
            onChanged: (_) => _validateForm(),
            decoration: InputDecoration(
              labelText: 'Aadhaar Number',
              hintText: 'e.g., 1234 5678 9012',
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
          const SizedBox(height: 24),
          const Text(
            'Accommodation Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Let us know where you\'ll be staying during your travel.',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          GooglePlaceAutoCompleteTextField(
            textEditingController: _stayingAtController,
            googleAPIKey: ApiConstants.googlePlacesApiKey,
            inputDecoration: InputDecoration(
              labelText: 'Where are you staying at? *',
              hintText: 'Search for hotels, addresses, landmarks...',
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
              prefixIcon: const Icon(Icons.location_on),
            ),
            debounceTime: 800,
            countries: const [
              "in",
            ], // Restrict to India, remove this line for worldwide search
            isLatLngRequired: true,
            getPlaceDetailWithLatLng: (Prediction prediction) {
              print("Place Details - ${prediction.description}");
              print("Lat: ${prediction.lat}, Lng: ${prediction.lng}");
            },
            itemClick: (Prediction prediction) {
              _stayingAtController.text = prediction.description!;
              _stayingAtController.selection = TextSelection.fromPosition(
                TextPosition(offset: prediction.description!.length),
              );
            },
            seperatedBuilder: const Divider(height: 1),
            containerHorizontalPadding: 16,
            itemBuilder: (context, index, Prediction prediction) {
              return Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.grey),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        prediction.description ?? "",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              );
            },
            isCrossBtnShown: true,
          ),
          const SizedBox(height: 8),
          Text(
            'This helps us provide location-specific safety information and emergency services.',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
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
          DropdownButtonFormField<String>(
            initialValue: _selectedLanguage,
            items: _languages.map((String language) {
              return DropdownMenuItem<String>(
                value: language,
                child: Text(language),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedLanguage = newValue;
              });
              _validateForm();
            },
            decoration: InputDecoration(
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
