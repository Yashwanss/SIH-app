import 'package:flutter/material.dart';

class WeatherData {
  final String location;
  final double temperature;
  final int humidity;
  final double windSpeed;
  final String description;
  final String icon;
  final WeatherAlert? alert;

  const WeatherData({
    required this.location,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.icon,
    this.alert,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      location: json['name'] ?? 'Unknown',
      temperature: (json['main']['temp'] as num).toDouble(),
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '',
      alert: json['alerts'] != null && (json['alerts'] as List).isNotEmpty
          ? WeatherAlert.fromJson(json['alerts'][0])
          : null,
    );
  }

  // Mock data for development/testing
  factory WeatherData.mock({String? location}) {
    return WeatherData(
      location: location ?? 'Guwahati, Assam',
      temperature: 28.0,
      humidity: 85,
      windSpeed: 15.0,
      description: 'Heavy rain expected',
      icon: '10d',
      alert: WeatherAlert(
        title: 'Heavy Rain Warning',
        description: 'Heavy rain expected. Plan your travel accordingly.',
        severity: WeatherSeverity.moderate,
        type: WeatherAlertType.rain,
      ),
    );
  }
}

class WeatherAlert {
  final String title;
  final String description;
  final WeatherSeverity severity;
  final WeatherAlertType type;

  const WeatherAlert({
    required this.title,
    required this.description,
    required this.severity,
    required this.type,
  });

  factory WeatherAlert.fromJson(Map<String, dynamic> json) {
    return WeatherAlert(
      title: json['event'] ?? 'Weather Alert',
      description: json['description'] ?? '',
      severity: _parseSeverity(json['severity'] ?? ''),
      type: _parseType(json['event'] ?? ''),
    );
  }

  static WeatherSeverity _parseSeverity(String severity) {
    switch (severity.toLowerCase()) {
      case 'minor':
        return WeatherSeverity.minor;
      case 'moderate':
        return WeatherSeverity.moderate;
      case 'severe':
        return WeatherSeverity.severe;
      case 'extreme':
        return WeatherSeverity.extreme;
      default:
        return WeatherSeverity.moderate;
    }
  }

  static WeatherAlertType _parseType(String type) {
    if (type.toLowerCase().contains('rain') ||
        type.toLowerCase().contains('storm')) {
      return WeatherAlertType.rain;
    } else if (type.toLowerCase().contains('heat')) {
      return WeatherAlertType.heat;
    } else if (type.toLowerCase().contains('wind')) {
      return WeatherAlertType.wind;
    } else if (type.toLowerCase().contains('flood')) {
      return WeatherAlertType.flood;
    }
    return WeatherAlertType.general;
  }

  Color get backgroundColor {
    switch (severity) {
      case WeatherSeverity.minor:
        return const Color(0xFFFEF3C7); // Yellow-100
      case WeatherSeverity.moderate:
        return const Color(0xFFFED7AA); // Orange-100
      case WeatherSeverity.severe:
        return const Color(0xFFFECACA); // Red-100
      case WeatherSeverity.extreme:
        return const Color(0xFFDDD6FE); // Purple-100
    }
  }

  Color get textColor {
    switch (severity) {
      case WeatherSeverity.minor:
        return const Color(0xFFCA8A04); // Yellow-600
      case WeatherSeverity.moderate:
        return const Color(0xFFEA580C); // Orange-600
      case WeatherSeverity.severe:
        return const Color(0xFFDC2626); // Red-600
      case WeatherSeverity.extreme:
        return const Color(0xFF7C3AED); // Purple-600
    }
  }

  IconData get icon {
    switch (type) {
      case WeatherAlertType.rain:
        return Icons.water_drop;
      case WeatherAlertType.heat:
        return Icons.wb_sunny;
      case WeatherAlertType.wind:
        return Icons.air;
      case WeatherAlertType.flood:
        return Icons.flood;
      case WeatherAlertType.general:
        return Icons.warning;
    }
  }
}

enum WeatherSeverity { minor, moderate, severe, extreme }

enum WeatherAlertType { rain, heat, wind, flood, general }
