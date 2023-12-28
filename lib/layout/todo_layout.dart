import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/extra/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/layout/todo_layoutcontroller.dart';
import 'package:productivity_app/model/event.dart';
import 'package:productivity_app/modules/add_event_screen/add_event_screen.dart';
import 'package:productivity_app/modules/clear_data/clear_data.dart';
import 'package:productivity_app/modules/search_events/search_events.dart';
import 'package:productivity_app/shared/componets/componets.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:productivity_app/shared/network/local/notification.dart';
import 'package:productivity_app/shared/styles/styles.dart';
import 'package:productivity_app/shared/styles/thems.dart';

import '../shared/common/toast.dart';

class TodoLayout extends StatelessWidget {
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  var todocontroller = Get.find<TodoLayoutController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TodoLayoutController>(
      init: Get.find<TodoLayoutController>(),
      builder: (todocontroller) => Scaffold(
        drawer: _drawer(context),
        key: _scaffoldkey,
        // NOTE App Bar
        appBar: _appbar(todocontroller, context),

        //NOTE Body
        body: Obx(
          () => todocontroller.isloading.value
              ? Center(child: CircularProgressIndicator())
              : Container(
                  margin: EdgeInsets.only(top: 5, left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat.yMMMMd().format(DateTime.parse(
                                    todocontroller.currentSelectedDate)),
                                style: subHeaderStyle,
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                todocontroller.currentSelectedDate !=
                                        DateTime.now()
                                            .toString()
                                            .split(' ')
                                            .first
                                    ? DateFormat.E().format(DateTime.parse(
                                        todocontroller.currentSelectedDate))
                                    : "Today",
                                style: headerStyle,
                              ),
                            ],
                          ),
                          defaultButton(
                              text: "Add Event",
                              width: 100,
                              onpress: () {
                                Get.to(() => AddEventScreen());
                              },
                              gradient: orangeGradient,
                              radius: 15),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //NOTE timeline datepicker -------------
                      Container(
                        child: DatePicker(
                          DateTime.now(),
                          height: 80,
                          width: 60,
                          initialSelectedDate: DateTime.now(),
                          selectionColor: defaultLightColor,
                          selectedTextColor: Colors.white,
                          dayTextStyle: TextStyle(
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                          ),
                          dateTextStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                          monthTextStyle: TextStyle(
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                          ),
                          onDateChange: (value) {
                            var selecteddate = value.toString().split(' ');
                            print(selecteddate[0]);
                            todocontroller.onchangeselectedate(selecteddate[0]);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // NOTE list Of Tasks
                      Expanded(
                          child: todocontroller
                              .screens[todocontroller.currentIndex]),
                    ],
                  ),
                ),
        ),

        //NOTE bottom navigation
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: todocontroller.currentIndex,
          onTap: (index) {
            todocontroller.onchangeIndex(index);
          },
          items: todocontroller.bottomItems,
        ),
      ),
    );
  }

  _appbar(TodoLayoutController todocontroller, BuildContext context) => AppBar(
        title: Text(
          todocontroller.appbar_title[todocontroller.currentIndex],
          style: Theme.of(context).textTheme.headline5,
        ),
        actions: [
          IconButton(
            onPressed: () {
              //TODO: search screen
              Get.to(() => SearchEvents());
              //NotificationApi.shownotification();
            },
            icon: Icon(
              Get.isDarkMode ? Icons.search : Icons.search,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {
              todocontroller.onchangeThem();
            },
            icon: Icon(
              Get.isDarkMode ? Icons.wb_sunny : Icons.mode_night,
              size: 30,
            ),
          ),
          SizedBox(
            width: 20,
          )
        ],
      );

  _drawer(BuildContext context) {
    bool isLoggedIn = false;
    // String username = "";

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user != null) {
      isLoggedIn = true;

      // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      // final docRef = _firestore.collection("users").doc(user.uid);
      //
      // docRef.get().then((DocumentSnapshot doc) {
      //   if (doc.exists) {
      //     // Ensure you update the state within the build method
      //     // to reflect changes in the UI
      //     username = doc['name'];
      //     print(username);
      //   } else {
      //     print('Document does not exist');
      //   }
      // }).catchError((e) {
      //   print("Error getting document: $e");
      // });
    }
    return Drawer(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(gradient: orangeGradient),
            padding: EdgeInsets.only(left: 15, right: 15, top: 40),
            height: 160,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    children: [
                      CircleAvatar(
                          backgroundImage:
                          AssetImage('assets/default profile.png')),
                      SizedBox(
                        width: 10,
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () async {
                          if (isLoggedIn) {
                            // signed in
                            isLoggedIn = true;
                            // sync
                            await todocontroller.syncWithFirebase();
                          } else {
                            // signed out
                            isLoggedIn = false;
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => const LoginPage()),
                            // );
                            Navigator.pushNamed(context, '/login');
                          }
                        },
                        icon: Icon(isLoggedIn ? Icons.cloud : Icons.login_rounded),
                        color: Colors.grey.shade200,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  // isLoggedIn ? username : "SIGN IN",
                  "SIGN IN",
                  style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
                ),
                Text(
                  isLoggedIn
                      ? "Synchronization enabled..."
                      : "Synchronization disabled...",
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              Get.to(ClearData());
            },
            leading: Icon(Icons.delete),
            title: Text("Clear Local Data"),
          ),
          Visibility(
            visible: isLoggedIn, // Set this to your isloggedin variable
            child: ListTile(
              onTap: () async {
                await todocontroller.deleteFirebaseData();
              },
              leading: Icon(Icons.delete),
              title: Text("Clear Cloud Data"),
            ),
          ),

          Divider(),
          ListTile(
            onTap: () {},
            leading: Icon(Icons.search),
            title: Text("Search"),
          ),
          Divider(),
          ListTile(
            onTap: () {
              if (isLoggedIn) {
                // signed in
                isLoggedIn = true;
                FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, '/home');
                showToast(message: "Successfully signed out");
                // sync
              } else {
                // signed out
                isLoggedIn = false;
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => const LoginPage()),
                // );
                Navigator.pushNamed(context, '/login');
              }
            },
            leading: Icon(isLoggedIn ? Icons.logout_rounded : Icons.login_rounded),
            title: Text(isLoggedIn ? "Logout" : "Login"),
          ),
        ],
      ),
    );
  }
}
