import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../Utils/helper.dart';
import 'package:intl/intl.dart';

class NewsManager extends StatefulWidget {
  @override
  _NewsManagerState createState() => _NewsManagerState();
}

class _NewsManagerState extends State<NewsManager> {
  final CollectionReference newsCollection =  FirebaseFirestore.instance.collection('news');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: newsCollection.orderBy('timestamp', descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final data = snapshot.requireData;

          return ListView.builder(
            itemCount: data.size,
            itemBuilder: (context, index) {
              var newsItem = data.docs[index];

              Map<String, dynamic>? newsData = newsItem.data() as Map<String, dynamic>?;
              bool hasImgUrl = newsData!.containsKey("imgs");
              bool hasPinned = newsData.containsKey("pinned");
              bool isPinned = false;
              if(hasPinned){
                isPinned = newsItem["pinned"];
              }

              String? imgUrl;
              if(hasImgUrl){
                List<dynamic> tempImg = newsItem['imgs'];
                if(tempImg.isNotEmpty){
                  imgUrl =  newsItem['imgs'][0];
                }
              }

              return Container(
                  margin: EdgeInsets.symmetric(vertical: 7,horizontal: 10),
                  decoration: BoxDecoration(
                      color: Helper.greyColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Helper.greyColor,width: 1)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Expanded(
                        flex: 9,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(newsItem['title'],style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),),
                              Text(newsItem['description'],style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),maxLines: 2,),
                              Text("Category: "+newsItem['category'],style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400),),
                              Text(formatDate(newsItem['timestamp']),style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400),),
                            ],
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [

                            SizedBox(height: 10,),
                            imgUrl != null ?
                            ClipRRect(borderRadius: BorderRadius.circular(10),
                                child: Image.network(imgUrl,height: 80,width: 80,fit: BoxFit.fill),):SizedBox(),

                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit,size: 20,),
                                  onPressed: () {
                                    Get.back(result: data.docs[index].id);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete,size: 20),
                                  onPressed: () {
                                    _deleteCategory(newsItem.id);
                                  },
                                ),
                                isPinned ?
                                Image.asset(Helper.pinnedImg,width: 30,height: 30,) :SizedBox()
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
              );
            },
          );
        },
      ),
    );
  }


  String formatDate(String timestamp) {
    DateTime parsedDateTime = DateTime.parse(timestamp);
    String formattedDate = DateFormat("dd/MM/yyyy HH:mm a").format(parsedDateTime);
    return formattedDate;
  }


  Future<void> _deleteCategory(String id) async {
    await newsCollection.doc(id).delete();
  }
}