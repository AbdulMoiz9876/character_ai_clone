import 'package:get/get.dart';
import '../controllers/character_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CharacterController()); // Global controller
  }
}