import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/search_screen_controller.dart';
import '../Utils/helper.dart';
import '../Utils/global.dart';
import 'package:flutter/widgets.dart';
import 'full_news_screen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  SearchScreenController searchScreenController = Get.put(SearchScreenController());


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('Search News',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),),
        leading: InkWell(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Icon(Icons.arrow_back_outlined, color: Colors.black, size: 25),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          height: Global.sHeight,
          width: Global.sWidth,
          color: Helper.whiteColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: TextFormField(
                    onChanged: (value) {
                      searchScreenController.updateQuery(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search News',
                      labelStyle: TextStyle(color: Helper.blackColor),
                      hintStyle: TextStyle(color: Helper.greyColor),
                      prefixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.zero,
                      filled: true,
                      fillColor: Helper.greyColor.withOpacity(0.1),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Helper.greyColor, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Helper.greyColor, width: 1.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.redAccent, width: 1.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.redAccent, width: 1.0),
                      ),
                    ),

                  ),
                ),

                SizedBox(height: 10),
                
                Obx(() => !searchScreenController.refreshPage.value?
                Expanded(
                  child: Obx(() {
                    if (searchScreenController.filteredNewsList.isEmpty) {
                      return Center(child: Image.asset(Helper.noDataImg,height: 100,width: 100,));
                    }
                    return ListView.builder(
                      itemCount: searchScreenController.filteredNewsList.length,
                      itemBuilder: (context, index) {
                        var news = searchScreenController.filteredNewsList[index];
                        List<dynamic> tempImg = [];
                        List<dynamic> tempImgIn = [];

                        //DocumentSnapshot news = newsList[index];
                        //Map<String, dynamic>? newsData = news.data() as Map<String, dynamic>?;
                        bool hasImgUrl = news.containsKey("imgs");
                        String? imgUrl;
                        if(hasImgUrl){
                          tempImg = news['imgs'];
                          if(tempImg.isNotEmpty){
                            imgUrl = news['imgs'][0];
                          }
                        }

                        bool hasImgUrlIn = news.containsKey("imgsIn");
                        if(hasImgUrlIn){
                          tempImgIn = news['imgsIn'];
                        }

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
                                        Text(Global.convertToAgo(news['timestamp']),style: TextStyle(color:Helper.greyColor,fontWeight: FontWeight.w500,fontSize: 11),maxLines: 1,)
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
                    );
                  }),
                ): Expanded(
                  child: Center(child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Helper.blackColor,),
                        SizedBox(width: 10,),
                        Text('Data Loading..',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500))
                      ] )),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
