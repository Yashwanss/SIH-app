class EmergencyContact {
  final String id;
  final String? fullName;
  final String? relationship;
  final String? phoneNumber;
  final String? emailAddress;

  const EmergencyContact({
    required this.id,
    this.fullName,
    this.relationship,
    this.phoneNumber,
    this.emailAddress,
  });

  // Computed properties for backward compatibility
  String get name => fullName ?? '';
  String get relation => relationship ?? '';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'relationship': relationship,
      'phoneNumber': phoneNumber,
      'emailAddress': emailAddress,
    };
  }

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id'] ?? '',
      fullName: json['fullName'],
      relationship: json['relationship'],
      phoneNumber: json['phoneNumber'],
      emailAddress: json['emailAddress'],
    );
  }

  // Factory method to create from registration step data
  factory EmergencyContact.fromRegistrationData({
    String? id,
    String? fullName,
    String? relationship,
    String? phoneNumber,
    String? emailAddress,
  }) {
    return EmergencyContact(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName,
      relationship: relationship,
      phoneNumber: phoneNumber,
      emailAddress: emailAddress,
    );
  }

  bool isValid() {
    return fullName != null &&
        fullName!.trim().isNotEmpty &&
        relationship != null &&
        phoneNumber != null &&
        phoneNumber!.trim().isNotEmpty;
  }

  @override
  String toString() {
    return 'EmergencyContact(id: $id, fullName: $fullName, phoneNumber: $phoneNumber, relationship: $relationship)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EmergencyContact &&
        other.id == id &&
        other.fullName == fullName &&
        other.phoneNumber == phoneNumber &&
        other.relationship == relationship;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        (fullName?.hashCode ?? 0) ^
        (phoneNumber?.hashCode ?? 0) ^
        (relationship?.hashCode ?? 0);
  }
}
