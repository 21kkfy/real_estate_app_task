import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants/business_logic.dart';
import 'constants/language_keys.dart';
import 'services/route_service.dart';
import 'views/splash_screen/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  /// 1. App should support portrait and landscape
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const RealEstateApp());
}

class RealEstateApp extends StatelessWidget {
  const RealEstateApp({super.key});

  @override
  Widget build(BuildContext context) {
    requestPermissions();
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) => GetMaterialApp(
        locale: const Locale(BLogic.en_US),
        translations: Languages(),
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.routeName,
        onGenerateRoute: RouteService.onGenerateRoute,
      ),
    );
  }

  void requestPermissions() async {
    LocationPermission permission;

// Test if location services are enabled.
    await Geolocator.isLocationServiceEnabled();

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('', 'Location Permission Denied');
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      permission = await Geolocator.requestPermission();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }
}
