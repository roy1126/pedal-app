import 'booking.model.dart';
import 'user-model.dart';

class ApplicationData {
  List<User> users;
  List<Booking> booking;

  ApplicationData({
    required this.users,
    required this.booking,
  });

  factory ApplicationData.fromJson(Map<String, dynamic> json) {
    var userList = List<User>.from(json['users'].map((x) => User.fromJson(x)));
    var bookingList =
        List<Booking>.from(json['booking'].map((x) => Booking.fromJson(x)));
    return ApplicationData(
      users: userList,
      booking: bookingList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'users': users.map((x) => x.toJson()).toList(),
      'booking': booking.map((x) => x.toJson()).toList(),
    };
  }
}
