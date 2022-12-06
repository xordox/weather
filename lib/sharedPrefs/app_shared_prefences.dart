import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences{

  static late SharedPreferences _preferences;

  bool get isSkipped => _preferences.getBool("skip") != null;

  static Future init() async  => _preferences = await SharedPreferences.getInstance();

  Future<void> saveSkipInfo () async {
    await _preferences.setBool("skip", true);    
  }

  Future<void> saveCity (String val) async {
    await _preferences.setString("city", val);    
  }

  static bool getSkipInfo(){
    late bool skipInfo;
    skipInfo = _preferences.getBool("skip")??false;
    print("SkipInfoVal: $skipInfo");
    return skipInfo;
  }

  static String getCityInfo(){
    late String cityInfo;
    cityInfo = _preferences.getString("city")??"";
    print("cityInfoVal: $cityInfo");
    return cityInfo;
  }
  
  static void clearPrefs(){
    _preferences.remove("skip");
  }
}