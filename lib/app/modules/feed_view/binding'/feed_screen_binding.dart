import 'package:get/get.dart';
import 'package:instagram_fflutter_app_getx/app/modules/feed_view/controller/feed_screeen_controller.dart';

class FeedScreenBinding extends Bindings {

  @override
  void dependencies() {
    Get.put(FeedScreenController());
  }
}
