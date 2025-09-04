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
import 'package:ovorideuser/core/utils/util.dart';
import 'package:ovorideuser/presentation/components/snack_bar/show_custom_snackbar.dart';

import '../../../core/helper/string_format_helper.dart';

class AppLocationController extends GetxController {
  Position currentPosition = MyUtils.getDefaultPosition();
  String currentAddress = "Loading...";

  Future<bool> checkPermission(BuildContext context) async {
    var status = await Geolocator.checkPermission();

    if (status == LocationPermission.whileInUse || status == LocationPermission.always) {
      await getCurrentPosition();
      return true;
    }

    if (status == LocationPermission.deniedForever) {
      await _showSettingsDialog(context);
      return false;
    }

    bool? userAccepted = await _showLocationPermissionDialog(context);

    if (userAccepted == true) {
      var requestStatus = await Geolocator.requestPermission();

      if (requestStatus == LocationPermission.whileInUse ||
          requestStatus == LocationPermission.always) {
        await getCurrentPosition();
        return true;
      } else if (requestStatus == LocationPermission.deniedForever) {
        CustomSnackBar.error(
          errorList: [
            "Location permission is permanently denied. Please enable it from settings.",
          ],
        );
      } else {
        CustomSnackBar.error(errorList: ["Please enable location permission"]);
      }
    } else {
      CustomSnackBar.error(errorList: ["Location access is required for better service"]);
    }

    return false;
  }

  /// Show location permission request dialog
  Future<bool?> _showLocationPermissionDialog(BuildContext context) async {
    return await showDialog<bool>(
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

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.grey[400]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Not Now",
                          style: boldSmall.copyWith(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Allow Button
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: MyColor.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Allow Location",
                          style: boldSmall.copyWith(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Show settings dialog for permanently denied permission
  Future<void> _showSettingsDialog(BuildContext context) async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.settings,
                  color: Colors.orange,
                  size: 36,
                ),
                const SizedBox(height: 16),
                Text(
                  "Location Permission Required",
                  style: boldLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  "Location access has been permanently denied. Please enable it manually in your device settings to continue.",
                  style: boldSmall.copyWith(fontSize: 14, height: 1.4),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Geolocator.openAppSettings();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColor.primaryColor,
                        ),
                        child: const Text("Open Settings"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Get current position + address
  Future<Position?> getCurrentPosition() async {
    try {
      printX('Starting location request...');

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      printX('Location services enabled: $serviceEnabled');

      if (!serviceEnabled) {
        CustomSnackBar.error(
          errorList: ["Location services are disabled. Please enable them in your device settings."],
        );
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      printX('Current permission status: $permission');

      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        CustomSnackBar.error(
          errorList: ["Location permission is required. Please enable it."],
        );
        return null;
      }

      printX('Getting current position...');

      currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
          timeLimit: const Duration(seconds: 15), // Increased timeout
        ),
      );

      printX('Position obtained: ${currentPosition.latitude}, ${currentPosition.longitude}');

      try {
        printX('Getting address from coordinates...');
        final placemarks = await placemarkFromCoordinates(
          currentPosition.latitude,
          currentPosition.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks[0];
          List<String> addressParts = [];

          if (place.street?.isNotEmpty == true) addressParts.add(place.street!);
          if (place.subThoroughfare?.isNotEmpty == true) addressParts.add(place.subThoroughfare!);
          if (place.thoroughfare?.isNotEmpty == true) addressParts.add(place.thoroughfare!);
          if (place.locality?.isNotEmpty == true) addressParts.add(place.locality!);
          if (place.country?.isNotEmpty == true) addressParts.add(place.country!);

          currentAddress = addressParts.isNotEmpty
              ? addressParts.join(', ')
              : "Location found (${currentPosition.latitude.toStringAsFixed(4)}, ${currentPosition.longitude.toStringAsFixed(4)})";

          printX('Address resolved: $currentAddress');
        } else {
          currentAddress = "Location found (${currentPosition.latitude.toStringAsFixed(4)}, ${currentPosition.longitude.toStringAsFixed(4)})";
          printX('No placemarks found, using coordinates');
        }
      } catch (addressError) {
        printX('Address resolution failed: $addressError');
        currentAddress = "Location found (${currentPosition.latitude.toStringAsFixed(4)}, ${currentPosition.longitude.toStringAsFixed(4)})";
      }

      update();
      printX('Location update completed: $currentAddress');
      return currentPosition;

    } catch (e) {
      printX('Location error details: $e');

      String errorMessage = "Failed to get current location.";

      if (e.toString().contains('timeout')) {
        errorMessage = "Location request timed out. Please try again.";
      } else if (e.toString().contains('network')) {
        errorMessage = "Network error while getting location. Check your internet connection.";
      } else if (e.toString().contains('permission')) {
        errorMessage = "Location permission denied. Please enable it in settings.";
      } else if (e.toString().contains('disabled')) {
        errorMessage = "Location services are disabled. Please enable them.";
      }

      CustomSnackBar.error(errorList: [errorMessage]);
    }
    return null;
  }

  /// Refresh location manually
  Future<void> refreshLocation() async {
    currentAddress = "Loading...";
    update();
    await getCurrentPosition();
  }
}