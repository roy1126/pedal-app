import 'conversation-model.dart';
import 'location-model.dart';

class Booking {
  final String driverId;
  final String customerId;
  final bool isPwd;
  final String pwdType;
  final String noteToDriver;
  final DateTime dateCreated;
  final DateTime? dateCompleted;
  final bool isActive;
  final String bookingStatus;
  final double distanceKM;
  final List<Conversation> conversation;
  final Location startLocation;
  final Location destination;

  Booking({
    required this.driverId,
    required this.customerId,
    required this.isPwd,
    required this.pwdType,
    required this.noteToDriver,
    required this.dateCreated,
    this.dateCompleted,
    required this.isActive,
    required this.bookingStatus,
    required this.distanceKM,
    required this.conversation,
    required this.startLocation,
    required this.destination,
  });

  // Factory method to convert a map into a Booking object
  factory Booking.fromJson(Map<String, dynamic> json) {
    var convList = json['conversation'] as List<dynamic>;
    List<Conversation> conversation =
        convList.map((e) => Conversation.fromJson(e)).toList();

    return Booking(
      driverId: json['driverId'] ?? '',
      customerId: json['customerId'] ?? '',
      isPwd: json['isPwd'] ?? false,
      pwdType: json['pwdType'] ?? '',
      noteToDriver: json['noteToDriver'] ?? '',
      dateCreated: DateTime.parse(json['dateCreated']),
      dateCompleted: json['dateCompleted'] != null
          ? DateTime.parse(json['dateCompleted'])
          : null,
      isActive: json['isActive'] ?? false,
      bookingStatus: json['bookingStatus'] ?? '',
      distanceKM: json['distanceKM']?.toDouble() ?? 0.0,
      conversation: conversation,
      startLocation: Location.fromJson(json['startLocation']),
      destination: Location.fromJson(json['destination']),
    );
  }

  toJson() {}
}
