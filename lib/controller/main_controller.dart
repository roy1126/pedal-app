
import 'package:get/get.dart';
import 'package:pedal_application/model/user-model.dart';
// For JSON parsing

class MainController extends GetxController {
  var _isLoggedin = false;
  late User _currentUser = {} as User;

  void sucessfulLoggingIn(User user) {
    _isLoggedin = true;
    _currentUser = user;
  }

  bool isLoggedIn() {
    return _isLoggedin;
  }

  User getCurrentUser() {
    return _currentUser;
  }
}
