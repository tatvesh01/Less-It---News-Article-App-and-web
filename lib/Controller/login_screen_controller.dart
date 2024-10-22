import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Ui/InterestSelectScreen.dart';
import '../Ui/category_manager.dart';
import '../Ui/add_news_screen.dart';
import '../Ui/news_screen.dart';
import '../Utils/sPHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app/Utils/global.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class LoginScreenController extends GetxController{

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await Global.googleSignIn.signIn();

      if (googleUser == null) {
        Global.showToast("Something Wrong");
      }else{

        SPHelper.setEmail(googleUser.email);
        SPHelper.setName(googleUser.displayName ?? "NA");
        SPHelper.setPhoto(googleUser.photoUrl ?? googleUser.displayName![0]);
        SPHelper.setLogedIn(true);
        String fcmToken = await getFCMToken() ?? "";
        SPHelper.setFcm(fcmToken);

        addUserData(fcmToken);
      }
    } catch (e) {
      Global.showToast(e.toString());
    }
  }

  Future<void> signInWithApple() async {
    AuthorizationCredentialAppleID credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    SPHelper.setEmail(credential.email ?? "guestuser@gmail.com");
    SPHelper.setName(credential.givenName ?? "guestuser");
    SPHelper.setPhoto("G");
    SPHelper.setLogedIn(true);
    String fcmToken = await getFCMToken() ?? "";
    SPHelper.setFcm(fcmToken);

    addUserData(fcmToken);
  }

  Future<void> guestLogin() async {
    try {
        SPHelper.setEmail("guestuser@gmail.com");
        SPHelper.setName("Guest User");
        SPHelper.setPhoto("G");
        SPHelper.setLogedIn(true);
        String fcmToken = await getFCMToken() ?? "";
        SPHelper.setFcm(fcmToken);
        addUserData(fcmToken);
    } catch (e) {
      Global.showToast(e.toString());
    }
  }



  Future<void> addUserData(String fcmToken) async {

    DateTime currentTime = DateTime.now();
    String iso8601Timestamp = currentTime.toUtc().toIso8601String();

    String name = await SPHelper.getName();
    String email = await SPHelper.getEmail();
    List<String> interest = [];

    try {
      await FirebaseFirestore.instance.collection('users').add({
        'name': name,
        'email': email,
        'fcm': fcmToken,
        'timestamp': iso8601Timestamp,
        'interest': interest,
      });

      Get.off(()=>InterestSelectScreen());
    } catch (e) {
      Global.showToast('Failed to add user');
    }

  }

  Future<String?> getFCMToken() async{
    String? token = await FirebaseMessaging.instance.getToken();
    return token;
  }






}