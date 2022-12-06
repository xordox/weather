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
  final RxString _city = ''.obs;
  final RxString _cityApi = ''.obs;

  RxBool checkLoading() => _isLoading;
  RxDouble getLattitude() => _latitude;
  RxDouble getLongitude() => _longitude;
  RxString get getCity => _city;
  RxString get getCityApi => _cityApi;

  final weatherData = WeatherData().obs;
  Rx<WeatherModel> weatherModel = WeatherModel().obs;

  Rx<WeatherModel> get getWeather => weatherModel;


  setCity(String city){
    _city.value = city;
  }

  



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
        weatherModel.value = val;
        _isLoading.value = false;
        update();
      });
    });
  }

  Future<void> fetchCityWeather(String city) async {    
    log("cityName: $city");
        _isLoading.value = true;
    await ApiServices()
          .fetchCityWeather(city)
          .then((val) {
        weatherModel.value = val;
         _city.value = val.location!.name;
         _cityApi.value = val.location!.name;
        _isLoading.value = false;
        update();
      });
  }
}
