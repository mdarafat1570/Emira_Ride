import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovorideuser/core/utils/my_icons.dart';
import 'package:ovorideuser/core/utils/my_strings.dart';
import 'package:ovorideuser/data/controller/account/profile_controller.dart';
import 'package:ovorideuser/data/controller/menu/my_menu_controller.dart';
import 'package:ovorideuser/data/controller/pusher/global_pusher_controller.dart';
import 'package:ovorideuser/data/repo/account/profile_repo.dart';
import 'package:ovorideuser/data/repo/auth/general_setting_repo.dart';
import 'package:ovorideuser/data/repo/menu_repo/menu_repo.dart';
import 'package:ovorideuser/presentation/components/annotated_region/annotated_region_widget.dart';
import 'package:ovorideuser/presentation/components/image/custom_svg_picture.dart';
import 'package:ovorideuser/presentation/screens/home/home_screen.dart';
import 'package:ovorideuser/presentation/screens/profile_and_settings/profile_and_settings_screen.dart';
import 'package:ovorideuser/presentation/screens/web_view/scheduled_web_page_loader.dart';
import 'package:ovorideuser/core/utils/my_color.dart';
import 'package:ovorideuser/presentation/components/will_pop_widget.dart';
import 'package:ovorideuser/presentation/screens/drawer/drawer_screen.dart';
import 'package:ovorideuser/presentation/screens/inter_city/inter_city_screen.dart';

// This is a custom widget created to match the design of the first code snippet's navigation item.
class NavBarItem extends StatelessWidget {
  final String imagePath;
  final String label;
  final bool isSelected;
  final VoidCallback press;
  final int index;

  const NavBarItem({
    super.key,
    required this.imagePath,
    required this.label,
    required this.isSelected,
    required this.press,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: press,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomSvgPicture(
              image: imagePath,
              height: 20,
              width: 20,
              color: isSelected ? MyColor.primaryColor : MyColor.colorGreyIcon,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? MyColor.primaryColor : MyColor.colorGreyIcon,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }
}

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
    Get.find<MyMenuController>().repo.apiClient.storeCurrentTab(val.toString());
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
              setState(() {
                selectedIndex = val;
              });
              closeDrawer();
            },
          ),
          body: WillPopWidget(child: _widgets[selectedIndex]),
          bottomNavigationBar: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.zero,
            child: AnnotatedRegionWidget(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
                margin: const EdgeInsets.only(bottom: 13, left: 10, right: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: MyColor.colorWhite,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: const [BoxShadow(color: Color.fromARGB(20, 0, 0, 0), offset: Offset(0, 3), blurRadius: 1)],
                ),
                height: 55,
                width: Get.context?.width ?? double.maxFinite,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    NavBarItem(
                      label: MyStrings.city.tr,
                      imagePath: MyIcons.cityHome,
                      index: 0,
                      isSelected: selectedIndex == 0,
                      press: () => changeScreen(0),
                    ),
                    NavBarItem(
                      label: MyStrings.interCity_.tr,
                      imagePath: MyIcons.intercityHome,
                      index: 1,
                      isSelected: selectedIndex == 1,
                      press: () => changeScreen(1),
                    ),
                    NavBarItem(
                      label: MyStrings.preBookSubTitle.tr,
                      imagePath: MyIcons.hourlyTime,
                      index: 2,
                      isSelected: selectedIndex == 2,
                      press: () => changeScreen(2),
                    ),
                    NavBarItem(
                      label: MyStrings.menu.tr,
                      imagePath: MyIcons.menu1,
                      index: 3,
                      isSelected: selectedIndex == 3,
                      press: () => changeScreen(3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}