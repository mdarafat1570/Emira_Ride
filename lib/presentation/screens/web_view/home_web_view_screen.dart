import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:ovorideuser/core/utils/my_color.dart';
import 'package:ovorideuser/core/utils/my_icons.dart';
import 'package:ovorideuser/core/utils/my_images.dart';
import 'package:ovorideuser/core/utils/style.dart';
import 'package:ovorideuser/data/controller/account/profile_controller.dart';
import 'package:ovorideuser/data/controller/location/app_location_controller.dart';
import 'package:ovorideuser/presentation/components/image/custom_svg_picture.dart';
import 'package:ovorideuser/presentation/components/image/my_network_image_widget.dart';

class HomeWebViewScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? dashBoardScaffoldKey;

  const HomeWebViewScreen({super.key, this.dashBoardScaffoldKey});

  @override
  State<HomeWebViewScreen> createState() => _HomeWebViewScreenState();
}

class _HomeWebViewScreenState extends State<HomeWebViewScreen> {
  final GlobalKey _webViewKey = GlobalKey();
  bool _isLoading = true;

  final InAppWebViewSettings _settings = InAppWebViewSettings(
    javaScriptEnabled: true,
    allowFileAccess: true,
    allowsInlineMediaPlayback: true,
    useHybridComposition: true,
    useShouldOverrideUrlLoading: true,
    mediaPlaybackRequiresUserGesture: false,
  );

  String _buildUrl() {
    final profile = Get.find<ProfileController>();
    final location = Get.find<AppLocationController>();
    final mobile = profile.user.mobile ?? '';
    final lat = location.currentPosition.latitude;
    final lng = location.currentPosition.longitude;
    return 'https://nmc24.com/app?gid=$mobile&lat=$lat&lng=$lng';
  }

  void _openDrawer() {
    widget.dashBoardScaffoldKey?.currentState?.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (profileController) {
        if (profileController.isLoading) {
          return const Center(child: CircularProgressIndicator(color: MyColor.primaryColor));
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: MyColor.primaryColor,
            elevation: 0,
            automaticallyImplyLeading: false,
            titleSpacing: 12,
            title: Row(
              children: [
                Container(
                  height: 36,
                  width: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white24,
                  ),
                  child: ClipOval(
                    child: MyImageWidget(
                      imageUrl: profileController.imageUrl,
                      boxFit: BoxFit.cover,
                      height: 36,
                      width: 36,
                      isProfile: true,
                      errorWidget: Image.asset(
                        MyImages.defaultAvatar,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${profileController.user.firstname ?? ''} ${profileController.user.lastname ?? ''}'.trim(),
                        style: boldDefault.copyWith(color: Colors.white, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      GetBuilder<AppLocationController>(
                        builder: (locationController) {
                          return Text(
                            locationController.currentAddress,
                            style: regularDefault.copyWith(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: _openDrawer,
                icon: CustomSvgPicture(
                  image: MyIcons.sideMenu,
                  color: Colors.white,
                  height: 22,
                  width: 22,
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              InAppWebView(
                key: _webViewKey,
                initialUrlRequest: URLRequest(url: WebUri(_buildUrl())),
                initialSettings: _settings,
                onWebViewCreated: (controller) {},
                onLoadStart: (controller, url) {
                  setState(() => _isLoading = true);
                },
                onLoadStop: (controller, url) {
                  setState(() => _isLoading = false);
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  final uri = navigationAction.request.url!;
                  if (!['http', 'https', 'file', 'chrome', 'data', 'javascript', 'about'].contains(uri.scheme)) {
                    return NavigationActionPolicy.CANCEL;
                  }
                  return NavigationActionPolicy.ALLOW;
                },
              ),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(color: MyColor.primaryColor),
                ),
            ],
          ),
        );
      },
    );
  }
}
