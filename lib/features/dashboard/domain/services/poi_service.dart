import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/poi_data.dart';

/// POIService fetches real nearby places using the free OpenStreetMap Overpass API.
///
/// Configuration:
///   No API key required - uses the free OSM Overpass API.
///
/// Features:
///   * Fetches nearby amenities (hospitals, restaurants, ATMs, etc.) within specified radius
///   * Text search for places by name
///   * No rate limits or API key requirements
///   * Returns up to 20 nearby POIs, sorted by distance
///   * Supports various OSM amenity types: hospital, restaurant, fuel, atm, pharmacy, etc.
///
/// Behavior:
///   * No mock data by default: if a network error occurs, returns empty list
///   * Location caching to reduce GPS queries
///   * 15-second timeout for Overpass API requests
///   * Parses OSM tags for name, amenity type, address, cuisine, etc.
///
/// Data Source: OpenStreetMap via Overpass API (completely free, no registration needed)
class POIService {
  // Using free OpenStreetMap Overpass API - no API key required
  static const String _overpassUrl = 'https://overpass-api.de/api/interpreter';

  // Disable mock data: always attempt real API. If key missing or call fails, returns empty list.
  static const bool _useMockData = false;

  // Cache keys
  // (Removed unused constants _lastLocationKey & _lastLocationTimeKey). Using literal keys directly when persisting.
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
    if (_useMockData) {
      return PointOfInterest.getMockPOIs(userLocation);
    }

    try {
      return await _fetchPOIsFromOSM(userLocation, radius);
    } catch (e) {
      print('Error fetching POIs from OSM: $e');
      return [];
    }
  }

  Future<List<PointOfInterest>> _fetchPOIsFromOSM(
    LatLng userLocation,
    int radius,
  ) async {
    final List<PointOfInterest> allPOIs = [];

    // Define the OSM amenity types we want to fetch
    final List<String> amenityTypes = [
      'hospital',
      'restaurant',
      'fuel',
      'atm',
      'pharmacy',
      'police',
      'bank',
      'school',
      'tourist_attraction',
    ];

    // Create Overpass QL query for nearby amenities
    final overpassQuery =
        '''
[out:json][timeout:25];
(
  ${amenityTypes.map((type) => 'node["amenity"="$type"](around:$radius,${userLocation.latitude},${userLocation.longitude});').join('\n  ')}
  node["tourism"="attraction"](around:$radius,${userLocation.latitude},${userLocation.longitude});
);
out geom;
''';

    try {
      final response = await http
          .post(
            Uri.parse(_overpassUrl),
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'data=$overpassQuery',
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final elements = data['elements'] as List? ?? [];

        for (var element in elements) {
          try {
            if (element['lat'] != null && element['lon'] != null) {
              final poi = _parseOSMElement(element, userLocation);
              if (poi != null) {
                allPOIs.add(poi);
              }
            }
          } catch (e) {
            print('Error parsing OSM element: $e');
          }
        }
      } else {
        print('OSM Overpass API error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching from OSM: $e');
    }

    // Sort by distance and return top 20
    allPOIs.sort((a, b) => a.distance.compareTo(b.distance));
    return allPOIs.take(20).toList();
  }

  PointOfInterest? _parseOSMElement(
    Map<String, dynamic> element,
    LatLng userLocation,
  ) {
    final tags = element['tags'] as Map<String, dynamic>? ?? {};
    final name = tags['name'] ?? tags['operator'] ?? 'Unknown';

    if (name == 'Unknown') return null; // Skip places without names

    final lat = (element['lat'] as num).toDouble();
    final lon = (element['lon'] as num).toDouble();
    final location = LatLng(lat, lon);

    final distance = _calculateDistance(userLocation, location);

    // Determine POI type from OSM tags
    String poiType = 'other';
    if (tags['amenity'] != null) {
      poiType = tags['amenity'];
    } else if (tags['tourism'] != null) {
      poiType = 'tourist_attraction';
    }

    return PointOfInterest(
      id: element['id']?.toString() ?? '',
      name: name,
      subtitle: _getSubtitleFromTags(tags),
      type: POIType.fromString(poiType),
      location: location,
      distance: distance,
      address: _getAddressFromTags(tags),
      rating: null, // OSM doesn't have ratings
      isOpen: true, // Assume open unless specified
    );
  }

  String _getSubtitleFromTags(Map<String, dynamic> tags) {
    if (tags['cuisine'] != null) {
      return tags['cuisine'];
    }
    if (tags['brand'] != null) {
      return tags['brand'];
    }
    if (tags['amenity'] != null) {
      return tags['amenity'].toString().replaceAll('_', ' ');
    }
    return '';
  }

  String _getAddressFromTags(Map<String, dynamic> tags) {
    final parts = <String>[];
    if (tags['addr:street'] != null) parts.add(tags['addr:street']);
    if (tags['addr:city'] != null) parts.add(tags['addr:city']);
    return parts.join(', ');
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
    if (_useMockData) {
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

    try {
      return await _searchPOIsFromOSM(query, userLocation, radius);
    } catch (e) {
      print('Error searching POIs in OSM: $e');
      return [];
    }
  }

  Future<List<PointOfInterest>> _searchPOIsFromOSM(
    String query,
    LatLng userLocation,
    int radius,
  ) async {
    // Create Overpass QL query for text search
    final overpassQuery =
        '''
[out:json][timeout:25];
(
  node["name"~"$query",i](around:$radius,${userLocation.latitude},${userLocation.longitude});
  way["name"~"$query",i](around:$radius,${userLocation.latitude},${userLocation.longitude});
);
out geom;
''';

    try {
      final response = await http
          .post(
            Uri.parse(_overpassUrl),
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'data=$overpassQuery',
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final elements = data['elements'] as List? ?? [];
        final results = <PointOfInterest>[];

        for (var element in elements) {
          try {
            final poi = _parseOSMElement(element, userLocation);
            if (poi != null) {
              results.add(poi);
            }
          } catch (e) {
            print('Error parsing search result: $e');
          }
        }

        // Sort by distance
        results.sort((a, b) => a.distance.compareTo(b.distance));
        return results.take(10).toList();
      }
    } catch (e) {
      print('Error in OSM text search: $e');
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
          timeLimit: Duration(
            seconds: 5,
          ), // Reduced timeout for better performance
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
    SharedPreferences.getInstance()
        .then((prefs) {
          prefs.setDouble('last_lat', location.latitude);
          prefs.setDouble('last_lng', location.longitude);
          prefs.setInt(
            'last_location_time',
            DateTime.now().millisecondsSinceEpoch,
          );
        })
        .catchError((e) {
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
