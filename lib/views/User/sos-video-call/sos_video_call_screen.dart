import 'package:car_fix_up/resources/constatnt.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class SosVideoCalScreem extends StatefulWidget {
  const SosVideoCalScreem({super.key});

  @override
  State<SosVideoCalScreem> createState() => _SosVideoCalScreemState();
}

class _SosVideoCalScreemState extends State<SosVideoCalScreem> {
  String localUser = math.Random().nextInt(10000).toString();
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZegoUIKitPrebuiltCall(
        plugins: [
          ZegoUIKitSignalingPlugin(),
        ],
        appID:
            kAppID, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
        appSign:
            kAppSign, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
        userID: '101',
        userName: 'user_101',
        callID:
            'sos_call', // Fill in the callID that you get from ZEGOCLOUD Admin Console.
        // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
      ),
    );
  }
}
