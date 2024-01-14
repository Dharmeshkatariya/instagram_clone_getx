import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../utils/colors.dart';
import '../controller/dashboard_controller.dart';


class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {


  final controller  = Get.put(DashBoardController()) ;

  @override
  void initState() {
    super.initState();
    controller.  pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    controller. pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      controller.page.value = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    controller.  pageController.jumpToPage(page);
    setState(() {
      controller.page.value = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.home,
              color: controller.page.value == 0 ? primaryColor : secondaryColor,
            ),
            onPressed: () => navigationTapped(0),
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: controller.page.value == 1 ? primaryColor : secondaryColor,
            ),
            onPressed: () => navigationTapped(1),
          ),
          IconButton(
            icon: Icon(
              Icons.add_a_photo,
              color: controller.page.value == 2 ? primaryColor : secondaryColor,
            ),
            onPressed: () => navigationTapped(2),
          ),
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: controller.page.value == 3 ? primaryColor : secondaryColor,
            ),
            onPressed: () => navigationTapped(3),
          ),
          IconButton(
            icon: Icon(
              Icons.person,
              color: controller.page.value == 4 ? primaryColor : secondaryColor,
            ),
            onPressed: () => navigationTapped(4),
          ),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.pageController,
        onPageChanged: onPageChanged,
        children: controller. homeScreenItems,
      ),
    );
  }
}
