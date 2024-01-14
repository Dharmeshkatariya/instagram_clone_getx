import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:instagram_fflutter_app_getx/app/modules/auth/controller/authcontroller.dart';
import '../../../../utils/utils.dart';

class UserProfileController extends GetxController{

  var userData = {};
  RxInt postLen = 0.obs;
  RxInt followers = 0.obs;
  RxInt following = 0.obs;
  RxBool isFollowing = false.obs;
  RxBool isLoading = false.obs;

 RxString uid  = "".obs ;
 final authController  = Get.put(AuthController()) ;


 getArgument(){
   print(uid.value) ;
   if(Get.arguments != null){
     var argument  = Get.arguments ;
     uid.value = argument["uid"] ;
     print("argument user id ${uid.value}") ;

   }else{
     uid.value = authController.getUser!.uid ;

   }


 }



  @override
  void onInit() {
   getArgument() ;
    // getData();

    // TODO: implement onInit
    super.onInit();
  }

}