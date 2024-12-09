class Booking {
  String? id;
  String? driverId;
  String? customerId;
  bool isPwd;
  String pwdType;
  String notes;
  DateTime? dateCompleted;
  bool isActive;
  String bookingStatus;
  DateTime eta;
  double price;
  String startLocation;
  String destination;
  DateTime createdAt;
  DateTime updatedAt;

  // Constructor for the Booking class
  Booking({
    this.id,
    this.driverId,
    required this.customerId,
    required this.isPwd,
    required this.pwdType,
    required this.notes,
    this.dateCompleted,
    required this.isActive,
    required this.bookingStatus,
    required this.eta,
    required this.price,
    required this.startLocation,
    required this.destination,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create a Booking from JSON
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'] as String?,
      driverId: json['driverId'] as String?,
      customerId: json['customerId'] as String,
      isPwd: json['isPwd'] as bool,
      pwdType: json['pwdType'] ?? 'regular',
      notes: json['notes'] ?? '',
      dateCompleted: json['dateCompleted'] != null
          ? DateTime.parse(json['dateCompleted'])
          : null,
      isActive: json['isActive'] as bool,
      bookingStatus: json['bookingStatus'] ?? 'IN-PROGRESS',
      eta: DateTime.parse(json['eta']),
      price: (json['price'] as num).toDouble(),
      startLocation: json['startLocation'] as String,
      destination: json['destination'] as String,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Method to convert Booking to JSON format
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'driverId': driverId,
      'customerId': customerId,
      'isPwd': isPwd,
      'pwdType': pwdType,
      'notes': notes,
      'dateCompleted': dateCompleted?.toIso8601String(),
      'isActive': isActive,
      'bookingStatus': bookingStatus,
      'eta': eta.toIso8601String(),
      'price': price,
      'startLocation': startLocation,
      'destination': destination,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
