import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/poi_data.dart';

class POIService {
  static const String _googlePlacesApiKey =
      'your_google_places_api_key_here'; // Replace with actual API key
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

  // For development/testing, we'll use mock data
  static const bool _useMockData = true;

  // Cache keys
  static const String _lastLocationKey = 'last_location';
  static const String _lastLocationTimeKey = 'last_location_time';
  static const Duration _locationCacheExpiry = Duration(minutes: 5);

  // Cached location
  static LatLng? _cachedLocation;
  static DateTime? _cacheTime;

  // Singleton pattern
  static POIService? _instance;
  static bool _isInitialized = false;

  POIService._internal();

  factory POIService() {
    _instance ??= POIService._internal();
    if (!_isInitialized) {
      _instance!._loadCachedLocation();
      _isInitialized = true;
    }
    return _instance!;
  }

  Future<List<PointOfInterest>> getNearbyPOIs(
    LatLng userLocation, {
    int radius = 5000,
  }) async {
    try {
      if (_useMockData) {
        // Return mock POIs based on user location
        return PointOfInterest.getMockPOIs(userLocation);
      }

      // Real API implementation
      return await _fetchPOIsFromAPI(userLocation, radius);
    } catch (e) {
      print('Error fetching POIs: $e');

      // Fallback to mock data
      return PointOfInterest.getMockPOIs(userLocation);
    }
  }

  Future<List<PointOfInterest>> _fetchPOIsFromAPI(
    LatLng userLocation,
    int radius,
  ) async {
    final List<PointOfInterest> allPOIs = [];

    // Define the types of POIs we want to fetch
    final List<String> poiTypes = [
      'hospital',
      'restaurant',
      'gas_station',
      'atm',
      'tourist_attraction',
      'pharmacy',
      'police',
    ];

    for (String type in poiTypes) {
      try {
        final url =
            '$_baseUrl?location=${userLocation.latitude},${userLocation.longitude}'
            '&radius=$radius&type=$type&key=$_googlePlacesApiKey';

        final response = await http
            .get(Uri.parse(url))
            .timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final results = data['results'] as List;

          for (var result in results.take(3)) {
            // Limit to 3 per type
            try {
              final poi = PointOfInterest.fromJson({
                ...result,
                'distance': _calculateDistance(
                  userLocation,
                  LatLng(
                    result['geometry']['location']['lat'].toDouble(),
                    result['geometry']['location']['lng'].toDouble(),
                  ),
                ),
                'type': type,
              });
              allPOIs.add(poi);
            } catch (e) {
              print('Error parsing POI: $e');
            }
          }
        }
      } catch (e) {
        print('Error fetching POIs for type $type: $e');
      }
    }

    // Sort by distance and return top 6
    allPOIs.sort((a, b) => a.distance.compareTo(b.distance));
    return allPOIs.take(6).toList();
  }

  double _calculateDistance(LatLng point1, LatLng point2) {
    return Geolocator.distanceBetween(
      point1.latitude,
      point1.longitude,
      point2.latitude,
      point2.longitude,
    );
  }

  Future<List<PointOfInterest>> searchPOIs(
    String query,
    LatLng userLocation, {
    int radius = 10000,
  }) async {
    try {
      if (_useMockData) {
        // Filter mock POIs by query
        final allMockPOIs = PointOfInterest.getMockPOIs(userLocation);
        return allMockPOIs
            .where(
              (poi) =>
                  poi.name.toLowerCase().contains(query.toLowerCase()) ||
                  poi.type.displayName.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList();
      }

      // Real search implementation
      return await _searchPOIsFromAPI(query, userLocation, radius);
    } catch (e) {
      print('Error searching POIs: $e');
      return [];
    }
  }

  Future<List<PointOfInterest>> _searchPOIsFromAPI(
    String query,
    LatLng userLocation,
    int radius,
  ) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json'
        '?query=$query&location=${userLocation.latitude},${userLocation.longitude}'
        '&radius=$radius&key=$_googlePlacesApiKey';

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;

        return results.map((result) {
          return PointOfInterest.fromJson({
            ...result,
            'distance': _calculateDistance(
              userLocation,
              LatLng(
                result['geometry']['location']['lat'].toDouble(),
                result['geometry']['location']['lng'].toDouble(),
              ),
            ),
          });
        }).toList();
      }
    } catch (e) {
      print('Error in text search: $e');
    }

    return [];
  }

  Future<LatLng> getCurrentLocation() async {
    // Return cached location if it's still fresh
    if (_cachedLocation != null && 
        _cacheTime != null && 
        DateTime.now().difference(_cacheTime!) < _locationCacheExpiry) {
      return _cachedLocation!;
    }

    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Cache and return default Guwahati location
        final defaultLocation = LatLng(26.1445, 91.7362);
        _cacheLocation(defaultLocation);
        return defaultLocation;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          final defaultLocation = LatLng(26.1445, 91.7362);
          _cacheLocation(defaultLocation);
          return defaultLocation;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        final defaultLocation = LatLng(26.1445, 91.7362);
        _cacheLocation(defaultLocation);
        return defaultLocation;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 5), // Reduced timeout for better performance
        ),
      );

      final location = LatLng(position.latitude, position.longitude);
      _cacheLocation(location);
      return location;
    } catch (e) {
      print('Error getting current location: $e');
      // Return cached location if available, otherwise default
      if (_cachedLocation != null) {
        return _cachedLocation!;
      }
      final defaultLocation = LatLng(26.1445, 91.7362);
      _cacheLocation(defaultLocation);
      return defaultLocation;
    }
  }

  void _cacheLocation(LatLng location) {
    _cachedLocation = location;
    _cacheTime = DateTime.now();
    
    // Also persist to SharedPreferences for app restart scenarios
    SharedPreferences.getInstance().then((prefs) {
      prefs.setDouble('last_lat', location.latitude);
      prefs.setDouble('last_lng', location.longitude);
      prefs.setInt('last_location_time', DateTime.now().millisecondsSinceEpoch);
    }).catchError((e) {
      print('Error caching location: $e');
      return null;
    });
  }

  Future<void> _loadCachedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lat = prefs.getDouble('last_lat');
      final lng = prefs.getDouble('last_lng');
      final time = prefs.getInt('last_location_time');
      
      if (lat != null && lng != null && time != null) {
        final cacheTime = DateTime.fromMillisecondsSinceEpoch(time);
        if (DateTime.now().difference(cacheTime) < _locationCacheExpiry) {
          _cachedLocation = LatLng(lat, lng);
          _cacheTime = cacheTime;
        }
      }
    } catch (e) {
      print('Error loading cached location: $e');
    }
  }
}
