import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_fflutter_app_getx/firebase_services/storage_methods.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post comment
  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }


  Future<String> savePost(String postId, String uid) async {



    String res = "Some error occurred";
    try {
      DocumentSnapshot savedPostSnapshot = await _firestore.collection('users').doc(uid).collection('savedPosts').doc(postId).get();
      if (savedPostSnapshot.exists) {
        await _firestore.collection('users').doc(uid).collection('savedPosts').doc(postId).delete();
        res = 'Post removed from saved';
      } else {
        // Post is not saved, so add it to saved posts
        await _firestore.collection('users').doc(uid).collection('savedPosts').doc(postId).set({
          'timestamp': FieldValue.serverTimestamp(),
        });
        res = 'Post saved successfully';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> sharePost(
      String description,
      Uint8List file,
      String uid,
      String username,
      String profImage,
      List<String> targetUserIds) async {
    String res = "Some error occurred";
    try {
      // Upload the image to storage
      String photoUrl = await StorageMethods().uploadImageToStorage('posts', file, true);

      // Generate a unique post ID
      String postId = const Uuid().v1();

      // Create the post
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );

      // Save the post in the 'posts' collection
      await _firestore.collection('posts').doc(postId).set(post.toJson());

      // Share the post with each target user
      for (String targetUid in targetUserIds) {
        // Create a reference to the shared post
        DocumentReference sharedPostRef = _firestore.collection('users').doc(targetUid).collection('sharedPosts').doc(postId);

        // Save the post details in the 'sharedPosts' collection of each target user
        await sharedPostRef.set(post.toJson());
      }

      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
