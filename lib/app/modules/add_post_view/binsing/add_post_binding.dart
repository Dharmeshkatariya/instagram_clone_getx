import 'package:get/get.dart';
import 'package:instagram_fflutter_app_getx/app/modules/add_post_view/controller/add_post_controller.dart';

class AddPostBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(AddPostController());
    // TODO: implement dependencies
  }

}