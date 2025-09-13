import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ovorideuser/core/route/route.dart';
import 'package:ovorideuser/core/utils/dimensions.dart';
import 'package:ovorideuser/core/utils/my_color.dart';
import 'package:ovorideuser/core/utils/my_icons.dart';
import 'package:ovorideuser/core/utils/my_strings.dart';
import 'package:ovorideuser/core/utils/style.dart';
import 'package:ovorideuser/data/controller/auth/login_controller.dart';
import 'package:ovorideuser/data/controller/auth/social_auth_controller.dart';
import 'package:ovorideuser/data/repo/auth/login_repo.dart';
import 'package:ovorideuser/data/repo/auth/socail_repo.dart';
import 'package:ovorideuser/presentation/components/buttons/rounded_button.dart';
import 'package:ovorideuser/presentation/components/image/custom_svg_picture.dart';
import 'package:ovorideuser/presentation/components/text-form-field/custom_text_field.dart';
import 'package:ovorideuser/presentation/components/text/default_text.dart';
import 'package:ovorideuser/presentation/components/will_pop_widget.dart';

import '../../../../core/utils/my_images.dart';
import '../../../components/divider/custom_spacer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Get.put(LoginRepo(apiClient: Get.find()));
    Get.put(LoginController(loginRepo: Get.find()));
    Get.put(SocialAuthRepo(apiClient: Get.find()));
    Get.put(SocialAuthController(authRepo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<LoginController>().remember = false;
    });
  }

  void showLocationPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black12,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.green,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  "Location Access Required",
                  style: boldLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Main message
                Text(
                  "To give you the best riding experience, this app needs access to your location.\n\n"
                      "📍 Accurate pickup and drop-off\n"
                      "🛵 Real-time ride tracking\n"
                      "✅ Better and safer service",
                  style: boldLarge.copyWith(
                    fontSize: 14,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Privacy note
                Text(
                  "Your location will only be used for ride-related services and never shared without your permission.",
                  style: boldSmall.copyWith(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Allow button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // 🔑 Call location permission request here
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: MyColor.primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Allow Location Access",
                      style: boldSmall.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: WillPopWidget(
        nextRoute: '',
        child: Scaffold(
          backgroundColor: MyColor.colorWhite,
          body: GetBuilder<LoginController>(
            builder: (controller) => SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: Dimensions.screenPaddingHV,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        MyImages.appLogoWhite,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        height: 130,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: Dimensions.space15,
                        vertical: Dimensions.space10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          spaceDown(Dimensions.space20),
                          Text(
                            MyStrings.loginScreenTitle.tr,
                            style: boldExtraLarge.copyWith(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: Dimensions.space5),
                          Text(
                            MyStrings.loginScreenSubTitle.tr,
                            style: lightDefault.copyWith(
                              color: MyColor.bodyText,
                              fontSize: Dimensions.fontLarge,
                            ),
                          ),
                          spaceDown(Dimensions.space20),
                          // SocialAuthSection(),
                          Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                spaceDown(Dimensions.space20),
                                CustomTextField(
                                  animatedLabel: true,
                                  needOutlineBorder: true,
                                  controller: controller.emailController,
                                  labelText: MyStrings.usernameOrEmail.tr,
                                  onChanged: (value) {},
                                  focusNode: controller.emailFocusNode,
                                  nextFocus: controller.passwordFocusNode,
                                  textInputType: TextInputType.emailAddress,
                                  inputAction: TextInputAction.next,
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                    ),
                                    child: CustomSvgPicture(
                                      image: MyIcons.user,
                                      color: MyColor.primaryColor,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return MyStrings.fieldErrorMsg.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                spaceDown(Dimensions.space20),
                                CustomTextField(
                                  animatedLabel: true,
                                  needOutlineBorder: true,
                                  labelText: MyStrings.password.tr,
                                  controller: controller.passwordController,
                                  focusNode: controller.passwordFocusNode,
                                  onChanged: (value) {},
                                  isShowSuffixIcon: true,
                                  isPassword: true,
                                  textInputType: TextInputType.text,
                                  inputAction: TextInputAction.done,
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                    ),
                                    child: CustomSvgPicture(
                                      image: MyIcons.password,
                                      color: MyColor.primaryColor,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return MyStrings.fieldErrorMsg.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                spaceDown(Dimensions.space15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: Dimensions.space15,
                                          height: 25,
                                          child: Checkbox(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                Dimensions.space5,
                                              ),
                                            ),
                                            activeColor: MyColor.primaryColor,
                                            checkColor: MyColor.colorWhite,
                                            value: controller.remember,
                                            side: WidgetStateBorderSide.resolveWith(
                                              (states) => BorderSide(
                                                width: 1.0,
                                                color: controller.remember ? MyColor.getTextFieldEnableBorder() : MyColor.getTextFieldDisableBorder(),
                                              ),
                                            ),
                                            onChanged: (value) {
                                              controller.changeRememberMe();
                                            },
                                          ),
                                        ),
                                        spaceSide(Dimensions.space8),
                                        InkWell(
                                          onTap: () {
                                            controller.changeRememberMe();
                                          },
                                          splashFactory: NoSplash.splashFactory,
                                          child: DefaultText(
                                            text: MyStrings.rememberMe.tr,
                                            textColor: MyColor.getBodyTextColor(),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.clearTextField();
                                        Get.toNamed(
                                          RouteHelper.forgotPasswordScreen,
                                        );
                                      },
                                      child: DefaultText(
                                        text: MyStrings.forgotPassword.tr,
                                        textColor: MyColor.redCancelTextColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                spaceDown(Dimensions.space25),
                                RoundedButton(
                                  isLoading: controller.isSubmitLoading,
                                  text: MyStrings.signIn.tr,
                                  press: () {
                                    if (formKey.currentState!.validate()) {
                                      controller.loginUser();
                                    }
                                  },
                                ),
                                spaceDown(Dimensions.space30),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      MyStrings.doNotHaveAccount.tr,
                                      overflow: TextOverflow.ellipsis,
                                      style: regularLarge.copyWith(
                                        color: MyColor.getBodyTextColor(),
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: Dimensions.space5,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.offAndToNamed(
                                          RouteHelper.registrationScreen,
                                        );
                                      },
                                      child: Text(
                                        MyStrings.signUp.tr,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: boldLarge.copyWith(
                                          color: MyColor.getPrimaryColor(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
