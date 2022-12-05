import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather/controller/global_controller.dart';
import 'package:weather/widgets/header_widget.dart';

class HomeScreen extends StatefulWidget {
  static const route = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final GlobalController globalController =
  //     Get.put(GlobalController(), permanent: true);

  final GlobalController globalController = Get.find<GlobalController>();
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() =>
         globalController.checkLoading().isTrue
            ? const Center(
                child: CircularProgressIndicator(),
              ):
             ListView(
                scrollDirection: Axis.vertical,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const HeaderWidget(),
                  Row(
                    children: [
                      SizedBox(
                        width: 200,
                        child: TextField(
                          controller: _controller,                          
                        ),
                      ),
                      ElevatedButton(onPressed: (){globalController.fetchCityWeather(_controller.value.toString());}, child: const Text("Search"))
                    ],
                  )
                ],
              )),
      ),
    );
  }
}
