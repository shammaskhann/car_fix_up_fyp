import 'dart:developer';

import 'package:car_fix_up/model/Chat/Message.model.dart';
import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/views/User/chat/controller/chat_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatView extends StatefulWidget {
  final String uid;
  final String name;
  final String imageUrl;
  const ChatView(
      {required this.uid, required this.name, required this.imageUrl, Key? key})
      : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late ChatViewController _chatViewController;
  late TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _chatViewController = ChatViewController();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("Widget Build");
    final auth = FirebaseAuth.instance.currentUser;
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
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                Row(children: [
                  CircleAvatar(
                    radius: 0.03.sh,
                    backgroundImage: AssetImage(widget.imageUrl),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.name,
                    style: GoogleFonts.oxanium(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: kBlackColor),
                  ),
                ]),
                const Spacer(),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: StreamBuilder<List<Message>?>(
                stream: _chatViewController.getMessages(widget.uid),
                builder: (context, snapshot) {
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
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: kPrimaryColor,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Something went wrong',
                          style: TextStyle(color: kBlackColor)),
                    );
                  }
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(
                              left: 0.05.sw, right: 0.05.sw, top: 0.02.sh),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 0.03.sh,
                                backgroundImage: AssetImage(widget.imageUrl),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: kBlackColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  snapshot.data![index].message,
                                  style: GoogleFonts.oxanium(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: kWhiteColor),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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
            SizedBox(
              height: 0.1.sh,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    height: 0.06.sh,
                    // width: 0.75.sw,
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
                          //onChanged: (value) => log(value),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Type a message',
                            hintStyle: TextStyle(
                              fontFamily: 'Mont',
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
                        child: IconButton(
                          onPressed: () {
                            if (_messageController.text.isEmpty) {
                              return;
                            } else {
                              log("Msg Send to Reciever: ${widget.uid}, Sender:${auth!.uid} Msg:${_messageController.text}");
                              _chatViewController.sendMessage(
                                  widget.uid, _messageController);
                              _messageController.clear();
                            }
                          },
                          icon: const Icon(
                            Icons.send,
                            color: kWhiteColor,
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
                SizedBox(
                  width: 0.01.sw,
                ),
                Container(
                  height: 0.06.sh,
                  width: 0.12.sw,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: () {
                      // if (_chatViewController.messageController.text.isEmpty) {
                      //   return;
                      // } else {
                      //   log("Msg Send to Reciever: ${widget.uid}, Sender:${auth!.uid} Msg:${_chatController.messageController.text}");
                      //   _chatController.sendMessage(widget.uid);
                      // }
                    },
                    icon: const Icon(
                      Icons.add,
                      color: kWhiteColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
          ])),
    );
  }
}
