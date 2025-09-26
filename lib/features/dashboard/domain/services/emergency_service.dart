import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:latlong2/latlong.dart';
import 'package:telephony/telephony.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sms/flutter_sms.dart';
import '../models/emergency_contact.dart';

class EmergencyService {
  static const String _contactsKey = 'emergency_contacts';

  // Telephony instance for direct SMS sending
  final Telephony _telephony = Telephony.instance;

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

  /// Send SOS SMS directly to all emergency contacts without opening external apps
  Future<bool> sendSOSMessage() async {
    try {
      // Check and request SMS permission
      final hasPermission = await _requestSMSPermissions();
      if (!hasPermission) {
        print('SMS permissions denied');
        return false;
      }

      // Get current or last known location
      final location = await getCurrentLocation();
      final contacts = await getSavedEmergencyContacts();

      if (contacts.isEmpty) {
        print('No emergency contacts found');
        return false;
      }

      // Create SOS message with location
      final String message = _createSOSMessage(location);

      // Send SMS directly to all contacts
      bool allSent = true;
      for (final contact in contacts) {
        try {
          final phoneNumber = contact.phoneNumber;
          if (phoneNumber != null && phoneNumber.isNotEmpty) {
            final cleanedNumber = _cleanPhoneNumber(phoneNumber);
            final success = await _sendDirectSMS(cleanedNumber, message);
            if (success) {
              print(
                'SOS SMS sent successfully to ${contact.name}: $cleanedNumber',
              );
            } else {
              print('Failed to send SMS to ${contact.name}: $cleanedNumber');
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

  /// Check if SMS permissions are available
  Future<bool> hasSMSPermissions() async {
    try {
      // Check permission_handler SMS permission
      var status = await Permission.sms.status;
      if (status.isGranted) {
        return true;
      }

      // Check telephony SMS permission
      final bool? hasPermission = await _telephony.requestSmsPermissions;
      return hasPermission ?? false;
    } catch (e) {
      print('Error checking SMS permissions: $e');
      return false;
    }
  }

  /// Request SMS permissions with user-friendly handling
  Future<bool> requestSMSPermissions() async {
    return await _requestSMSPermissions();
  }

  /// Request SMS permissions
  Future<bool> _requestSMSPermissions() async {
    try {
      // Check if SMS permission is already granted
      var status = await Permission.sms.status;
      if (status.isGranted) {
        return true;
      }

      // Request SMS permission
      status = await Permission.sms.request();
      if (status.isGranted) {
        return true;
      }

      // If denied, try alternative approach with telephony
      final bool? hasPermission = await _telephony.requestSmsPermissions;
      return hasPermission ?? false;
    } catch (e) {
      print('Error requesting SMS permissions: $e');
      return false;
    }
  }

  /// Send SMS directly using telephony package with flutter_sms fallback
  Future<bool> _sendDirectSMS(String phoneNumber, String message) async {
    try {
      print('Sending direct SMS to: $phoneNumber');

      // Method 1: Try telephony package first
      try {
        await _telephony.sendSms(
          to: phoneNumber,
          message: message,
          statusListener: (status) {
            switch (status) {
              case SendStatus.SENT:
                print('SMS sent to $phoneNumber');
                break;
              case SendStatus.DELIVERED:
                print('SMS delivered to $phoneNumber');
                break;
            }
          },
        );
        return true;
      } catch (e) {
        print('Telephony SMS failed for $phoneNumber: $e');
      }

      // Method 2: Try flutter_sms as fallback
      try {
        List<String> recipients = [phoneNumber];
        String result = await sendSMS(message: message, recipients: recipients);
        print('Flutter SMS result for $phoneNumber: $result');

        // Check if SMS was sent successfully
        if (result.contains('sent')) {
          return true;
        }
      } catch (e) {
        print('Flutter SMS failed for $phoneNumber: $e');
      }

      print('All SMS methods failed for $phoneNumber');
      return false;
    } catch (e) {
      print('Error sending direct SMS to $phoneNumber: $e');
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
