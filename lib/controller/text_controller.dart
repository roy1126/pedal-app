import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class TextController extends GetxController {
  TextEditingController titleController = TextEditingController();
  TextEditingController taskController = TextEditingController();

  void editTitle(String value) {
    titleController.text = value;
  }

  void editTask(String value) {
    taskController.text = value;
  }
}
