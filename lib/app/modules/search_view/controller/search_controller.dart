import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SearchScreenController extends GetxController{


  final  searchController = TextEditingController();
  RxBool isShowUsers = false.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

}