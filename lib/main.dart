import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather/controller/global_controller.dart';
import 'package:weather/sharedPrefs/app_shared_prefences.dart';
import 'package:weather/view/home/home_screen.dart';
import 'package:weather/view/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSharedPreferences.init();
  Get.put(GlobalController());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSkipped = AppSharedPreferences().isSkipped;
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'WeatherApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      getPages: [
        GetPage(name: SplashScreen.route, page: () => const SplashScreen()),
        GetPage(name: HomeScreen.route, page: () => const HomeScreen()),
      ],
      initialRoute: isSkipped ? HomeScreen.route : SplashScreen.route,
    );
  }
}
