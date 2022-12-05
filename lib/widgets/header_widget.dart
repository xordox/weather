import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/global_controller.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  GlobalController globalController = Get.find<GlobalController>();
  String city = '';
  String date = DateFormat("yMMMMd").format(DateTime.now());

  // final GlobalController globalController =
  //     Get.put(GlobalController(), permanent: true);

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
      city = place.locality!;
    });
    log("${placemark[0]}");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.topLeft,
          child: Text(
            city,
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
            "${globalController.getWeather.current.tempC}",
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
