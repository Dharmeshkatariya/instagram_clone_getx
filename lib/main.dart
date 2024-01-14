import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_fflutter_app_getx/app/modules/auth/controller/authcontroller.dart';
import 'package:instagram_fflutter_app_getx/app/modules/auth/view/login_screen.dart';
import 'package:instagram_fflutter_app_getx/utils/colors.dart';

import 'app/modules/dashboard_controller/responsive/mobile_screen_layout.dart';
import 'app/modules/dashboard_controller/responsive/responsive_layout.dart';
import 'app/modules/dashboard_controller/responsive/web_screen_layout.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialise app based on platform- web or mobile
  if (kIsWeb) {
    await Firebase.initializeApp(
      // options: const FirebaseOptions(
      //     // apiKey: "AIzaSyCZ-xrXqD5D19Snauto-Fx_nLD7PLrBXGM",
      //     // appId: "1:585119731880:web:eca6e4b3c42a755cee329d",
      //     // messagingSenderId: "585119731880",
      //     // projectId: "instagram-clone-4cea4",
      //     // storageBucket: 'instagram-clone-4cea4.appspot.com'
      // ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instagram Clone',

      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      home: GetBuilder<AuthController>(
        init: AuthController(), // Initialize the UserProvider
        builder: (userProvider) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return MobileScreenLayout ();

                  return const ResponsiveLayout(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return const LoginScreen();
            },
          );
        },
      ),
    );
  }
}
