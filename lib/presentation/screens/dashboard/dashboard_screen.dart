import 'package:get/get.dart';
import 'package:ovorideuser/core/utils/my_icons.dart';
import 'package:ovorideuser/core/utils/my_strings.dart';
import 'package:ovorideuser/data/controller/account/profile_controller.dart'; // Import ProfileController
import 'package:ovorideuser/data/controller/menu/my_menu_controller.dart';
import 'package:ovorideuser/data/controller/pusher/global_pusher_controller.dart';
import 'package:ovorideuser/data/repo/account/profile_repo.dart'; // Import ProfileRepo
import 'package:ovorideuser/data/repo/auth/general_setting_repo.dart';
import 'package:ovorideuser/data/repo/menu_repo/menu_repo.dart';
import 'package:ovorideuser/presentation/components/annotated_region/annotated_region_widget.dart';
import 'package:ovorideuser/presentation/components/image/custom_svg_picture.dart';
import 'package:ovorideuser/presentation/screens/home/home_screen.dart';
import 'package:ovorideuser/presentation/screens/profile_and_settings/profile_and_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ovorideuser/presentation/screens/web_view/scheduled_web_page_loader.dart';
import '../../../core/utils/dimensions.dart';
import '../../../core/utils/my_color.dart';
import '../../components/will_pop_widget.dart';
import '../../packages/flutter_floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import '../drawer/drawer_screen.dart';
import '../inter_city/inter_city_screen.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  late GlobalKey<ScaffoldState> _dashBoardScaffoldKey;
  late List<Widget> _widgets;
  int selectedIndex = 0;

  @override
  void initState() {
    int index = Get.arguments ?? 0;
    selectedIndex = index;
    super.initState();

    Get.put(GeneralSettingRepo(apiClient: Get.find()));
    Get.put(MenuRepo(apiClient: Get.find()));
    Get.put(MyMenuController(menuRepo: Get.find(), repo: Get.find()));
    Get.put(ProfileRepo(apiClient: Get.find()));
    final profileController = Get.put(ProfileController(profileRepo: Get.find()));

    final pusherController = Get.put(GlobalPusherController(apiClient: Get.find()));
    _dashBoardScaffoldKey = GlobalKey<ScaffoldState>();

    _widgets = <Widget>[
      HomeScreen(dashBoardScaffoldKey: _dashBoardScaffoldKey),
      InterCityScreen(dashBoardScaffoldKey: _dashBoardScaffoldKey),
      const ScheduledWebPageLoader(), 
      const ProfileAndSettingsScreen(),
    ];

    WidgetsBinding.instance.addPostFrameCallback((t) {
      profileController.loadProfileInfo();
      pusherController.ensureConnection();
    });
  }

  void closeDrawer() {
    _dashBoardScaffoldKey.currentState!.closeEndDrawer();
  }

  void changeScreen(int val) {
    setState(() {
      selectedIndex = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyMenuController>(
      builder: (controller) {
        return Scaffold(
          key: _dashBoardScaffoldKey,
          extendBody: true,
          endDrawer: AppDrawerScreen(
            closeFunction: closeDrawer,
            callback: (val) {
              selectedIndex = val;
              setState(() {});
              closeDrawer();
            },
          ),
          body: WillPopWidget(child: _widgets[selectedIndex]),
          bottomNavigationBar: AnnotatedRegionWidget(
            child: FloatingNavbar(
              inLine: true,
              fontSize: Dimensions.fontMedium,
              backgroundColor: MyColor.colorWhite,
              unselectedItemColor: MyColor.bodyText,
              selectedItemColor: MyColor.primaryColor,
              borderRadius: Dimensions.space50,
              itemBorderRadius: Dimensions.space50,
              selectedBackgroundColor: MyColor.primaryColor.withValues(
                alpha: 0.09,
              ),
              onTap: (int val) {
                controller.repo.apiClient.storeCurrentTab(val.toString());
                changeScreen(val);
              },
              margin: const EdgeInsetsDirectional.only(
                start: Dimensions.space20,
                end: Dimensions.space20,
                bottom: Dimensions.space15,
              ),
              currentIndex: selectedIndex,
              items: [
                FloatingNavbarItem(
                  icon: LineIcons.home,
                  title: MyStrings.city.tr,
                  customWidget: CustomSvgPicture(
                    image: MyIcons.cityHome,
                    color: selectedIndex == 0 ? MyColor.primaryColor : MyColor.colorGreyIcon,
                  ),
                ),
                FloatingNavbarItem(
                  icon: LineIcons.city,
                  title: MyStrings.interCity_.tr,
                  customWidget: CustomSvgPicture(
                    image: MyIcons.intercityHome,
                    color: selectedIndex == 1 ? MyColor.primaryColor : MyColor.colorGreyIcon,
                  ),
                ),
                FloatingNavbarItem(
                  icon: LineIcons.calendar, // Changed icon for clarity
                  title: MyStrings.preBookSubTitle.tr,
                  customWidget: CustomSvgPicture(
                    image: MyIcons.hourlyTime, // Changed icon for clarity
                    color: selectedIndex == 2 ? MyColor.primaryColor : MyColor.colorGreyIcon,
                  ),
                ),
                FloatingNavbarItem(
                  icon: LineIcons.user, // Changed icon for clarity
                  title: MyStrings.menu.tr, // This corresponds to the Profile/Settings screen
                  customWidget: CustomSvgPicture(
                    image: MyIcons.menu1,
                    color: selectedIndex == 3 ? MyColor.primaryColor : MyColor.colorGreyIcon,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}