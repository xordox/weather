import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather/controller/global_controller.dart';
import 'package:weather/sharedPrefs/app_shared_prefences.dart';
import 'package:weather/view/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const route = '/splash';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalController globalController = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [Image.network(
            "https://www.vhv.rs/dpng/d/427-4270068_gold-retro-decorative-frame-png-free-download-transparent.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.contain,
          ),
          Scaffold(
        backgroundColor: Colors.grey,
        
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("https://www.vhv.rs/dpng/d/427-4270068_gold-retro-decorative-frame-png-free-download-transparent.png"),
                  fit: BoxFit.contain,
                ),
              ),
                child: const SizedBox() ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "We show weather for you",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      ElevatedButton(onPressed: (){ 
                        AppSharedPreferences().saveSkipInfo();
                        Get.toNamed(HomeScreen.route);}, child: const Text('Skip'))
                    ],
                  ),
                ),
             
      ]),
          ),
        ),
      ),
    ]);
  }

  @override
  void initState() {
    goToHomeScreen();
    super.initState();
  }

  Future<void>goToHomeScreen() async {
    Future.delayed(const Duration(seconds: 5), ()=> Get.toNamed(HomeScreen.route));
  }

}
