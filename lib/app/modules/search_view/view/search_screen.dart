import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import '../../../../models/user.dart';
import '../../../../utils/colors.dart';
import '../../profile_screen/view/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Form(
          child: TextFormField(
            controller: searchController,
            onChanged: (str){
              if(searchController.text.isEmpty){
                isShowUsers = false ;
                setState(() {

                });
              }
            },
            decoration:
                const InputDecoration(labelText: 'Search for a user...'),
            onFieldSubmitted: (String _) {
              searchUsers();
            },
          ),
        ),
      ),
      body:  isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : searchResults.isNotEmpty && isShowUsers
              ? ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    var search = searchResults[index];
                    return InkWell(
                      onTap: () {
                        Get.to(ProfileScreen(),arguments: {
                          "uid" : searchResults[index].uid
                        });
                      },
                      // onTap: () => Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => ProfileScreen(
                      //       uid: (snapshot.data! as dynamic).docs[index]['uid'],
                      //     ),
                      //   ),
                      // ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(search.photoUrl),
                          radius: 16,
                        ),
                        title: Text(search.username),
                      ),
                    );
                  },
                )
              : isShowUsers==false ?

      FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .orderBy('datePublished')
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return MasonryGridView.count(
                      crossAxisCount: 3,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (context, index) => Image.network(
                        (snapshot.data! as dynamic).docs[index]['postUrl'],
                        fit: BoxFit.cover,
                      ),
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                    );
                  },
                ) : Center(child: Text("no user data found "),),
    );
  }

  bool isLoading = false;

  void searchUsers() async {
    if(searchController.text.isEmpty){
      // isShowUsers = true ;
      isShowUsers = false ;
      setState(() {

      });
    }else{

      String searchQuery = searchController.text.trim();
      if (searchQuery.isNotEmpty) {
        searchResults.clear() ;
        setState(() {
          isShowUsers = true;
        });
        isLoading = true;
        try {
          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection('users')
              .where('username', isGreaterThanOrEqualTo: searchQuery)
              .get();

          List<UserData> users =
          querySnapshot.docs.map((doc) => UserData.fromSnap(doc)).toList();
          print(users);
          setState(() {
            searchResults = users;
            isLoading = false;
          });

          print(searchResults);
        } catch (error) {
          print('Error searching users: $error');
        }
      }
    }


  }

  List<UserData> searchResults = [];
}
