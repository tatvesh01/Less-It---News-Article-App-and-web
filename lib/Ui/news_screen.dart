import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app/Controller/news_screen_controller.dart';
import 'package:news_app/Ui/login_screen.dart';
import 'package:news_app/Ui/search_screen.dart';
import 'package:news_app/Utils/helper.dart';
import 'package:news_app/Utils/sPHelper.dart';
import 'package:share_plus/share_plus.dart';
import '../Utils/global.dart';
import 'full_news_screen.dart';


class NewsScreen extends StatelessWidget {
  NewsScreenController newsController = Get.put(NewsScreenController());

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
    newsController.categoryRecived.value ?
    WillPopScope(
      onWillPop: (){
        DateTime now = DateTime.now();
        if (newsController.currentBackPressTime == null ||
            now.difference(newsController.currentBackPressTime!) > Duration(seconds: 2)) {
          newsController.currentBackPressTime = now;
          Global.showToast("Press back again to exit");
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        key: newsController.scaffoldKey,
        backgroundColor: Helper.whiteColor,
        appBar: AppBar(
          backgroundColor: Helper.whiteColor,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: (){
            Get.to(()=>SearchScreen());
          },
            child: Center(
              child: Image.asset(Helper.searchImg,height: 25,width: 25,),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Less ',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black,fontFamily: "thick")),
              Text('It',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Helper.yellowColor,fontFamily: "thick")),
            ],
          ),
          centerTitle: true,
          actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: (){
                newsController.scaffoldKey.currentState?.openEndDrawer();
              },
              child: ClipOval(child:
              newsController.userPhoto == "G"?
                  Container(height: 40,width: 40,color: Colors.red,
                  alignment: Alignment.center,
                  child: Text("G",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 20),),)
                  : Image.network(newsController.userPhoto,height: 40,width: 40,fit: BoxFit.fill,)
              ),
            ),
          ),
          ],
          bottom: TabBar(
            isScrollable: true,
            padding: EdgeInsets.only(left: 0),
            labelPadding: EdgeInsets.only(left: 0,right: 40),
            labelStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500
            ),
            controller: newsController.tabController,
            tabs: newsController.categories.map((category) => Tab(text: newsController.capitalizeFirstLetter(category)))
                .toList(),
          ),
        ),
        endDrawer: Drawer(
          width: 170,
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          'https://www.w3schools.com/w3images/avatar2.png',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        newsController.uName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          newsController.uEmail,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 14,
                              color: Colors.white70,
                              overflow: TextOverflow.ellipsis
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Drawer items
                ListTile(
                  leading: Icon(Icons.share_sharp, color: Colors.black),
                  title: Text('Share',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),),
                  onTap: () {
                    String appUrl = "";

                    if(Platform.isAndroid){
                      appUrl = "https://play.google.com/store/apps/details?id=com.lessit.app";
                    }else{
                      appUrl = "https://apps.apple.com/app/id6736985111";
                    }
                    Share.share('Check out this amazing app: $appUrl');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.policy, color: Colors.black),
                  title: Text('T & C',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),),
                  onTap: () {
                    Global.openPage("Terms & Conditions","tc");
                  },
                ),
                ListTile(
                  leading: Icon(Icons.local_police_outlined, color: Colors.black),
                  title: Text('Policy',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),),
                  onTap: () {
                    Global.openPage("Privacy Policy","pp");
                  },
                ),
                if(Platform.isIOS)ListTile(
                  leading: Icon(Icons.delete_forever, color: Colors.red),
                  title: Text('Delete\nAccount',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),),
                  onTap: () {
                    newsController.deleteAccount(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.black),
                  title: Text('Logout',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),),
                  onTap: () async{
                    SPHelper.setLogedIn(false);
                    await Global.googleSignIn.signOut();
                    Get.offAll(()=>LoginScreen());
                  },
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: newsController.tabController,
          children: newsController.categories.map((category) {
            return newsShowView(category);
          }).toList(),
        ),

      ),
    ) : Scaffold(
      appBar: AppBar(
        backgroundColor: Helper.whiteColor,
        automaticallyImplyLeading: false,
        leading: Center(
          child: Image.asset(Helper.searchImg,height: 25,width: 25,),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Less ',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black,fontFamily: "thick")),
            Text('It',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Helper.yellowColor,fontFamily: "thick")),
          ],
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ClipOval(child:

            Container(height: 40,width: 40,color: Colors.red,
              alignment: Alignment.center,
              child: Text("G",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 20),),)

            ),
          ),
        ],
          bottom: TabBar(
            controller: newsController.loadingTimeTabController,
            isScrollable: true,
            padding: EdgeInsets.only(left: 0),
            labelPadding: EdgeInsets.only(left: 0,right: 40),
            labelStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500
            ),
            tabs: newsController.loadingTimeCategories.map((category) => Tab(text: newsController.capitalizeFirstLetter(category)))
                .toList(),
          ),),
      body: Container(
        height: Global.sHeight,
        width: Global.sWidth,
        color: Helper.whiteColor,),
    ));
  }


  Widget newsShowView(String category){

    int tempNumber = newsController.categories.indexWhere((element) => element == category);
    String tempCatId = newsController.cat_id[tempNumber];
    if(newsController.selectedCategory.value != tempCatId){
      return SizedBox();
    }

    var newsList = newsController.newsPerCategory[newsController.selectedCategory.value];
    if (newsList == null || newsController.noMoreDataInThiscategorie.contains(category)) {
      //return Center(child: Image.asset(Helper.noDataImg,height: 100,width: 100,));
      Widget tempWidget = Container();
      if(newsList == null){
        tempWidget = Center(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Helper.blackColor,),
              SizedBox(width: 10,),
              Text('Data Loading..',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500))
            ] ));
      }
      if(newsController.noMoreDataInThiscategorie.contains(newsController.selectedCategory.value)){
        tempWidget = Center(child: Image.asset(Helper.noDataImg,height: 100,width: 100,));
      }
      return tempWidget;
    }


    return Container(
        margin: EdgeInsets.only(top: 10),
        child: !newsController.refreshNews.value ?
        RefreshIndicator(
          onRefresh: () => newsController.refreshTab(),
          child: ListView.builder(
            itemCount: newsList.length + 1,
            itemBuilder: (context, index) {
              List<dynamic> tempImg = [];
              List<dynamic> tempImgIn = [];

              if (index == newsList.length ) {

                if (!newsController.noMoreDataInThiscategorie.contains(newsController.selectedCategory.value)) {
                  newsController.fetchNews(newsController.selectedCategory.value);
                  return Center(child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    CircularProgressIndicator(color: Helper.blackColor,),
                    SizedBox(width: 10,),
                    Text('Data Loading..',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500))
                  ] ));
                } else {
                  //return Center(child: Text('No more data',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500)));
                  return SizedBox();
                }
              }

              DocumentSnapshot news = newsList[index];
              Map<String, dynamic>? newsData = news.data() as Map<String, dynamic>?;
              bool hasImgUrl = newsData!.containsKey("imgs");
              String? imgUrl;
              if(hasImgUrl){
                tempImg = news['imgs'];
                if(tempImg.isNotEmpty){
                  imgUrl = news['imgs'][0];
                }
              }

              bool hasImgUrlIn = newsData.containsKey("imgsIn");
              if(hasImgUrlIn){
                tempImgIn = news['imgsIn'];
              }

              /*bool hasPinned = newsData.containsKey("pinned");
              bool tempPinned = false;
              if(hasPinned){
                tempPinned = news['pinned'];
              }*/

              return InkWell(
                onTap: (){
                  Get.to(()=>FullNewsScreen(),arguments: [news,tempImgIn,index.toString()]);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Helper.whiteColor,
                    border: Border.all(color: Helper.lightGreyColor,width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.symmetric(vertical: 8,horizontal: 15,),
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 7,
                        child: Container(
                          height: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(news['title'],style: TextStyle(color:Helper.blackColor,fontWeight: FontWeight.w500,fontSize: 17),maxLines: 3,),
                              Text(Global.convertToAgo(news['timestamp']),style: TextStyle(color:Helper.greyColor,fontWeight: FontWeight.w500,fontSize: 11),maxLines: 1,),
                              /*tempPinned?
                              Text(tempPinned.toString(),style: TextStyle(color:Helper.greyColor,fontWeight: FontWeight.w500,fontSize: 11),maxLines: 1,):SizedBox()*/
                            ],
                          ),
                        ),
                      ),

                      imgUrl != null ?
                      Expanded(
                        flex: 3,
                        child: Hero(
                          tag: "anim_"+index.toString(),
                          child: ClipRRect(borderRadius: BorderRadius.circular(10),
                              child: Global.networkImage(imgUrl,90,90)),
                        ),
                      ):SizedBox(),

                    ],
                  ),
                ),
              );

            },
          ),
        ):Center(child: CircularProgressIndicator()),


      );
  }

}




