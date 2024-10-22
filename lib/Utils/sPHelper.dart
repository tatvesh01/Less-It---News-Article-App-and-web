import 'package:shared_preferences/shared_preferences.dart';

class SPHelper {
  static late SharedPreferences prefs;
  static String saveRoutePrefStr = "saveRoutePref";

  static sharedPrefInit() async {
    prefs = await SharedPreferences.getInstance();
  }

  static setEmail(String email){
    prefs.setString("email", email);
  }

  static Future<String> getEmail() async{
    String email = await prefs.getString("email") ?? "NA";
    return email;
  }

  static setName(String name){
    prefs.setString("name", name);
  }

  static Future<String> getName() async{
    String name = await prefs.getString("name") ?? "NA";
    return name;
  }

  static setPhoto(String photo){
    prefs.setString("photo", photo);
  }

  static Future<String> getPhoto() async{
    String photo = await prefs.getString("photo") ?? "NA";
    return photo;
  }

  static setFcm(String fcm){
    prefs.setString("fcm", fcm);
  }

  static Future<String> getFcm() async{
    String fcm = await prefs.getString("fcm") ?? "NA";
    return fcm;
  }

  static setLogedIn(bool logedIn){
    prefs.setBool("logedIn", logedIn);
  }

  static Future<bool> getLogedIn() async{
    bool logedIn = await prefs.getBool("logedIn") ?? false;
    return logedIn;
  }

}
