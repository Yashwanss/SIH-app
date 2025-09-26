import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_data.dart';

class WeatherService {
  static const String _apiKey =
      'your_openweather_api_key_here'; // Replace with actual API key
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String _cacheKey = 'cached_weather_data';
  static const String _cacheTimeKey = 'cached_weather_time';
  static const String _lastLocationKey = 'last_weather_location';

  // For development/testing, we'll use mock data
  static const bool _useMockData = true;

  // Cache duration for weather data
  static const Duration _weatherCacheExpiry = Duration(minutes: 15);

  // In-memory cache
  static WeatherData? _cachedWeatherData;
  static DateTime? _cacheTime;

  // Singleton pattern
  static WeatherService? _instance;

  WeatherService._internal();

  factory WeatherService() {
    _instance ??= WeatherService._internal();
    return _instance!;
  }

  Future<WeatherData> getCurrentWeather() async {
    // Check in-memory cache first
    if (_cachedWeatherData != null &&
        _cacheTime != null &&
        DateTime.now().difference(_cacheTime!) < _weatherCacheExpiry) {
      return _cachedWeatherData!;
    }

    try {
      // Get current location
      Position? position = await _getCurrentLocation();

      if (_useMockData || position == null) {
        // Return mock data for development
        final mockData = WeatherData.mock(
          location: position != null
              ? await _getLocationName(position.latitude, position.longitude)
              : null,
        );

        // Cache the mock data too
        _cachedWeatherData = mockData;
        _cacheTime = DateTime.now();

        return mockData;
      }

      // Try to fetch real weather data
      final weatherData = await _fetchWeatherFromAPI(
        position.latitude,
        position.longitude,
      );

      // Cache both in memory and persistent storage
      _cachedWeatherData = weatherData;
      _cacheTime = DateTime.now();
      await _cacheWeatherData(weatherData);

      return weatherData;
    } catch (e) {
      print('Error fetching weather: $e');

      // Return in-memory cache if available
      if (_cachedWeatherData != null) {
        return _cachedWeatherData!;
      }

      // Try to return persistent cached data
      final cachedData = await _getCachedWeatherData();
      if (cachedData != null) {
        _cachedWeatherData = cachedData;
        _cacheTime = DateTime.now();
        return cachedData;
      }

      // Fallback to mock data
      return WeatherData.mock();
    }
  }

  Future<Position?> _getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        return await _getLastKnownLocation();
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
          return await _getLastKnownLocation();
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied');
        return await _getLastKnownLocation();
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      // Cache the location
      await _cacheLocation(position);

      return position;
    } catch (e) {
      print('Error getting location: $e');
      return await _getLastKnownLocation();
    }
  }

  Future<Position?> _getLastKnownLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lat = prefs.getDouble('last_lat');
      final lng = prefs.getDouble('last_lng');

      if (lat != null && lng != null) {
        return Position(
          latitude: lat,
          longitude: lng,
          timestamp: DateTime.now(),
          accuracy: 100,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );
      }

      // Default to Guwahati coordinates if no cached location
      return Position(
        latitude: 26.1445,
        longitude: 91.7362,
        timestamp: DateTime.now(),
        accuracy: 100,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );
    } catch (e) {
      print('Error getting cached location: $e');
      return null;
    }
  }

  Future<void> _cacheLocation(Position position) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('last_lat', position.latitude);
      await prefs.setDouble('last_lng', position.longitude);
      await prefs.setInt(
        'last_location_time',
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      print('Error caching location: $e');
    }
  }

  Future<WeatherData> _fetchWeatherFromAPI(double lat, double lng) async {
    final url =
        '$_baseUrl/weather?lat=$lat&lon=$lng&appid=$_apiKey&units=metric';
    final alertsUrl =
        '$_baseUrl/onecall?lat=$lat&lon=$lng&appid=$_apiKey&exclude=minutely,hourly,daily';

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final weatherJson = json.decode(response.body);

        // Try to get alerts
        try {
          final alertsResponse = await http
              .get(Uri.parse(alertsUrl))
              .timeout(const Duration(seconds: 5));
          if (alertsResponse.statusCode == 200) {
            final alertsJson = json.decode(alertsResponse.body);
            weatherJson['alerts'] = alertsJson['alerts'];
          }
        } catch (e) {
          print('Error fetching weather alerts: $e');
        }

        return WeatherData.fromJson(weatherJson);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<String> _getLocationName(double lat, double lng) async {
    // This would normally use geocoding, but for now return a default
    return 'Current Location';
  }

  Future<void> _cacheWeatherData(WeatherData data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode({
        'location': data.location,
        'temperature': data.temperature,
        'humidity': data.humidity,
        'windSpeed': data.windSpeed,
        'description': data.description,
        'icon': data.icon,
        'alert': data.alert != null
            ? {
                'title': data.alert!.title,
                'description': data.alert!.description,
                'severity': data.alert!.severity.name,
                'type': data.alert!.type.name,
              }
            : null,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      await prefs.setString(_cacheKey, jsonString);
    } catch (e) {
      print('Error caching weather data: $e');
    }
  }

  Future<WeatherData?> _getCachedWeatherData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_cacheKey);

      if (jsonString != null) {
        final jsonData = json.decode(jsonString);
        final timestamp = jsonData['timestamp'] as int;

        // Check if cached data is less than 1 hour old
        if (DateTime.now().millisecondsSinceEpoch - timestamp < 3600000) {
          WeatherAlert? alert;
          if (jsonData['alert'] != null) {
            final alertData = jsonData['alert'];
            alert = WeatherAlert(
              title: alertData['title'],
              description: alertData['description'],
              severity: WeatherSeverity.values.firstWhere(
                (e) => e.name == alertData['severity'],
                orElse: () => WeatherSeverity.moderate,
              ),
              type: WeatherAlertType.values.firstWhere(
                (e) => e.name == alertData['type'],
                orElse: () => WeatherAlertType.general,
              ),
            );
          }

          return WeatherData(
            location: jsonData['location'],
            temperature: jsonData['temperature'].toDouble(),
            humidity: jsonData['humidity'],
            windSpeed: jsonData['windSpeed'].toDouble(),
            description: jsonData['description'],
            icon: jsonData['icon'],
            alert: alert,
          );
        }
      }
    } catch (e) {
      print('Error reading cached weather data: $e');
    }

    return null;
  }
}
