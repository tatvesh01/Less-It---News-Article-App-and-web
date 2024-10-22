import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/full_news_screen_controller.dart';
import '../Utils/helper.dart';
import '../Controller/splash_screen_controller.dart';
import '../Utils/global.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_iframe/flutter_html_iframe.dart';

class FullNewsScreen extends StatelessWidget {
  FullNewsScreen({Key? key}) : super(key: key);

  FullNewsScreenController fullNewsScreenController = Get.put(FullNewsScreenController());

  @override
  Widget build(BuildContext context) {

    Global.deviceSize(context);

    return Scaffold(
      body: Container(
        height: Global.sHeight,
        width: Global.sWidth,
        color: Helper.bgColor,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Stack(
                children: [
                  Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Obx(() => !fullNewsScreenController.refreshPage.value ?
                      fullNewsScreenController.image.isNotEmpty?
                      Stack(
                        children: [
                          CarouselSlider.builder(
                            itemCount: fullNewsScreenController.image.length,
                            itemBuilder: (context, index, realIdx) {
                              return Hero(
                                tag: fullNewsScreenController.animName,
                                child: Stack(
                                  children: [
                                    Global.networkImage(fullNewsScreenController.image[index],400,double.infinity),
                                    Container(
                                        alignment: Alignment.bottomCenter,
                                        height: 400,
                                        child: Container(
                                          height: 100,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              colors: [
                                                Colors.black.withOpacity(0.5),
                                                Colors.black.withOpacity(0.0), // Fully transparent at the top
                                              ],
                                            ),
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              );
                            },
                            options: CarouselOptions(
                              height: 400,
                              viewportFraction: 1.0,
                              autoPlay: true,
                              onPageChanged: (index, reason) {
                                fullNewsScreenController.currentIndex = index;
                                fullNewsScreenController.refreshPage(true);
                                fullNewsScreenController.refreshPage(false);
                              },
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomCenter,
                            height: 340,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(fullNewsScreenController.image.length, (index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 3),
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: fullNewsScreenController.currentIndex == index
                                        ? Helper.parrotColor
                                        : Helper.greyColor,
                                  ),
                                );
                              }),
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ):SizedBox():SizedBox()),

                      Platform.isAndroid?
                      Positioned(
                        top: 30,
                        left: 20,
                        child: InkWell(
                          onTap: (){
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
                            ),
                          ),
                        ),
                      ):SafeArea(
                        child: InkWell(
                          onTap: (){
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            alignment: Alignment.center,
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),


                  Padding(
                    padding: EdgeInsets.only(top: fullNewsScreenController.image.isNotEmpty? 360 : 60),
                    child: Container(
                      width: Global.sWidth,
                      decoration: BoxDecoration(
                          color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              fullNewsScreenController.title,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Helper.blackColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              fullNewsScreenController.date,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Helper.greyColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),

                          /*Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: QuillHtmlEditor(
                                controller: fullNewsScreenController.descController,
                                text: fullNewsScreenController.desc,
                                isEnabled: false,
                                minHeight: 300,
                            ),
                          ),*/
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Html(
                              data: fullNewsScreenController.desc,
                              style: {
                                "p": Style(
                                  fontSize: FontSize(16.0),
                                ),
                                "h1": Style(
                                  fontSize: FontSize(22.0),
                                ),
                                "h2": Style(
                                  fontSize: FontSize(20.0),
                                ),
                              },
                              onLinkTap:(url, attributes, element) {
                                if (url != null) {
                                  fullNewsScreenController.openUrl(url);
                                }
                              },
                              extensions: [
                                IframeHtmlExtension(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),



                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
