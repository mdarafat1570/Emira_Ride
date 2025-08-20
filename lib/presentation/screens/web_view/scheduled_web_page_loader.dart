import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovorideuser/data/controller/account/profile_controller.dart';
import 'package:ovorideuser/presentation/screens/web_view/new_settings_webview/all_web_view_page.dart';

class ScheduledWebPageLoader extends StatelessWidget {
  const ScheduledWebPageLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) {
        if (controller.isLoading || (controller.user.mobile?.isEmpty ?? true)) {
          return const Center(child: CircularProgressIndicator());
        } else {
          print("User mobile number: ${controller.user.mobile}");
          return ScheduledWebPage(mobileNumber: controller.user.mobile ?? '');
        }
      },
    );
  }
}