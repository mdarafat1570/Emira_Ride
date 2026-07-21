import 'package:flutter/material.dart';
import 'package:ovorideuser/core/utils/my_color.dart';
import 'package:ovorideuser/core/utils/my_strings.dart';
import 'package:ovorideuser/presentation/screens/web_view/new_settings_webview/web_page_main.dart'; 

class MapWebPage extends StatelessWidget {
  const MapWebPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const WebViewPage(
      appBarColor: MyColor.primaryColor,
      title: MyStrings.mapSubTitle,
      url: 'https://app.nmc24.com/map.php',
    );
  }
}

class HourlyWebPage extends StatelessWidget {
  final String mobileNumber;
  const HourlyWebPage({Key? key, required this.mobileNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebViewPage(
      appBarColor: MyColor.primaryColor,
      title: MyStrings.hourlySubTitle,
      url: 'https://app.nmc24.com/hourly.php?gid=$mobileNumber',
    );
  }
}

class DailyWebPage extends StatelessWidget {
  final String mobileNumber;
  const DailyWebPage({Key? key, required this.mobileNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebViewPage(
      appBarColor: MyColor.primaryColor,
      title: MyStrings.dailySubTitle,
      url: 'https://app.nmc24.com/daily.php?gid=$mobileNumber',
      showBackButton: false,
    );
  }
}

class RentWebPage extends StatelessWidget {
  const RentWebPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const WebViewPage(
      appBarColor: MyColor.primaryColor,
      title: MyStrings.rentSubTitle,
      url: 'https://app.nmc24.com/rent.php',
    );
  }
}

class ScheduledWebPage extends StatelessWidget {
  final String mobileNumber;

  const ScheduledWebPage({Key? key, required this.mobileNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebViewPage(
      appBarColor: MyColor.primaryColor,
      title: MyStrings.preBookSubTitle,
      url: 'https://app.nmc24.com/schedule.php?gid=$mobileNumber',
      appBar: true,
      showBackButton: false,
    );
  }
}

class OthersWebPage extends StatelessWidget {
  final String mobileNumber;
  const OthersWebPage({Key? key, required this.mobileNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebViewPage(
      title: MyStrings.othersSubTitle,
      appBarColor: MyColor.primaryColor,
      url: 'https://app.nmc24.com/others.php?gid=$mobileNumber',
    );
  }
}
