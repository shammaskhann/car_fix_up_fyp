import 'dart:async';
import 'dart:developer';

import 'package:car_fix_up/Routes/routes.dart';
import 'package:car_fix_up/controller/chat_controller.dart';
import 'package:car_fix_up/controller/user_controller.dart';
import 'package:car_fix_up/model/User/user.model.dart';
import 'package:car_fix_up/model/Vendor/vendor.model.dart';
import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/services/chat/chat_services.dart';
import 'package:car_fix_up/services/firebase/user/user_services.dart';
import 'package:car_fix_up/services/firebase/vendors/vendor_services.dart';
import 'package:car_fix_up/views/User/profile/customer_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find<UserController>();

    return Scaffold(
        backgroundColor: kWhiteColor,
        body: Stack(
          children: [
            ClipPath(
                clipper: BottomCurveClipper(),
                child: Container(
                  height: 0.25.sh,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [kBlackColor, Colors.grey[800]!],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 0.05.sh),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.menu_rounded),
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                              color: Colors.white,
                            ),
                            IconButton(
                              icon: const Icon(Icons.person),
                              onPressed: () {
                                Get.to(() => const CustomerProfileScreen());
                              },
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.02.sh),
                        child: Text(
                          "Chat",
                          style: GoogleFonts.oxanium(
                            color: kPrimaryColor,
                            fontSize: 0.06.sw,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            Container(
              height: 0.74.sh,
              padding: EdgeInsets.only(top: 0.19.sh),
              child: FutureBuilder(
                future: userController.userType == UserType.user
                    ? VendorServices().getAllVendors()
                    : UserServices().getAllUsers(),
                builder: (context, snapshot) {
                  log('User Type: ${userController.userType}');
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  if (snapshot.data == null) {
                    return const Center(
                      child: Text('No users found'),
                    );
                  }
                  return (userController.userType == UserType.user)
                      ? ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final Vendor vendor =
                                snapshot.data![index] as Vendor;
                            return MessengerTile(
                                uid: vendor.uid,
                                name: vendor.name,
                                imageUrl: vendor.workshop.imageUrl);
                          },
                        )
                      : ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final UserModel user =
                                snapshot.data![index] as UserModel;
                            return MessengerTile(
                                uid: user.uid,
                                name: user.name,
                                imageUrl: "null");
                          },
                        );
                },
              ),
            ),
          ],
        ));
  }
}

class MessengerTile extends StatelessWidget {
  final String uid;
  final String name;
  final String imageUrl;
  const MessengerTile(
      {required this.uid,
      required this.name,
      required this.imageUrl,
      super.key});

  @override
  Widget build(BuildContext context) {
    RxBool noLastMessage = false.obs;
    ChatController chatController = ChatController();

    String _getMessage(AsyncSnapshot snapshot) {
      if (snapshot.data!.docs.isEmpty) {
        noLastMessage = true.obs;
        return "No message";
      }
      bool isMedia = snapshot.data!.docs[0]['isMedia'];
      String msg = snapshot.data!.docs[0]['message'];
      if (isMedia) {
        if (msg.contains('.mp3')) {
          return "Voice Note";
        } else {
          return "Photo";
        }
      }
      return msg;
    }

    Widget _buildTimeWidget(AsyncSnapshot snapshot) {
      Timestamp timestamp;
      if (snapshot.data!.docs.isEmpty) {
        return const Text("");
      }
      timestamp = snapshot.data!.docs[0]['timestamp'];
      final dateTime = (timestamp != null && timestamp is Timestamp)
          ? timestamp.toDate()
          : DateTime.now();
      final difference = DateTime.now().difference(dateTime);
      String displayTime;
      if (difference.inDays == 1) {
        displayTime = 'Yesterday';
      } else if (difference.inDays < 7) {
        displayTime = DateFormat('EEEE').format(dateTime); // Weekday name
      } else {
        displayTime = DateFormat('dd MMM').format(dateTime); // Date and month
      }
      return Text(
        displayTime,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      );
    }

    Widget _buildNewMessageCountWidget(String uid) {
      return StreamBuilder(
        stream: chatController.noOfNewMessage(uid),
        builder: (context, AsyncSnapshot snapshot) {
          log('No of new messages: ${snapshot.data?.docs.length}',
              name: 'ChatListView');
          int count = snapshot.data?.docs.length ?? 0;
          if (snapshot.connectionState == ConnectionState.waiting ||
              count == 0) {
            return const Text("");
          }
          return CircleAvatar(
            radius: 10,
            backgroundColor: kPrimaryColor,
            child: Text(
              count.toString(),
              style: const TextStyle(
                color: kWhiteColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      );
    }

    return StreamBuilder(
        stream: chatController.isChatInitiated(uid),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return const Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }
          return snapshot.data == true
              ? InkWell(
                  onTap: () => Get.toNamed(RouteName.chat, arguments: {
                    'uid': uid,
                  }),
                  child: Container(
                    height: 0.1.sh,
                    width: 1.sw,
                    margin: EdgeInsets.only(
                        top: 0.01.sh, left: 0.05.sw, right: 0.05.sw),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 0.05.sw,
                          backgroundColor: kPrimaryColor,
                          child: (imageUrl == "null")
                              ? const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                )
                              : ClipOval(
                                  child: Image.asset(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    width: 0.15.sw,
                                    height: 0.15.sw,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.person,
                                        size: 0.1.sw,
                                      );
                                    },
                                  ),
                                ),
                        ),
                        title: Text(
                          name,
                          style: GoogleFonts.oxanium(
                            color: kWhiteColor,
                            fontSize: 0.04.sw,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: StreamBuilder(
                          stream: chatController.lastMessege(uid),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text(
                                '...',
                                style: TextStyle(color: Colors.white),
                              );
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            if (snapshot.data == null) {
                              return const Text('No messages found');
                            }
                            return Text(
                              _getMessage(snapshot),
                              style: GoogleFonts.oxanium(
                                color: kWhiteColor,
                                fontSize: 0.03.sw,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // _buildTimeWidget(snapshot),
                            // SizedBox(
                            //   height: 0.01.sh,
                            // ),
                            _buildNewMessageCountWidget(uid),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink();
        });
  }
}
