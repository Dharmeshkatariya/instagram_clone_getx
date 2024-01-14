
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_fflutter_app_getx/app/modules/add_post_view/controller/add_post_controller.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/utils.dart';

class AddPostScreen extends StatefulWidget{
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {

  Uint8List? file ;
  selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  // isLoading.value = true  ;

                  Navigator.pop(context);
                  Uint8List newfile = await pickImage(ImageSource.camera);
                  file = newfile;
                  setState(() {

                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List newfile = await pickImage(ImageSource.gallery);
                  file = newfile;
                  // update() ;
                  setState(() {

                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Get.back();
                // Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  final controller  =Get.put(AddPostController());
  @override
  Widget build(BuildContext context) {
    // final UserProvider userProvider = Provider.of<UserProvider>(context);

    return file == null
        ? Center(
            child: IconButton(
              icon: const Icon(
                Icons.upload,
              ),
              onPressed: () => selectImage(context),
            ),
          )
        : Obx(() => Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            file = null ;
          },
        ),
        title: const Text(
          'Post to',
        ),
        centerTitle: false,
        actions: <Widget>[
          TextButton(
            onPressed: () => controller.postImage(
              // userProvider.getUser.uid,
              // userProvider.getUser.username,
              // userProvider.getUser.photoUrl,
                context,
                file!
            ),
            child: const Text(
              "Post",
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          )
        ],
      ),
      // POST FORM
      body: Column(
        children: <Widget>[
          controller.isLoading.value
              ? const LinearProgressIndicator()
              : const Padding(padding: EdgeInsets.only(top: 0.0)),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(
                  controller.userData!.photoUrl,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: TextField(
                  controller: controller.descriptionController,
                  decoration: const InputDecoration(
                      hintText: "Write a caption...",
                      border: InputBorder.none),
                  maxLines: 8,
                ),
              ),
              SizedBox(
                height: 45.0,
                width: 45.0,
                child: AspectRatio(
                  aspectRatio: 487 / 451,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          alignment: FractionalOffset.topCenter,
                          image: MemoryImage(file!),
                        )),
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    ));
  }
}
