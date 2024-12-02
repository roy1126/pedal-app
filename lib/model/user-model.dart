import 'package:pedal_application/model/car.model.dart';

class User {
  String id;
  String firstName;
  String lastName;
  String phoneNumber;
  String address;
  String email;
  String password;
  bool isDriver;
  Car? carDetails; // Added carDetails as an instance of Car

  // Constructor
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.address,
    required this.email,
    required this.password,
    required this.isDriver,
    this.carDetails,
  });

  // Factory method to create a User object from a JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      isDriver: json['isDriver'] ?? false,
      carDetails: json['carDetails'] != null
          ? Car.fromJson(json['carDetails'])
          : null, // If carDetails is present, create a Car object
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
      'carDetails':
          carDetails?.toJson(), // If carDetails is not null, convert it to JSON
    };
  }
}
