import 'dart:convert';
import 'dart:developer';

import 'package:weather/const/api_key.dart';
import 'package:weather/model/weather_model.dart';
import 'package:http/http.dart'as http;

class ApiServices{
  static const baseUrl = "http://api.weatherapi.com/v1/current.json?key=$api_key";

  WeatherModel? weatherModel;

  String apiURL(double lat, double lon) {
    String url;
    url ="$baseUrl&q=$lat,$lon";
    return url;
  }

  String apiCityURL(var city) {
    String url;
    url ="$baseUrl&q=$city";
    return url;
  }

  Future<WeatherModel> fetchWeather(double lat, double lon) async {
    var response = await http.get(Uri.parse(apiURL(lat, lon)));
    var jsonString = jsonDecode(response.body);
    weatherModel = WeatherModel.fromJson(jsonString);
    log("WeatherModel from api $weatherModel");
    return weatherModel!;
  }

  Future<WeatherModel> fetchCityWeather(String city) async {
    var response = await http.get(Uri.parse(apiCityURL(city)));
    var jsonString = jsonDecode(response.body);
    weatherModel = WeatherModel.fromJson(jsonString);
    log("WeatherModel2 from api $weatherModel");
    return weatherModel!;
  }





}