import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weather/model/weather_data.dart';
import 'package:weather/model/weather_model.dart';
import 'package:weather/services/api_services.dart';

class GlobalController extends GetxController {
  final RxBool _isLoading = true.obs;
  final RxDouble _latitude = 0.0.obs;
  final RxDouble _longitude = 0.0.obs;

  RxBool checkLoading() => _isLoading;
  RxDouble getLattitude() => _latitude;
  RxDouble getLongitude() => _longitude;

  final weatherData = WeatherData().obs;
  late WeatherModel weatherModel;

  WeatherModel get getWeather => weatherModel;



  @override
  void onInit() {
    if (_isLoading.isTrue) {
      getLocation();
    }
    super.onInit();
  }

  getLocation() async {
    bool isServiceEnabled;
    LocationPermission locationPermission;
    isServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isServiceEnabled) {
      return Future.error("Location not enabled");
    }

    //status of permission
    locationPermission = await Geolocator.checkPermission();

    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error("Location permission deneied forever");
    } else if (locationPermission == LocationPermission.denied) {
      //request for permission
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    //getting current position
    return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low,forceAndroidLocationManager: true)
        .then((value) {
      _latitude.value = value.latitude;
      _longitude.value = value.longitude;
      log("${_latitude.value},${_latitude.value}");
      return ApiServices()
          .fetchWeather(value.latitude, value.longitude)
          .then((val) {
        weatherModel = val;
        _isLoading.value = false;
        update();
      });
    });
  }

  Future<void> fetchCityWeather(String city) async {    
        _isLoading.value = true;
    await ApiServices()
          .fetchCityWeather(city)
          .then((val) {
        weatherModel = val;
        log("city data: $val");
        _isLoading.value = false;
        update();
      });
  }
}
