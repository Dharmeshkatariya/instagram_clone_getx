import 'package:get/get.dart';
import 'package:instagram_fflutter_app_getx/app/modules/add_post_view/controller/add_post_controller.dart';
import 'package:instagram_fflutter_app_getx/app/modules/dashboard_controller/controller/dashboard_controller.dart';
import 'package:instagram_fflutter_app_getx/app/modules/feed_view/controller/feed_screeen_controller.dart';
import 'package:instagram_fflutter_app_getx/app/modules/profile_screen/controller/user_profile_controller.dart';
import 'package:instagram_fflutter_app_getx/app/modules/search_view/controller/search_controller.dart';

class DashboardBinding extends Bindings{

  @override
  void dependencies() {
    Get.put(DashBoardController()) ;
    Get.put(SearchScreenController()) ;
    Get.put(FeedScreenController()) ;
    Get.put(UserProfileController()) ;
    Get.put(AddPostController()) ;

    // TODO: implement dependencies
  }

}