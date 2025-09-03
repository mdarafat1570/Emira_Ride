// import 'dart:io';
//
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:ovorideuser/core/helper/string_format_helper.dart';
// import 'package:ovorideuser/core/utils/my_strings.dart';
// import 'package:ovorideuser/core/utils/util.dart';
// import 'package:ovorideuser/presentation/components/snack_bar/show_custom_snackbar.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class AppLocationController extends GetxController {
//   Position currentPosition = MyUtils.getDefaultPosition();
//   String currentAddress = "Loading...";
//
//   Future<bool> checkPermission() async {
//     var status = await Geolocator.checkPermission();
//     if (status == LocationPermission.denied) {
//       var requestStatus = await Geolocator.requestPermission();
//       if (requestStatus == LocationPermission.whileInUse || requestStatus == LocationPermission.always) {
//         getCurrentPosition();
//       } else {
//         CustomSnackBar.error(errorList: ["Please enable location permission"]);
//       }
//     } else if (status == LocationPermission.deniedForever) {
//       CustomSnackBar.error(
//         errorList: [
//           "Location permission is permanently denied. Please enable it from settings.",
//         ],
//       );
//       if (Platform.isAndroid) {
//         // await openAppSettings();
//         await Geolocator.requestPermission();
//       }
//     } else if (status == LocationPermission.whileInUse) {
//       getCurrentPosition();
//     }
//     // CustomSnackBar.error(errorList: [MyStrings.locationPermissionPermanentDenied]);
//     return true;
//   }
//
//   Future<Position?> getCurrentPosition() async {
//     try {
//       final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
//       currentPosition = await geolocator.getCurrentPosition(
//         locationSettings: const LocationSettings(
//           accuracy: LocationAccuracy.best,
//         ),
//       );
//       final List<Placemark> placemarks = await placemarkFromCoordinates(
//         currentPosition.latitude,
//         currentPosition.longitude,
//       );
//       currentAddress = "";
//       currentAddress = "${placemarks[0].street} ${placemarks[0].subThoroughfare} ${placemarks[0].thoroughfare},${placemarks[0].subLocality},${placemarks[0].locality},${placemarks[0].country}";
//       update();
//       printX('appLocations possition $currentAddress');
//       return currentPosition;
//     } catch (e) {
//       CustomSnackBar.error(
//         errorList: [MyStrings.locationPermissionPermanentDenied],
//       );
//       Future.delayed(const Duration(seconds: 2), () {
//         if (Platform.isAndroid) {
//            Geolocator.requestPermission();
//           // openAppSettings(); // Opens device settings
//         }
//       });
//     }
//     return null;
//   }
// }


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ovorideuser/core/utils/my_color.dart';
import 'package:ovorideuser/core/utils/style.dart';
import 'package:ovorideuser/core/utils/my_strings.dart';
import 'package:ovorideuser/core/utils/util.dart';
import 'package:ovorideuser/presentation/components/snack_bar/show_custom_snackbar.dart';

import '../../../core/helper/string_format_helper.dart';

class AppLocationController extends GetxController {
  Position currentPosition = MyUtils.getDefaultPosition();
  String currentAddress = "Loading...";

  Future<bool> checkPermission(BuildContext context) async {
    // 1️⃣ First show custom dialog
    await showDialog(
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

                Text("Location Access Required",
                    style: boldLarge, textAlign: TextAlign.center),
                const SizedBox(height: 16),

                Text(
                  "To give you the best riding experience, this app needs access to your location.\n\n"
                      "📍 Accurate pickup and drop-off\n"
                      "🛵 Real-time ride tracking\n"
                      "✅ Better and safer service",
                  style: boldLarge.copyWith(fontSize: 14, height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

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

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true); // ✅ return allow
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: MyColor.primaryColor,
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

    // 2️⃣ After dialog close, actually request permission
    var status = await Geolocator.checkPermission();

    if (status == LocationPermission.denied) {
      var requestStatus = await Geolocator.requestPermission();
      if (requestStatus == LocationPermission.whileInUse ||
          requestStatus == LocationPermission.always) {
        getCurrentPosition();
      } else {
        CustomSnackBar.error(errorList: ["Please enable location permission"]);
      }
    } else if (status == LocationPermission.deniedForever) {
      CustomSnackBar.error(
        errorList: [
          "Location permission is permanently denied. Please enable it from settings.",
        ],
      );
      if (Platform.isAndroid) {
        await Geolocator.requestPermission();
        // or openAppSettings();
      }
    } else if (status == LocationPermission.whileInUse ||
        status == LocationPermission.always) {
      getCurrentPosition();
    }

    return true;
  }


  /// 🔹 Get current position + address
  Future<Position?> getCurrentPosition() async {
    try {
      currentPosition = await Geolocator.getCurrentPosition(
        locationSettings:
        const LocationSettings(accuracy: LocationAccuracy.best),
      );

      final placemarks = await placemarkFromCoordinates(
        currentPosition.latitude,
        currentPosition.longitude,
      );

      currentAddress =
      "${placemarks[0].street} ${placemarks[0].subThoroughfare} ${placemarks[0].thoroughfare}, ${placemarks[0].locality}, ${placemarks[0].country}";
      update();

      printX('📍 Current position: $currentAddress');
      return currentPosition;
    } catch (e) {
      CustomSnackBar.error(
        errorList: [MyStrings.locationPermissionPermanentDenied],
      );
      Future.delayed(const Duration(seconds: 2), () {
        if (Platform.isAndroid) {
          Geolocator.requestPermission();
        }
      });
    }
    return null;
  }
}

