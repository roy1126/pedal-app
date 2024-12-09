class VehicleDetails {
  String model;
  int yearModel;
  String licenseNumber;
  bool rampOrLiftAvailability;
  int wheelCapacity;
  String otherAccessibilityFeat;

  // Constructor
  VehicleDetails({
    required this.model,
    required this.yearModel,
    required this.licenseNumber,
    required this.rampOrLiftAvailability,
    required this.wheelCapacity,
    required this.otherAccessibilityFeat,
  });

  // Factory method to create an instance from JSON
  factory VehicleDetails.fromJson(Map<String, dynamic> json) {
    return VehicleDetails(
      model: json['model'] ?? '',
      yearModel: json['yearModel'] ?? 0,
      licenseNumber: json['licenseNumber'] ?? '',
      rampOrLiftAvailability: json['rampOrLiftAvailability'] ?? false,
      wheelCapacity: json['wheelCapacity'] ?? 0,
      otherAccessibilityFeat: json['otherAccessibilityFeat'] ?? '',
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'yearModel': yearModel,
      'licenseNumber': licenseNumber,
      'rampOrLiftAvailability': rampOrLiftAvailability,
      'wheelCapacity': wheelCapacity,
      'otherAccessibilityFeat': otherAccessibilityFeat,
    };
  }
}
