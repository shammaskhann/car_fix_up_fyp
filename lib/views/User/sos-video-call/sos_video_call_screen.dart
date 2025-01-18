import 'package:car_fix_up/resources/constatnt.dart';
import 'package:car_fix_up/services/notification/push_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class SosVideoCalScreem extends StatefulWidget {
  final String callId;
  const SosVideoCalScreem({required this.callId, super.key});

  @override
  State<SosVideoCalScreem> createState() => _SosVideoCalScreemState();
}

class _SosVideoCalScreemState extends State<SosVideoCalScreem> {
  String localUser = math.Random().nextInt(10000).toString();
  final user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZegoUIKitPrebuiltCall(
        appID:
            kAppID, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
        appSign:
            kAppSign, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
        userID: user!.uid,
        userName: user!.email!,
        callID: widget
            .callId, // Fill in the callID that you get from ZEGOCLOUD Admin Console.
        // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
      ),
    );
  }
}
