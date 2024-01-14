import 'package:get/get.dart';
import 'package:instagram_fflutter_app_getx/app/modules/profile_screen/controller/user_profile_controller.dart';

class UserProfileBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(UserProfileController()) ;
    // TODO: implement dependencies
  }

}