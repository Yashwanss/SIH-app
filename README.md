# SafeTravel App (In alpha)

A Flutter application with multi-step safety registration flow featuring location autocomplete functionality.

## Features

- Multi-step registration process with travel information collection
- Location autocomplete for accommodation details using Google Places API
- Identity document validation (Passport/Aadhaar)
- Language preference selection
- Emergency contact information

## Setup

### Google Places API Configuration

The app uses Google Places API for location autocomplete functionality. To set this up:

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the **Places API**
4. Create credentials (API Key)
5. Replace the placeholder in `lib/core/constants/api_constants.dart`:

   ```dart
   static const String googlePlacesApiKey = "YOUR_ACTUAL_API_KEY_HERE";
   ```

### Running the App

1. Ensure Flutter is installed and configured
2. Get dependencies:

   ```bash
   flutter pub get
   ```

3. Run the app:

   ```bash
   flutter run
   ```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
