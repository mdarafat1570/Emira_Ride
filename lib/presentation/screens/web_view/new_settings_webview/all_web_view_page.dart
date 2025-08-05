import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ovorideuser/core/utils/my_strings.dart';
import 'package:ovorideuser/presentation/screens/web_view/new_settings_webview/web_page_main.dart';

class MapWebPage extends StatelessWidget {
  const MapWebPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const WebViewPage(
      title: MyStrings.mapSubTitle,
      url: 'https://app.emiraride.com/map.php',
    );
  }
}

class HourlyWebPage extends StatelessWidget {
  const HourlyWebPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const WebViewPage(
      title: MyStrings.hourlySubTitle,
      url: 'https://app.emiraride.com/hourly.php',
    );
  }
}

class DailyWebPage extends StatelessWidget {
  const DailyWebPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const WebViewPage(
      title: MyStrings.dailySubTitle,
      url: 'https://app.emiraride.com/daily.php',
    );
  }
}

class RentWebPage extends StatelessWidget {
  const RentWebPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const WebViewPage(
      title: MyStrings.rentSubTitle,
      url: 'https://app.emiraride.com/rent.php',
    );
  }
}
