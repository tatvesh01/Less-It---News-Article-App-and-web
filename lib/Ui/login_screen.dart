import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/login_screen_controller.dart';
import '../Utils/helper.dart';
import '../Controller/splash_screen_controller.dart';
import '../Utils/global.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  LoginScreenController loginScreenController = Get.put(LoginScreenController());

  @override
  Widget build(BuildContext context) {

    Global.deviceSize(context);

    return Scaffold(
      body: Container(
        height: Global.sHeight,
        width: Global.sWidth,
        color: Helper.bgColor,
        child: Stack(
          alignment: Alignment.center,
          children: [

            Positioned(
                top: -60,
                right: -60,
                child: Global.roundBubble()
            ),

            Positioned(
                bottom: -60,
                left: -60,
                child: Global.roundBubble()
            ),



            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [


                Spacer(),

                Hero(
                  tag: "appicon",
                  child:ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(Helper.iconImg,height: 100,width: 100,)),),

                Spacer(),

                if(Platform.isIOS)
                InkWell(
                  onTap: (){
                    loginScreenController.signInWithApple();
                  },
                  child: Container(
                    height: 55,
                    width: Global.sWidth/1.3,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(Helper.appleImg,height: 35,width: 35,),
                        SizedBox(width: 15,),
                        Text("Login with Apple",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                      ],
                    ),
                  ),
                ),

                if(Platform.isIOS)SizedBox(height: 20,),

                if(Platform.isAndroid)
                InkWell(
                  onTap: (){
                    loginScreenController.signInWithGoogle();
                  },
                  child: Container(
                    height: 55,
                    width: Global.sWidth/1.3,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(Helper.googleImg,height: 35,width: 35,),
                        SizedBox(width: 15,),
                        Text("Login with Google",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                      ],
                    ),
                  ),
                ),
                if(Platform.isAndroid)SizedBox(height: 20,),

                InkWell(
                  onTap: (){
                    loginScreenController.guestLogin();
                  },
                  child: Container(
                    height: 55,
                    alignment: Alignment.center,
                    width: Global.sWidth/1.3,
                    child: Text("Continue without signup",style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                  ),
                ),


                SizedBox(height: 50,),
                RichText(
                  text: TextSpan(
                    text: "I agree to the ",
                    style: TextStyle(color: Colors.black, fontSize: 12),
                    children: [
                      TextSpan(
                        text: "Terms & Conditions",
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Global.openPage("Terms & Conditions","tc");
                          },
                      ),
                      TextSpan(
                        text: " and ",
                      ),
                      TextSpan(
                        text: "Privacy Policy",
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Global.openPage("Privacy Policy","pp");
                          },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 120,),


                /*SizedBox(height: 30),
                Center(child: InkWell(
                    onTap: (){
                      loginScreenController.sendNotification();
                    },child: Text('send noti',style: TextStyle(color: Helper.blackColor,fontSize: 16,decoration: TextDecoration.underline),))),*/


              ],
            ),
          ],
        ),
      ),
    );
  }
}
