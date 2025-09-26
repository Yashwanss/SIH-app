import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../domain/models/weather_data.dart';
import '../../domain/models/poi_data.dart';
import '../../domain/services/weather_service.dart';
import '../../domain/services/poi_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WeatherData? _weatherData;
  List<PointOfInterest> _pois = [];
  LatLng _currentLocation = LatLng(26.1445, 91.7362); // Default to Guwahati
  bool _isLoadingWeather = true;
  bool _isLoadingPOIs = true;
  bool _isLoadingLocation = true;

  final WeatherService _weatherService = WeatherService();
  final POIService _poiService = POIService();

  @override
  void initState() {
    super.initState();
    _loadDataProgressively();
  }

  Future<void> _loadDataProgressively() async {
    // Start location loading first (cached if available)
    _loadLocationAsync();

    // Load weather and POIs concurrently but independently
    _loadWeatherAsync();
    _loadPOIsAsync();
  }

  Future<void> _loadLocationAsync() async {
    try {
      final location = await _poiService.getCurrentLocation();
      if (mounted) {
        setState(() {
          _currentLocation = location;
          _isLoadingLocation = false;
        });

        // Reload POIs with the new location if POIs are still loading
        if (_isLoadingPOIs) {
          _loadPOIsAsync();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingLocation = false);
      }
    }
  }

  Future<void> _loadWeatherAsync() async {
    try {
      final weatherData = await _weatherService.getCurrentWeather();
      if (mounted) {
        setState(() {
          _weatherData = weatherData;
          _isLoadingWeather = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingWeather = false);
      }
    }
  }

  Future<void> _loadPOIsAsync() async {
    try {
      final pois = await _poiService.getNearbyPOIs(_currentLocation);
      if (mounted) {
        setState(() {
          _pois = pois;
          _isLoadingPOIs = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingPOIs = false);
      }
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoadingWeather = true;
      _isLoadingPOIs = true;
      _isLoadingLocation = true;
    });

    try {
      // Get current location first
      final location = await _poiService.getCurrentLocation();
      setState(() {
        _currentLocation = location;
        _isLoadingLocation = false;
      });

      // Load weather and POI data in parallel
      final results = await Future.wait([
        _weatherService.getCurrentWeather(),
        _poiService.getNearbyPOIs(location),
      ]);

      setState(() {
        _weatherData = results[0] as WeatherData;
        _pois = results[1] as List<PointOfInterest>;
        _isLoadingWeather = false;
        _isLoadingPOIs = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _isLoadingWeather = false;
        _isLoadingPOIs = false;
        _isLoadingLocation = false;
      });
    }
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    // Always show the UI, with loading states for individual components
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weather Alert (dynamic based on weather data)
            _buildWeatherAlert(context),

            // Emergency Services Quick Access (static - always shows)
            _buildEmergencyServicesWidget(context),

            // Map Section with flutter_map
            _buildMapSection(context),

            // Dynamic Points of Interest Section
            _buildPOISection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherAlert(BuildContext context) {
    // Show loading indicator if weather is still loading
    if (_isLoadingWeather) {
      return Container(
        height: 56,
        width: double.infinity,
        color: const Color(0xFF2563EB).withOpacity(0.1),
        child: const Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    final alert = _weatherData?.alert;

    if (alert == null) return const SizedBox.shrink();
    return Container(
      height: 56, // Weather alert height from design spec
      width: double.infinity,
      color: alert.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(alert.icon, size: 20, color: alert.textColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                alert.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: alert.textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Weather details chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.thermostat, size: 14, color: alert.textColor),
                  const SizedBox(width: 4),
                  Text(
                    '${_weatherData?.temperature.round() ?? 0}°C',
                    style: TextStyle(
                      color: alert.textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyServicesWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(
                Icons.local_hospital,
                color: Color(0xFFDC2626), // Emergency red
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Emergency Services',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF030213),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Buttons Row
          Row(
            children: [
              // Hospital Button
              Expanded(
                child: _buildEmergencyButton(
                  context,
                  icon: Icons.local_hospital,
                  label: 'Hospital',
                  color: const Color(0xFFDC2626), // Emergency red
                  onPressed: () =>
                      _handleEmergencyButtonPress(context, 'hospital'),
                ),
              ),

              const SizedBox(width: 12),

              // Police Station Button
              Expanded(
                child: _buildEmergencyButton(
                  context,
                  icon: Icons.local_police,
                  label: 'Police',
                  color: const Color(0xFF2563EB), // Blue
                  onPressed: () =>
                      _handleEmergencyButtonPress(context, 'police'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection(BuildContext context) {
    return Container(
      height: 288, // Map section height from design spec
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: _currentLocation,
            initialZoom: 15.0,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
          ),
          children: [
            // OpenStreetMap tile layer
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.safetravel',
              maxZoom: 19,
            ),

            // User location marker
            MarkerLayer(
              markers: [
                Marker(
                  point: _currentLocation,
                  width: 64,
                  height: 64,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        const Center(
                          child: Icon(
                            Icons.location_pin,
                            size: 32,
                            color: Color(0xFFDC2626), // Red-500
                          ),
                        ),
                        // Pulse Indicator
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: Color(0xFF2563EB), // Blue-500
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Offline/Online Badge overlay
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPOISection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Points of Interest',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF030213),
                ),
              ),
              TextButton.icon(
                onPressed: _refreshData,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Refresh'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF2563EB),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // POI Cards
          if (_isLoadingPOIs)
            Column(
              children: List.generate(
                3,
                (index) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 14,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 80,
                        height: 32,
                        child: Center(
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else if (_pois.isEmpty)
            const Center(child: Text('No points of interest found nearby'))
          else
            ..._pois.map((poi) => _buildPOICard(context, poi)),
        ],
      ),
    );
  }

  Widget _buildPOICard(BuildContext context, PointOfInterest poi) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          // POI Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.place, color: Color(0xFF2563EB), size: 20),
          ),

          const SizedBox(width: 12),

          // POI Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        poi.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (poi.rating != null) ...[
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(
                        poi.ratingText,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      poi.subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF6B7280), // Gray-500
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• ${poi.distanceText}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF6B7280), // Gray-500
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Button (80px width)
          SizedBox(
            width: 80,
            child: OutlinedButton.icon(
              onPressed: () => _openPOIInGoogleMaps(poi),
              icon: const Icon(Icons.navigation, size: 12),
              label: const Text('Go', style: TextStyle(fontSize: 12)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleEmergencyButtonPress(
    BuildContext context,
    String type,
  ) async {
    print('Emergency button pressed: $type');

    // Show immediate feedback
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Opening ${type == 'hospital' ? 'Hospital' : 'Police Station'} locations...',
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: type == 'hospital'
              ? const Color(0xFFDC2626)
              : const Color(0xFF2563EB),
          action: SnackBarAction(
            label: 'Cancel',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }

    try {
      // Open Google Maps
      await _openGoogleMaps(type);
    } catch (e) {
      print('Error in _handleEmergencyButtonPress: $e');

      // Show error feedback
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to open maps app. Error: $e'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openGoogleMaps(String type) async {
    String query;

    switch (type) {
      case 'hospital':
        query = 'hospital';
        break;
      case 'police':
        query = 'police station';
        break;
      default:
        query = 'emergency services';
    }

    // Multiple URL schemes to try for better mobile compatibility
    final List<Uri> urlsToTry = [
      // Google Maps app URL scheme (works on mobile)
      Uri.parse('https://maps.google.com/maps?q=$query+near+me'),
      // Another Google Maps app scheme
      Uri.parse('geo:0,0?q=$query+near+me'),
      // Direct Google Maps URL that should redirect to app
      Uri.parse('google.navigation:q=$query+near+me'),
      // Fallback web URL
      Uri.parse('https://www.google.com/maps/search/$query+near+me'),
    ];

    bool opened = false;

    // Try each URL scheme until one works
    for (int i = 0; i < urlsToTry.length; i++) {
      final url = urlsToTry[i];
      try {
        print('Trying URL $i: $url');

        if (await canLaunchUrl(url)) {
          print('URL $i can be launched, attempting to launch...');

          final result = await launchUrl(
            url,
            mode: LaunchMode.externalApplication,
          );

          if (result) {
            print('Successfully launched URL $i');
            opened = true;
            break;
          }
        }
      } catch (e) {
        print('Error with URL $i: $e');
        continue;
      }
    }

    if (!opened) {
      print('Could not launch any Google Maps URL for $type');
    }
  }

  Future<void> _openPOIInGoogleMaps(PointOfInterest poi) async {
    final lat = poi.location.latitude;
    final lng = poi.location.longitude;

    final List<Uri> urlsToTry = [
      // Google Maps with specific coordinates
      Uri.parse('https://maps.google.com/maps?q=$lat,$lng'),
      // Google Maps with place name
      Uri.parse(
        'https://maps.google.com/maps?q=${Uri.encodeComponent(poi.name)}+near+me',
      ),
      // Geo scheme with coordinates
      Uri.parse('geo:$lat,$lng?q=${Uri.encodeComponent(poi.name)}'),
      // Navigation scheme
      Uri.parse('google.navigation:q=$lat,$lng'),
    ];

    bool opened = false;

    for (final url in urlsToTry) {
      try {
        if (await canLaunchUrl(url)) {
          final result = await launchUrl(
            url,
            mode: LaunchMode.externalApplication,
          );

          if (result) {
            opened = true;
            break;
          }
        }
      } catch (e) {
        print('Error with POI URL: $e');
        continue;
      }
    }

    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to open ${poi.name} in maps'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
