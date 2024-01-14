import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../add_post_view/view/add_post_screen.dart';
import '../../auth/controller/authcontroller.dart';
import '../../feed_view/view/feed_screen.dart';
import '../../profile_screen/view/profile_screen.dart';
import '../../search_view/view/search_screen.dart';


class DashBoardController extends GetxController{


  @override
  void onInit() {
    super.onInit();
  }
  List<Widget> homeScreenItems = [
    FeedScreen(),
    SearchScreen(),
    AddPostScreen(),
    Text('notifications'),
    ProfileScreen(
    ),
  ];

  RxInt page = 0.obs;
  late PageController pageController;
  final authController =Get.put(AuthController());


}