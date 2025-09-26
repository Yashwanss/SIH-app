import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:latlong2/latlong.dart';
import '../models/emergency_contact.dart';

class EmergencyService {
  static const String _contactsKey = 'emergency_contacts';

  // Singleton pattern
  static EmergencyService? _instance;
  factory EmergencyService() {
    _instance ??= EmergencyService._internal();
    return _instance!;
  }
  EmergencyService._internal();

  /// Get current location with fallback to last known location
  Future<LatLng> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return await _getLastKnownLocation();
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return await _getLastKnownLocation();
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return await _getLastKnownLocation();
      }

      // Get current position with timeout
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      final location = LatLng(position.latitude, position.longitude);
      await _saveLastKnownLocation(location);
      return location;
    } catch (e) {
      print('Error getting current location: $e');
      return await _getLastKnownLocation();
    }
  }

  /// Save location to shared preferences
  Future<void> _saveLastKnownLocation(LatLng location) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('last_lat', location.latitude);
      await prefs.setDouble('last_lng', location.longitude);
      await prefs.setInt(
        'last_location_time',
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      print('Error saving location: $e');
    }
  }

  /// Get last known location from shared preferences
  Future<LatLng> _getLastKnownLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lat = prefs.getDouble('last_lat');
      final lng = prefs.getDouble('last_lng');

      if (lat != null && lng != null) {
        return LatLng(lat, lng);
      }
    } catch (e) {
      print('Error getting last known location: $e');
    }

    // Default location (Guwahati) if no stored location
    return LatLng(26.1445, 91.7362);
  }

  /// Send SOS SMS to all emergency contacts using URL schemes
  Future<bool> sendSOSMessage() async {
    try {
      // Get current or last known location
      final location = await getCurrentLocation();
      final contacts = await getSavedEmergencyContacts();

      if (contacts.isEmpty) {
        print('No emergency contacts found');
        return false;
      }

      // Create SOS message with location
      final String message = _createSOSMessage(location);

      // Send SMS to all contacts using URL schemes
      bool allSent = true;
      for (final contact in contacts) {
        try {
          final phoneNumber = contact.phoneNumber;
          if (phoneNumber != null && phoneNumber.isNotEmpty) {
            final cleanedNumber = _cleanPhoneNumber(phoneNumber);
            final success = await _sendSMSViaURL(cleanedNumber, message);
            if (success) {
              print(
                'SOS SMS intent opened for ${contact.name}: $cleanedNumber',
              );
            } else {
              print('Failed to open SMS for ${contact.name}: $cleanedNumber');
              allSent = false;
            }
          } else {
            print('No phone number for contact: ${contact.name}');
            allSent = false;
          }
        } catch (e) {
          print('Failed to send SMS to ${contact.name}: $e');
          allSent = false;
        }
      }

      return allSent;
    } catch (e) {
      print('Error sending SOS message: $e');
      return false;
    }
  }

  /// Send SMS using URL scheme (opens SMS app with pre-filled message)
  Future<bool> _sendSMSViaURL(String phoneNumber, String message) async {
    try {
      print('Attempting to send SMS to: $phoneNumber');

      // Try multiple SMS URI formats for better compatibility
      final String encodedMessage = Uri.encodeComponent(message);

      // Format 1: Standard SMS scheme with body parameter
      List<Uri> smsUris = [
        Uri.parse('sms:$phoneNumber?body=$encodedMessage'),
        Uri.parse('smsto:$phoneNumber?body=$encodedMessage'),
        Uri.parse('sms:$phoneNumber&body=$encodedMessage'),
        Uri(
          scheme: 'sms',
          path: phoneNumber,
          queryParameters: {'body': message},
        ),
      ];

      for (int i = 0; i < smsUris.length; i++) {
        final smsUri = smsUris[i];
        print('Trying SMS format ${i + 1}: $smsUri');

        try {
          if (await canLaunchUrl(smsUri)) {
            final success = await launchUrl(
              smsUri,
              mode: LaunchMode.externalApplication,
            );
            print('SMS launch result (format ${i + 1}): $success');
            return true;
          }
        } catch (e) {
          print('Failed SMS format ${i + 1}: $e');
          continue;
        }
      }

      print('All SMS formats failed for: $phoneNumber');
      return false;
    } catch (e) {
      print('Error opening SMS app: $e');
      return false;
    }
  }

  /// Create SOS message with location
  String _createSOSMessage(LatLng location) {
    final String mapsUrl =
        'https://maps.google.com/maps?q=${location.latitude},${location.longitude}';

    return '''🚨 EMERGENCY ALERT 🚨

I need help! This is an automated SOS message from SafeTravel app.

My location:
Latitude: ${location.latitude.toStringAsFixed(6)}
Longitude: ${location.longitude.toStringAsFixed(6)}

View on map: $mapsUrl

Please contact me or call emergency services if needed.

- Sent automatically by SafeTravel App''';
  }

  /// Make phone call using url_launcher
  Future<bool> makePhoneCall(String phoneNumber) async {
    try {
      final String cleanedNumber = _cleanPhoneNumber(phoneNumber);

      final Uri phoneUri = Uri.parse('tel:$cleanedNumber');

      print('Attempting to call: $cleanedNumber');
      print('Phone URI: $phoneUri');

      if (await canLaunchUrl(phoneUri)) {
        final success = await launchUrl(
          phoneUri,
          mode: LaunchMode.externalApplication,
        );
        print('Phone launch result: $success');
        return true;
      } else {
        print('Cannot launch phone dialer for: $cleanedNumber');
        return false;
      }
    } catch (e) {
      print('Error making phone call: $e');
      return false;
    }
  }

  /// Save emergency contacts to shared preferences
  Future<void> saveEmergencyContacts(List<EmergencyContact> contacts) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> contactsJson = contacts
          .map((contact) => json.encode(contact.toJson()))
          .toList();

      await prefs.setStringList(_contactsKey, contactsJson);
      print('Emergency contacts saved: ${contacts.length} contacts');
    } catch (e) {
      print('Error saving emergency contacts: $e');
    }
  }

  /// Get saved emergency contacts from shared preferences
  Future<List<EmergencyContact>> getSavedEmergencyContacts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? contactsJson = prefs.getStringList(_contactsKey);

      if (contactsJson != null && contactsJson.isNotEmpty) {
        return contactsJson
            .map(
              (contactString) =>
                  EmergencyContact.fromJson(json.decode(contactString)),
            )
            .where((contact) => contact.isValid()) // Only return valid contacts
            .toList();
      }
    } catch (e) {
      print('Error loading emergency contacts: $e');
    }

    // Return empty list if no contacts found
    return [];
  }

  /// Save emergency contacts from registration step
  Future<void> saveEmergencyContactsFromRegistration(
    List<dynamic> registrationContacts,
  ) async {
    try {
      final List<EmergencyContact> contacts = [];

      for (var i = 0; i < registrationContacts.length; i++) {
        final regContact = registrationContacts[i];

        // Check if it's the EmergencyContact from step_emergency.dart
        if (regContact != null) {
          final contact = EmergencyContact.fromRegistrationData(
            id: DateTime.now().millisecondsSinceEpoch.toString() + '_$i',
            fullName: _getContactProperty(regContact, 'fullName'),
            relationship: _getContactProperty(regContact, 'relationship'),
            phoneNumber: _getContactProperty(regContact, 'phoneNumber'),
            emailAddress: _getContactProperty(regContact, 'emailAddress'),
          );

          if (contact.isValid()) {
            contacts.add(contact);
          }
        }
      }

      await saveEmergencyContacts(contacts);
      print('Saved ${contacts.length} emergency contacts from registration');
    } catch (e) {
      print('Error saving contacts from registration: $e');
    }
  }

  /// Helper method to extract properties from different contact object types
  String? _getContactProperty(dynamic contact, String propertyName) {
    try {
      if (contact is Map<String, dynamic>) {
        return contact[propertyName]?.toString();
      } else {
        // Use reflection-like approach for objects
        switch (propertyName) {
          case 'fullName':
            return contact.fullName?.toString();
          case 'relationship':
            return contact.relationship?.toString();
          case 'phoneNumber':
            return contact.phoneNumber?.toString();
          case 'emailAddress':
            return contact.emailAddress?.toString();
          default:
            return null;
        }
      }
    } catch (e) {
      print('Error extracting property $propertyName: $e');
      return null;
    }
  }

  /// Add a new emergency contact
  Future<void> addEmergencyContact(EmergencyContact contact) async {
    final contacts = await getSavedEmergencyContacts();
    contacts.add(contact);
    await saveEmergencyContacts(contacts);
  }

  /// Remove an emergency contact
  Future<void> removeEmergencyContact(String contactId) async {
    final contacts = await getSavedEmergencyContacts();
    contacts.removeWhere((contact) => contact.id == contactId);
    await saveEmergencyContacts(contacts);
  }

  /// Debug method to test saved contacts and phone number formatting
  Future<void> debugSavedContacts() async {
    print('=== DEBUG: Saved Emergency Contacts ===');
    try {
      final contacts = await getSavedEmergencyContacts();
      print('Found ${contacts.length} saved contacts:');

      for (int i = 0; i < contacts.length; i++) {
        final contact = contacts[i];
        print('Contact ${i + 1}:');
        print('  Name: ${contact.name}');
        print('  Relation: ${contact.relation}');
        print('  Phone (raw): "${contact.phoneNumber}"');
        print(
          '  Phone (cleaned): "${_cleanPhoneNumber(contact.phoneNumber ?? "")}"',
        );
        print('  Valid: ${contact.isValid()}');
        print('---');
      }
    } catch (e) {
      print('Error debugging contacts: $e');
    }
    print('=== END DEBUG ===');
  }

  /// Helper method to clean phone numbers (for debugging and consistency)
  String _cleanPhoneNumber(String phoneNumber) {
    String cleanNumber = phoneNumber.trim();

    // Remove any extra characters but keep + and digits
    cleanNumber = cleanNumber.replaceAll(RegExp(r'[^\d+\-\s\(\)]'), '');

    // If it doesn't start with +, assume it's Indian number and add +91
    if (!cleanNumber.startsWith('+')) {
      if (cleanNumber.startsWith('91')) {
        cleanNumber = '+$cleanNumber';
      } else {
        cleanNumber = '+91$cleanNumber';
      }
    }

    // Final cleanup - remove spaces, dashes, parentheses
    return cleanNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');
  }

  /// Update an emergency contact
  Future<void> updateEmergencyContact(EmergencyContact updatedContact) async {
    final contacts = await getSavedEmergencyContacts();
    final index = contacts.indexWhere(
      (contact) => contact.id == updatedContact.id,
    );

    if (index != -1) {
      contacts[index] = updatedContact;
      await saveEmergencyContacts(contacts);
    }
  }
}
