import 'package:car_fix_up/Routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class LiveDignosticView extends StatelessWidget {
  const LiveDignosticView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ZegoSendCallInvitationButton(
          onPressed: (String value1, String value2, List<String> value3) {
            Get.toNamed(RouteName.videoCall, arguments: "sos_call");
          },
          isVideoCall: true,
          //You need to use the resourceID that you created in the subsequent steps.
          //Please continue reading this document.
          resourceID: "car_fix_up",
          invitees: [
            ZegoUIKitUser(
              id: "101",
              name: "vendor@test.com",
            ),
          ],
        ),
      ),
    );
  }
}
