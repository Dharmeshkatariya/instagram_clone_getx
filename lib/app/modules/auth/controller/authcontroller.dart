import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_fflutter_app_getx/firebase_services/storage_methods.dart';
import 'package:instagram_fflutter_app_getx/models/user.dart' as model;
import '../../../../utils/utils.dart';
import '../../dashboard_controller/responsive/mobile_screen_layout.dart';


class AuthController extends GetxController {




  final  loginPassController = TextEditingController();
  final  loginEmailController = TextEditingController();
  final  signUpEmailController = TextEditingController();
  final  signUpPassController = TextEditingController();
  final  usernameController = TextEditingController();
  final  bioController = TextEditingController();
  RxBool isLoading = false.obs;


  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    bioController.dispose();
    loginEmailController.dispose();
    signUpPassController.dispose();
    signUpEmailController.dispose();
    signUpEmailController.dispose();
  }

  void signUpUser(BuildContext context, Uint8List image) async {
    // set loading to true
      isLoading.value = true;

    // signup user using our authmethodds
    String res = await signUpMethod(
        email: signUpEmailController.text,
        password: signUpPassController.text,
        username: usernameController.text,
        bio: bioController.text,
        file: image);
    // if string returned is sucess, user has been created
    if (res == "success") {
        isLoading.value = false;
      // navigate to the home screen
      if (context.mounted) {
        Get.to(MobileScreenLayout()) ;
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (context) => const ResponsiveLayout(
        //       mobileScreenLayout: MobileScreenLayout(),
        //       webScreenLayout: WebScreenLayout(),
        //     ),
        //   ),
        // );
      }
    } else {
        isLoading.value = false;
      // show the error
      if (context.mounted) {
        showSnackBar(context, res);
      }
    }
  }
  // RxBool imageSelect  = false.obs ;








  void loginUser(BuildContext context) async {
      isLoading.value = true;
    String res = await loginMethod(
        email: loginEmailController.text, password: loginPassController.text);
    if (res == 'success') {
      if (context.mounted) {
        Get.to(MobileScreenLayout()) ;

        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(
        //       builder: (context) => const ResponsiveLayout(
        //         mobileScreenLayout: MobileScreenLayout(),
        //         webScreenLayout: WebScreenLayout(),
        //       ),
        //     ),
        //         (route) => false);

          isLoading.value = false;
      }
    } else {
      isLoading.value = false;

      if (context.mounted) {
        showSnackBar(context, res);
      }
    }
  }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Rx<model.UserData?> user = Rx<model.UserData?>(null);

  // Getter for user
  model.UserData? get getUser => user.value;

  // Set user
  void setUser(model.UserData newUser) {
    user.value = newUser;
  }

  @override
  void onInit() {
    super.onInit();
    // Fetch user details when the controller is initialized
    getUserDetails();
  }

  // Fetch user details
    getUserDetails() async {
    try {
      User? currentUser = auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

        setUser(model.UserData.fromSnap(documentSnapshot));
        return model.UserData.fromSnap(documentSnapshot) ;
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }

  // Signing Up User
  Future<String> signUpMethod({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        UserCredential cred = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        model.UserData newUser = model.UserData(
          username: username,
          uid: cred.user!.uid,
          photoUrl: photoUrl,
          email: email,
          bio: bio,
          followers: [],
          following: [],
        );

        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(newUser.toJson());

        setUser(newUser);
        return "success";
      } else {
        return "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
  }

  // Logging in user
  Future<String> loginMethod({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Fetch and set user details after login
        await getUserDetails();

        return "success";
      } else {
        return "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
  }

  // Sign out
  Future<void> signOut() async {
    await auth.signOut();
    // Reset user details after sign out
    // setUser(model.User());
  }


  // refreshUser()async{
  //   user.value =  await getUserDetails() ;
  //   return user ;
  // }
}
