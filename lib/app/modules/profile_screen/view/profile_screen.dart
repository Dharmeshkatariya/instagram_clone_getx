
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_fflutter_app_getx/app/modules/auth/view/login_screen.dart';
import 'package:instagram_fflutter_app_getx/app/modules/profile_screen/controller/user_profile_controller.dart';
import '../../../../firebase_services/firestore_methods.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final controller = Get.put(UserProfileController());

  @override
  void initState() {
    controller.getArgument();
    getData();

    // TODO: implement initState
    super.initState();
  }

  getData() async {
    controller.isLoading.value = true;
    setState(() {

    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(controller.uid.value)
          .get();

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid',
              isEqualTo: controller.authController.auth.currentUser!.uid)
          .get();

      controller.postLen.value = postSnap.docs.length;
      controller.userData = userSnap.data()!;
      // print(userSnap.data());
      print(controller.userData);
      controller.followers.value = userSnap.data()!['followers'].length;
      controller.following.value = userSnap.data()!['following'].length;
      controller.isFollowing.value = userSnap
          .data()!['followers']
          .contains(controller.authController.auth.currentUser!.uid);

      controller.isLoading.value = false;

      setState(() {});
    } catch (e) {
      var context = Get.context!;
      showSnackBar(
        context,
        e.toString(),
      );
    }
    // update() ;
    controller.isLoading.value = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return controller.isLoading.value
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Obx(() => Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(
          controller.userData['username'],
        ),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(2),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                        controller.userData['photoUrl'],
                      ),
                      radius: 40,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              buildStatColumn(
                                  controller.postLen.value, "posts"),
                              buildStatColumn(controller.followers.value,
                                  "followers"),
                              buildStatColumn(controller.following.value,
                                  "following"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              controller.authController.auth.currentUser!
                                  .uid ==
                                  controller.uid.value
                                  ? FollowButton(
                                text: 'Sign Out',
                                backgroundColor:
                                mobileBackgroundColor,
                                textColor: primaryColor,
                                borderColor: Colors.grey,
                                function: () async {

                                  await controller.authController.signOut();
                                  if (context.mounted) {
                                    Get.to(LoginScreen());
                                    // Navigator.of(context)
                                    //     .pushReplacement(
                                    //   MaterialPageRoute(
                                    //     builder: (context) =>
                                    //         const LoginScreen(),
                                    //   ),
                                    // );
                                  }
                                },
                              )
                                  : controller.isFollowing.value
                                  ? FollowButton(
                                text: 'Unfollow',
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                                borderColor: Colors.grey,
                                function: () async {

                                  await FireStoreMethods()
                                      .followUser(
                                    FirebaseAuth.instance
                                        .currentUser!.uid,
                                    controller.userData['uid'],
                                  );

                                  controller.isFollowing.value =
                                  false;
                                  controller.followers.value--;
                                },
                              )
                                  : FollowButton(
                                text: 'Follow',
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                borderColor: Colors.blue,
                                function: () async {
                                  await FireStoreMethods()
                                      .followUser(
                                    FirebaseAuth.instance
                                        .currentUser!.uid,
                                    controller.userData['uid'],
                                  );

                                  controller.isFollowing.value =
                                  true;
                                  controller.followers.value++;
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(
                    top: 15,
                  ),
                  child: Text(
                    controller.userData['username'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(
                    top: 1,
                  ),
                  child: Text(
                    controller.userData['bio'],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('posts')
                .where('uid', isEqualTo: controller.uid.value)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                itemCount: (snapshot.data! as dynamic).docs.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 1.5,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  DocumentSnapshot snap =
                  (snapshot.data! as dynamic).docs[index];

                  return SizedBox(
                    child: Image(
                      image: NetworkImage(snap['postUrl']),
                      fit: BoxFit.cover,
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
    ));
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
