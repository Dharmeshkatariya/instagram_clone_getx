import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_fflutter_app_getx/app/modules/auth/controller/authcontroller.dart';

import '../../../../firebase_services/firestore_methods.dart';
import '../../../../models/user.dart';
import '../../../../utils/utils.dart';

class AddPostController extends GetxController{
  RxBool isLoading = false.obs;

  final  descriptionController = TextEditingController();


  final authController =  Get.put(AuthController()) ;
   //final to get the value of data

  UserData ? userData ;

  @override
  void onInit() {
    userData =  authController.getUser  ;
    // TODO: implement onInit
    super.onInit();
  }

  void postImage(BuildContext context, Uint8List? image) async {
      isLoading.value = true;
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
        descriptionController.text,
        image!,
        userData!.uid,
        userData!.username,
        userData!. photoUrl,
      );
      if (res == "success") {
          isLoading.value = false;
        if (context.mounted) {
          showSnackBar(
            context,
            'Posted!',
          );
        }
        image = null ;
        // clearImage();
      } else {
        if (context.mounted) {
          showSnackBar(context, res);
        }
      }
    } catch (err) {
        isLoading.value = false;
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }


  // final userProvider  = Get.put(UserProvider()) ;

}