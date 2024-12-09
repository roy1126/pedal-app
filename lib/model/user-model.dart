import 'vehicle.details.model.dart';
import 'vehicle.documents.model.dart';

class User {
  String? id;
  String firstName;
  String lastName;
  String phoneNumber;
  String address;
  String email;
  String password;
  bool isDriver;
  DateTime? lastLogin;
  VehicleDetails? vehicleDetails;
  VehicleDocuments? vehicleDocuments;

  // Constructor
  User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.address,
    required this.email,
    required this.password,
    required this.isDriver,
    this.lastLogin,
    this.vehicleDetails,
    this.vehicleDocuments,
  });

  // Factory method to create a User object from a JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? "",
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      isDriver: json['isDriver'] ?? false,
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin']) // Convert String to DateTime
          : null, // Handle if lastLogin is null
      vehicleDetails: json['vehicleDetails'] != null
          ? VehicleDetails.fromJson(json['vehicleDetails'])
          : null,
      vehicleDocuments: json['vehicleDocuments'] != null
          ? VehicleDocuments.fromJson(json['vehicleDocuments'])
          : null,
    );
  }

  get username => null;

  // Method to convert a User object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'address': address,
      'email': email,
      'password': password,
      'isDriver': isDriver,
      'lastLogin': lastLogin?.toIso8601String(),
      'vehicleDetails': vehicleDetails?.toJson(),
      'vehicleDocuments': vehicleDocuments?.toJson(),
    };
  }
}
