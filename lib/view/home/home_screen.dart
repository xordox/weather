import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather/controller/global_controller.dart';
import 'package:weather/sharedPrefs/app_shared_prefences.dart';
import 'package:weather/view/splash/splash_screen.dart';

class HomeScreen extends StatefulWidget {
  static const route = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  String date = DateFormat("yMMMMd").format(DateTime.now());

  final GlobalController globalController = Get.find<GlobalController>();
  final TextEditingController _controller = TextEditingController(text:AppSharedPreferences.getCityInfo());

  @override
  void initState() {
    getAddress(globalController.getLattitude().value,
        globalController.getLongitude().value);
    super.initState();
  }

  getAddress(latitude, longitude) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemark[0];
    setState(() {
      globalController.setCity(place.locality!);
    });
    log("${placemark[0]}");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(onPressed: ()=>Get.toNamed(SplashScreen.route), child: const Text("Back",style: TextStyle(color: Colors.white),),),
        ],
      ),
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
                 Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.topLeft,
          child: Text(
            globalController.getWeather.value.location!.name,
            style: const TextStyle(fontSize: 35),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.topLeft,
          child: Text(
            date,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.topLeft,
          child: Text(
            "Temp: ${globalController.getWeather.value.current?.tempC} °C",
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.topLeft,
          child: Text(
            "Condition: ${globalController.getWeather.value.current?.condition.text}",
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          decoration: const InputDecoration(
                        hintText :"Enter location",
                      ),
                          controller: _controller,                          
                        ),
                      ),
                      ElevatedButton(onPressed: ()async{
                        if(_controller.text.isEmpty){
                          Get.snackbar("Location is empty", "");
                        }
                        else{AppSharedPreferences().saveCity(_controller.text);
                        await globalController.fetchCityWeather(_controller.text);}
                        },
                         child: _controller.text.isEmpty? const Text("Save"): const Text("Update"))
                    ],
                  )
                ],
              )),
      ),
    );
  }
}
