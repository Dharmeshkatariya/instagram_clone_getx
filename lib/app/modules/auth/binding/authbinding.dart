import 'package:get/get.dart';
import 'package:instagram_fflutter_app_getx/app/modules/auth/controller/authcontroller.dart';

class AuthBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(AuthController()) ;
    // TODO: implement dependencies
  }

}