import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authentication/auth_service.dart';
import 'loginScreen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile",
            style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
        actions: [
          GestureDetector(
            onTap: () async {
              authService.signOut().then((value) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Icon(Icons.logout),
            ),
          )
        ],
        backgroundColor: Color(0xFFff5722),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: 200.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xfffdbca7), Color(0xfffa8153)]),
            ),
          ),
          // Container(child: _mainListBuilder(context)),
          // Container(
          //   margin: EdgeInsets.only(top: 300),
          //   padding: EdgeInsets.symmetric(horizontal: 20.0),
          //   child: Text("My Posts", style: TextStyle(
          //       color: Colors.white,
          //       fontSize: 22,
          //       fontWeight: FontWeight.bold)),
          // ),
          // Container(
          //     margin: EdgeInsets.only(top: 310), child: ProfileScreenPosts()),
        ],
      ),
    );
  }

  // Widget _mainListBuilder(BuildContext context) {
  //   final userId = FirebaseAuth.instance.currentUser!.uid;
  //   final Stream<QuerySnapshot> _stream;
  //   _stream = UserDatabase.readUser(userId);
  //   return StreamBuilder(
  //       stream: _stream,
  //       builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //         if (!snapshot.hasData) {
  //           return Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         }
  //         final List userDetails = [];
  //         snapshot.data!.docs.map((e) {
  //           Map details = e.data() as Map<String, dynamic>;
  //           userDetails.add(details);
  //         }).toList();
  //         return _buildHeader(context, userDetails);
  //       });
  // }

  Widget _buildListItem() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Image.network(
            "https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/travel%2Fmount_everest.jpg?alt=media",
            fit: BoxFit.cover),
      ),
    );
  }

  Container _buildHeader(BuildContext context, List userDetails) {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      height: 200.0,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                top: 40.0, left: 40.0, right: 40.0, bottom: 10.0),
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              elevation: 5.0,
              color: Colors.white,
              child: Container(
                width: MediaQuery.of(context).size.width*.8,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 50.0,
                    ),
                    Text(
                      userDetails[0]['name'],
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(userDetails[0]['category'],
                        style: TextStyle(fontSize: 18)),
                    SizedBox(
                      height: 16.0,
                    ),
                    // Container(
                    //   height: 40.0,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: <Widget>[
                    //       Expanded(
                    //         child: ListTile(
                    //           title: Text(
                    //             "302",
                    //             textAlign: TextAlign.center,
                    //             style: TextStyle(fontWeight: FontWeight.bold),
                    //           ),
                    //           subtitle: Text("Posts".toUpperCase(),
                    //               textAlign: TextAlign.center,
                    //               style: TextStyle(fontSize: 12.0)),
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: ListTile(
                    //           title: Text(
                    //             "10.3K",
                    //             textAlign: TextAlign.center,
                    //             style: TextStyle(fontWeight: FontWeight.bold),
                    //           ),
                    //           subtitle: Text("Followers".toUpperCase(),
                    //               textAlign: TextAlign.center,
                    //               style: TextStyle(fontSize: 12.0)),
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: ListTile(
                    //           title: Text(
                    //             "120",
                    //             textAlign: TextAlign.center,
                    //             style: TextStyle(fontWeight: FontWeight.bold),
                    //           ),
                    //           subtitle: Text("Following".toUpperCase(),
                    //               textAlign: TextAlign.center,
                    //               style: TextStyle(fontSize: 12.0)),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Material(
                elevation: 5.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  radius: 40.0,
                  backgroundImage: NetworkImage(userDetails[0]['user_image']),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
