import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Utils/helper.dart';
import '../Controller/splash_screen_controller.dart';
import '../Utils/global.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  SplashScreenController splashScreenController = Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {

    Global.deviceSize(context);

    return Scaffold(
      body: Container(
        height: Global.sHeight,
        width: Global.sWidth,
        color: Helper.whiteColor,
        child: Stack(
          alignment: Alignment.center,
          children: [

            Positioned(
                top: -45,
                right: -45,
                child: Global.roundBubble()
            ),

            Positioned(
              bottom: -45,
              left: -45,
              child: Global.roundBubble()
            ),


            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                /*Hero(
                  tag: "appicon",
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white,width: 3,),
                      borderRadius: BorderRadius.all(Radius.circular(18))
                      *//*boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(1, 3),
                        ),
                      ],*//*
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(Helper.iconImg,height: 100,width: 100,)),
                  ),
                ),*/
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Less ',style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Colors.black,fontFamily: "thick")),
                    Text('It',style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Helper.yellowColor,fontFamily: "thick")),
                  ],
                ),
                Text('Find the best offers in India',style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic,color: Colors.black,fontFamily: "thick"))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
