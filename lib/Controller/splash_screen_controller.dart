import 'package:get/get.dart';
import '../Ui/login_screen.dart';
import '../Ui/password_screen.dart';
import '../Utils/sPHelper.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_messaging/firebase_messaging.dart';
import '../Ui/news_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SplashScreenController extends GetxController{

  @override
  void onInit() {
    SPHelper.sharedPrefInit();
    redirectScreen();
    super.onInit();
  }

  void redirectScreen() {
    Future.delayed(const Duration(seconds: 2), () async {

      if (kIsWeb) {
        Get.off(()=>PasswordScreen());
      }else{
        bool isLogedIn = await SPHelper.getLogedIn();
        if(isLogedIn){
          String newFcmToken = await getFCMToken() ?? "";
          String oldFcm = await SPHelper.getFcm();
          if(oldFcm != newFcmToken){
            String email = await SPHelper.getEmail();
            CollectionReference users = FirebaseFirestore.instance.collection('users');
            await users.where('email', isEqualTo: email).limit(1).get().then((value) async{
              await users.doc(value.docs[0].id).update({'fcm': newFcmToken});
            });
          }
          Get.off(()=>NewsScreen());
        }else{
          Get.off(()=>LoginScreen());
        }

      }
    });
  }

  Future<String?> getFCMToken() async{
    String? token = await FirebaseMessaging.instance.getToken();
    return token;
  }

}