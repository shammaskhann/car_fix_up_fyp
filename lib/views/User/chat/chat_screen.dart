import 'dart:developer';

import 'package:car_fix_up/controller/user_controller.dart';
import 'package:car_fix_up/model/Chat/Message.model.dart';
import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/shared/common_method.dart';
import 'package:car_fix_up/views/User/chat/controller/chat_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChatView extends StatefulWidget {
  final String uid;

  const ChatView({required this.uid, super.key});

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late ChatViewController _chatViewController;
  late TextEditingController _messageController;
  UserController userController = Get.find<UserController>();
  RxString name = ''.obs;
  RxString imageUrl = ''.obs;
  RxString deviceToken = ''.obs;
  RxBool isLoading = false.obs; // Use RxBool for loading state

  @override
  void initState() {
    super.initState();
    _chatViewController = ChatViewController();
    _messageController = TextEditingController();
    _chatViewController.getChatUserInfo(widget.uid).then((value) {
      log("User Info: ${value.toString()}");

      try {
        imageUrl.value = value['workshop']['imageUrl'];
      } catch (e) {
        imageUrl.value = "";
      }
      log("User Type ${userController.userType}");

      name.value = value['name'];

      deviceToken.value = value['deviceToken'];
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //("Widget Build");
    final auth = FirebaseAuth.instance.currentUser;
    UserController userController = Get.find<UserController>();
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Container(
          padding: EdgeInsets.only(left: 0.05.sw, right: 0.05.sw, top: 0.05.sh),
          height: 1.sh,
          width: 1.sw,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Get.back();
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                Row(children: [
                  CircleAvatar(
                      radius: 0.03.sh,
                      backgroundColor: Colors.transparent,
                      child: Obx(() => ClipOval(
                          child: imageUrl.value == ""
                              ? CircleAvatar(
                                  // radius: 0.02.sh,
                                  backgroundColor: kPrimaryColor,
                                  child: Icon(
                                    Icons.person,
                                    color: kWhiteColor,
                                  ),
                                )
                              : Image.network(
                                  imageUrl.value,
                                  width: 0.1.sw,
                                  height: 0.1.sw,
                                  fit: BoxFit.cover,
                                )))),
                  const SizedBox(
                    width: 10,
                  ),
                  Obx(
                    () => Text(
                      name.value == "" ? "" : name.value,
                      style: GoogleFonts.oxanium(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: kBlackColor),
                    ),
                  )
                ]),
                const Spacer(),
              ],
            ),
            Expanded(
              child: StreamBuilder<List<Message>?>(
                stream: _chatViewController.getMessages(widget.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: kPrimaryColor,
                      ),
                    );
                  }

                  if (snapshot.hasData) {
                    final reversedMessages = snapshot.data!.reversed.toList();
                    return ListView.builder(
                      reverse: true,
                      itemCount: reversedMessages.length,
                      itemBuilder: (context, index) {
                        //log('TimeStamp of recent message ${reversedMessages[index].message}: ${reversedMessages[index].timestamp}');
                        final String messageID =
                            reversedMessages[index].messageId;
                        final String message = reversedMessages[index].message;
                        final String sender = reversedMessages[index].senderUid;
                        // ignore: unused_local_variable
                        final String reciever =
                            reversedMessages[index].recieverUid;
                        final bool isMyMessage = sender == auth!.uid;
                        final Timestamp? timeStamp =
                            reversedMessages[index].timestamp ??
                                Timestamp.now();
                        // ignore: unused_local_variable
                        final bool isMedia = reversedMessages[index].isMedia;
                        final bool isRead = reversedMessages[index].isRead;
                        //log("Message: $message ${isMyMessage.toString()}");
                        if (!isMyMessage) {
                          _chatViewController.markMessageAsRead(sender);
                        }
                        return ChatMessageWidget(
                          messageID: messageID,
                          message: message,
                          isMyMessage: isMyMessage,
                          isRead: isRead,
                          timeStamp: timeStamp ?? Timestamp.now(),
                        );
                      },
                    );
                  }
                  if (snapshot.hasError) {
                    //log("Error: ${snapshot.error}");
                    return const Center(
                      child: Text('Something went wrong',
                          style: TextStyle(color: kBlackColor)),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'No Messages Yet',
                        style: GoogleFonts.oxanium(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: kBlackColor),
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: kPrimaryColor,
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    height: 0.06.sh,
                    decoration: BoxDecoration(
                      color: const Color(0xFF596787),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(children: [
                      SizedBox(
                        width: 0.02.sw,
                      ),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          style: GoogleFonts.oxanium(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: kWhiteColor),
                          controller: _messageController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Type a message',
                            // hintStyle: TextStyle(
                            //   fontFamily: 'Mont',
                            //   color: Colors.grey,
                            // ),
                            hintStyle: GoogleFonts.oxanium(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 0.06.sh,
                        width: 0.12.sw,
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Obx(() => IconButton(
                              onPressed: isLoading.value
                                  ? null
                                  : () async {
                                      if (_messageController.text.isEmpty) {
                                        return;
                                      } else {
                                        isLoading.value = true;
                                        String senderName = userController.name;
                                        if (deviceToken.value == "") {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'User is not available to chat'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        } else {
                                          await _chatViewController.sendMessage(
                                              widget.uid, _messageController);
                                          await _chatViewController
                                              .sendNotification(
                                                  deviceToken.value,
                                                  "Message from $senderName",
                                                  _messageController.text,
                                                  widget.uid);
                                        }
                                        _messageController.clear();
                                        isLoading.value = false;
                                      }
                                    },
                              icon: const Icon(
                                Icons.send,
                                color: kWhiteColor,
                              ),
                            )),
                      ),
                    ]),
                  ),
                ),
                SizedBox(
                  width: 0.01.sw,
                ),
                // Container(
                //   height: 0.06.sh,
                //   width: 0.12.sw,
                //   decoration: BoxDecoration(
                //     color: kPrimaryColor,
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   child: IconButton(
                //     onPressed: () {},
                //     icon: const Icon(
                //       Icons.add,
                //       color: kWhiteColor,
                //     ),
                //   ),
                // ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
          ])),
    );
  }
}

// ignore: must_be_immutable
class ChatMessageWidget extends StatelessWidget {
  final String messageID;
  final String message;
  final bool isMyMessage;
  final bool isRead;
  Timestamp? timeStamp;
  ChatMessageWidget(
      {required this.messageID,
      required this.message,
      required this.isMyMessage,
      required this.isRead,
      this.timeStamp,
      super.key});

  @override
  Widget build(BuildContext context) {
    timeStamp ??= Timestamp.now();
    String formattedTime = DateFormat('hh:mm a')
        .format(timeStamp?.toDate() ?? Timestamp.now().toDate());

    return Padding(
        padding: EdgeInsets.only(left: 0.01.sw, right: 0.01.sw, top: 0.01.sh),
        child: Column(
          crossAxisAlignment:
              isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding:
                  const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 5),
              decoration: BoxDecoration(
                color: isMyMessage ? const Color(0xFF596787) : kBlackColor,
                borderRadius: isMyMessage
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      )
                    : const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      message,
                      style: GoogleFonts.oxanium(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: isMyMessage ? kWhiteColor : kWhiteColor),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: isMyMessage
                        ? isRead
                            ? Icon(
                                Icons.done_all,
                                color: kPrimaryColor,
                                size: 10.sp,
                              )
                            : Icon(
                                Icons.done,
                                color: kWhiteColor,
                                size: 10.sp,
                              )
                        : const SizedBox(),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              formattedTime,
              style: GoogleFonts.oxanium(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: kBlackColor),
            ),
          ],
        ));
  }
}
