import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:instagram_fflutter_app_getx/app/modules/auth/controller/authcontroller.dart';
import 'package:instagram_fflutter_app_getx/models/user.dart';
import '../../../../firebase_services/firestore_methods.dart';
import '../../../../utils/utils.dart';

class CommentsController extends GetxController{
  // final  commentEditingController =
  // TextEditingController();
  Rx<TextEditingController> commentEditingController = TextEditingController().obs ;
  // RxString postId =  "".obs ;
  // getArgument(){
  //   var argument  = Get.arguments ;
  //   if(argument != null){
  //    var id =  argument["postId"] ;
  //    postId  = id ;
  //   }
  // }
// RxBool isLoading =  false.obs ;
  void postComment(BuildContext context , String postid) async {
    try {
      // isLoading.value = true  ;

      String res = await FireStoreMethods().postComment(
        postid,
        commentEditingController.value.text,
        userData.uid,
       userData.username ,
        userData.photoUrl  ,
      );

      if (res != 'success') {
        if (context.mounted) showSnackBar(context, res);
      }
        commentEditingController.value.text = "";
      update() ;
      // isLoading.value = false  ;

    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }


  final authController  = Get.put(AuthController());
  late UserData userData ;

@override

  void onInit() {
  final  UserData user = authController.getUser! ;
  userData =  user ;
    // TODO: implement onInit
    super.onInit();
  }
}