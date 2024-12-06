
import 'package:get/get.dart';
import 'package:pedal_application/model/user-model.dart';
// For JSON parsing
import '../model/booking.model.dart';
import '../model/location.model.dart';

class MainController extends GetxController {
  var _isLogin = false;
  late User _currentUser = {} as User;

  final Rx<
      ({
        List<User> users,
        List<Booking> booking,
      })> _applicationData = (
    users: [
      User(
          id: "0001",
          firstName: "John",
          lastName: "Smith",
          phoneNumber: "09123456789",
          address: "29 F. Cruz Santolan , Pasig City",
          email: "q",
          password: "w",
          isDriver: false),
    ],
    booking: [
      Booking(
        bookingId: "bookID0001",
        driverId: "0006",
        customerId: "0001",
        isPwd: true,
        pwdType: "AGED",
        noteToDriver: "Pwede po patulong ako magbuhat ng gamit sa sasakyan.",
        dateCreated: DateTime.now(),
        dateCompleted: null,
        isActive: true,
        bookingStatus: "PICK-UP",
        distanceKM: 10.5,
        conversation: [],
        startLocation: Location(
          latitude: 14.5995,
          longitude: 120.9842,
          address: "Rizal Park, Ermita, Manila, Philippines",
          city: "Manila",
          state: "Metro Manila",
          country: "Philippines",
          postalCode: "1000",
        ),
        destination: Location(
          latitude: 14.5995,
          longitude: 120.9842,
          address: "Rizal Park, Ermita, Manila, Philippines",
          city: "Manila",
          state: "Metro Manila",
          country: "Philippines",
          postalCode: "1000",
        ),
      ),
      Booking(
        bookingId: "bookID0002",
        driverId: "0007",
        customerId: "0001",
        isPwd: false,
        pwdType: "NONE",
        noteToDriver: "Walang gaanong gamit, tulungan na lang po ako magbaba.",
        dateCreated: DateTime.now(),
        dateCompleted: DateTime.now(),
        isActive: true,
        bookingStatus: "COMPLETED",
        distanceKM: 5.0,
        conversation: [],
        startLocation: Location(
          latitude: 14.6050,
          longitude: 120.9845,
          address: "Intramuros, Manila, Philippines",
          city: "Manila",
          state: "Metro Manila",
          country: "Philippines",
          postalCode: "1002",
        ),
        destination: Location(
          latitude: 14.6090,
          longitude: 120.9865,
          address: "Quiapo, Manila, Philippines",
          city: "Manila",
          state: "Metro Manila",
          country: "Philippines",
          postalCode: "1003",
        ),
      ),
      Booking(
        bookingId: "bookID0003",
        driverId: "0008",
        customerId: "0003",
        isPwd: true,
        pwdType: "DISABLED",
        noteToDriver:
            "Mahirap po ako maglakad, pakitulong na lang po magbuhat ng mga gamit.",
        dateCreated: DateTime.now(),
        dateCompleted: null,
        isActive: true,
        bookingStatus: "PICK-UP",
        distanceKM: 8.3,
        conversation: [],
        startLocation: Location(
          latitude: 14.5634,
          longitude: 120.9899,
          address: "Makati, Metro Manila, Philippines",
          city: "Makati",
          state: "Metro Manila",
          country: "Philippines",
          postalCode: "1210",
        ),
        destination: Location(
          latitude: 14.5734,
          longitude: 120.9866,
          address: "BGC, Taguig, Metro Manila, Philippines",
          city: "Taguig",
          state: "Metro Manila",
          country: "Philippines",
          postalCode: "1634",
        ),
      ),
      Booking(
        bookingId: "bookID0004",
        driverId: "0009",
        customerId: "0004",
        isPwd: false,
        pwdType: "NONE",
        noteToDriver: "Aasikasuhin ko na lang po ang mga gamit.",
        dateCreated: DateTime.now(),
        dateCompleted: null,
        isActive: true,
        bookingStatus: "PICK-UP",
        distanceKM: 12.0,
        conversation: [],
        startLocation: Location(
          latitude: 14.5580,
          longitude: 120.9870,
          address: "Mandaluyong, Metro Manila, Philippines",
          city: "Mandaluyong",
          state: "Metro Manila",
          country: "Philippines",
          postalCode: "1550",
        ),
        destination: Location(
          latitude: 14.5630,
          longitude: 120.9845,
          address: "San Juan, Metro Manila, Philippines",
          city: "San Juan",
          state: "Metro Manila",
          country: "Philippines",
          postalCode: "1500",
        ),
      ),
      Booking(
        bookingId: "bookID0005",
        driverId: "0010",
        customerId: "0005",
        isPwd: true,
        pwdType: "SENIOR",
        noteToDriver: "Salamat po, medyo mabigat lang ang mga gamit.",
        dateCreated: DateTime.now(),
        dateCompleted: null,
        isActive: true,
        bookingStatus: "PICK-UP",
        distanceKM: 7.2,
        conversation: [],
        startLocation: Location(
          latitude: 14.5773,
          longitude: 120.9894,
          address: "Pasig, Metro Manila, Philippines",
          city: "Pasig",
          state: "Metro Manila",
          country: "Philippines",
          postalCode: "1600",
        ),
        destination: Location(
          latitude: 14.5897,
          longitude: 120.9945,
          address: "Cainta, Rizal, Philippines",
          city: "Cainta",
          state: "Rizal",
          country: "Philippines",
          postalCode: "1900",
        ),
      ),
    ]
  ).obs;

  login(String email, String password) {
    final users = _applicationData.value.users
        .where((User user) => user.email == email && user.password == password)
        .toList();

    _isLogin = users.isNotEmpty;

    if (users.isNotEmpty) {
      _currentUser = users[0];
    }
  }

  bool isLoggedIn() {
    return _isLogin;
  }

  List<Booking> getAllBookings() {
    return _applicationData.value.booking
        .where((Booking booking) => booking.customerId == _currentUser.id)
        .toList();
  }

  addBooking(Booking booking) {
    _applicationData.value.booking.add(booking);
  }

  User getCurrentUser() {
    return _currentUser;
  }
}
