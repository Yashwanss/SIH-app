import 'package:latlong2/latlong.dart';

class PointOfInterest {
  final String id;
  final String name;
  final String subtitle;
  final POIType type;
  final LatLng location;
  final double distance; // in meters
  final String address;
  final double? rating;
  final bool isOpen;
  final String? imageUrl;

  const PointOfInterest({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.type,
    required this.location,
    required this.distance,
    required this.address,
    this.rating,
    required this.isOpen,
    this.imageUrl,
  });

  factory PointOfInterest.fromJson(Map<String, dynamic> json) {
    return PointOfInterest(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      subtitle: json['subtitle'] ?? json['vicinity'] ?? '',
      type: POIType.fromString(json['type'] ?? json['types']?[0] ?? ''),
      location: LatLng(
        (json['geometry']['location']['lat'] as num).toDouble(),
        (json['geometry']['location']['lng'] as num).toDouble(),
      ),
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      address: json['formatted_address'] ?? json['vicinity'] ?? '',
      rating: (json['rating'] as num?)?.toDouble(),
      isOpen: json['opening_hours']?['open_now'] ?? true,
      imageUrl: json['photos']?[0]?['photo_reference'],
    );
  }

  // Mock data based on location
  static List<PointOfInterest> getMockPOIs(LatLng userLocation) {
    return [
      PointOfInterest(
        id: 'hospital_1',
        name: 'City Medical Center',
        subtitle: 'Multi-specialty hospital',
        type: POIType.hospital,
        location: LatLng(
          userLocation.latitude + 0.001,
          userLocation.longitude + 0.002,
        ),
        distance: 500,
        address: 'GS Road, Guwahati',
        rating: 4.2,
        isOpen: true,
      ),
      PointOfInterest(
        id: 'restaurant_1',
        name: 'Paradise Restaurant',
        subtitle: 'Assamese cuisine',
        type: POIType.restaurant,
        location: LatLng(
          userLocation.latitude + 0.002,
          userLocation.longitude - 0.001,
        ),
        distance: 300,
        address: 'Pan Bazaar, Guwahati',
        rating: 4.5,
        isOpen: true,
      ),
      PointOfInterest(
        id: 'petrol_1',
        name: 'Indian Oil Petrol Pump',
        subtitle: 'Fuel station',
        type: POIType.petrolPump,
        location: LatLng(
          userLocation.latitude - 0.001,
          userLocation.longitude + 0.001,
        ),
        distance: 200,
        address: 'NH-37, Guwahati',
        rating: 4.0,
        isOpen: true,
      ),
      PointOfInterest(
        id: 'atm_1',
        name: 'SBI ATM',
        subtitle: 'State Bank of India',
        type: POIType.atm,
        location: LatLng(
          userLocation.latitude + 0.0005,
          userLocation.longitude - 0.002,
        ),
        distance: 150,
        address: 'Paltan Bazaar, Guwahati',
        isOpen: true,
      ),
      PointOfInterest(
        id: 'tourist_1',
        name: 'Kamakhya Temple',
        subtitle: 'Historic temple',
        type: POIType.tourist,
        location: LatLng(
          userLocation.latitude + 0.05,
          userLocation.longitude + 0.03,
        ),
        distance: 5000,
        address: 'Kamakhya, Guwahati',
        rating: 4.8,
        isOpen: true,
      ),
      PointOfInterest(
        id: 'pharmacy_1',
        name: 'Apollo Pharmacy',
        subtitle: '24/7 medical store',
        type: POIType.pharmacy,
        location: LatLng(
          userLocation.latitude - 0.002,
          userLocation.longitude - 0.001,
        ),
        distance: 400,
        address: 'Zoo Road, Guwahati',
        rating: 4.1,
        isOpen: true,
      ),
    ];
  }

  String get distanceText {
    if (distance < 1000) {
      return '${distance.round()}m';
    } else {
      return '${(distance / 1000).toStringAsFixed(1)}km';
    }
  }

  String get ratingText => rating != null ? rating!.toStringAsFixed(1) : '';

  String get statusText => isOpen ? 'Open' : 'Closed';
}

enum POIType {
  hospital,
  restaurant,
  petrolPump,
  atm,
  tourist,
  pharmacy,
  police,
  school,
  bank,
  hotel,
  other;

  static POIType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'hospital':
      case 'health':
        return POIType.hospital;
      case 'restaurant':
      case 'food':
      case 'meal_takeaway':
        return POIType.restaurant;
      case 'gas_station':
      case 'petrol':
      case 'fuel':
        return POIType.petrolPump;
      case 'atm':
      case 'finance':
        return POIType.atm;
      case 'tourist_attraction':
      case 'point_of_interest':
        return POIType.tourist;
      case 'pharmacy':
      case 'drugstore':
        return POIType.pharmacy;
      case 'police':
        return POIType.police;
      case 'school':
      case 'university':
        return POIType.school;
      case 'bank':
        return POIType.bank;
      case 'lodging':
      case 'hotel':
        return POIType.hotel;
      default:
        return POIType.other;
    }
  }

  String get displayName {
    switch (this) {
      case POIType.hospital:
        return 'Hospital';
      case POIType.restaurant:
        return 'Restaurant';
      case POIType.petrolPump:
        return 'Petrol Pump';
      case POIType.atm:
        return 'ATM';
      case POIType.tourist:
        return 'Tourist Spot';
      case POIType.pharmacy:
        return 'Pharmacy';
      case POIType.police:
        return 'Police Station';
      case POIType.school:
        return 'School';
      case POIType.bank:
        return 'Bank';
      case POIType.hotel:
        return 'Hotel';
      case POIType.other:
        return 'Place';
    }
  }

  String get iconAsset {
    switch (this) {
      case POIType.hospital:
        return 'assets/images/emergency_icon.svg';
      case POIType.restaurant:
        return 'assets/images/travel_icon.svg';
      case POIType.petrolPump:
        return 'assets/images/travel_icon.svg';
      case POIType.atm:
        return 'assets/images/personal_icon.svg';
      case POIType.tourist:
        return 'assets/images/travel_icon.svg';
      case POIType.pharmacy:
        return 'assets/images/health_icon.svg';
      case POIType.police:
        return 'assets/images/emergency_icon.svg';
      case POIType.school:
        return 'assets/images/personal_icon.svg';
      case POIType.bank:
        return 'assets/images/personal_icon.svg';
      case POIType.hotel:
        return 'assets/images/travel_icon.svg';
      case POIType.other:
        return 'assets/images/personal_icon.svg';
    }
  }
}
