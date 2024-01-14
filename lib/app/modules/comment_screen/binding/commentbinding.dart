import 'package:get/get.dart';
import 'package:instagram_fflutter_app_getx/app/modules/comment_screen/controller/comment_controller.dart';

class CommentScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CommentsController());
    // TODO: implement dependencies
  }
}
