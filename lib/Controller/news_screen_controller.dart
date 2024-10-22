import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Ui/login_screen.dart';
import '../Utils/global.dart';
import '../Utils/sPHelper.dart';

class NewsScreenController extends GetxController with SingleGetTickerProviderMixin {
  var selectedCategory = ''.obs;
  Map<String, List<DocumentSnapshot>> newsPerCategory = <String, List<DocumentSnapshot>>{}.obs;
  Map<String, List<DocumentSnapshot>> pinnedNewsPerCategory = <String, List<DocumentSnapshot>>{}.obs;
  var refreshNews = false.obs;
  var categoryRecived = false.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int newsLimit = 10;
  final List<String> categories = [];
  List<String> loadingTimeCategories = ["All","Sports","Cricket","Football"];
  final List<String> cat_id = [];
  final List<String> noMoreDataInThiscategorie = [];
  late TabController tabController;
  late TabController loadingTimeTabController = TabController(length: loadingTimeCategories.length, vsync: this);
  String userPhoto = "";
  DateTime? currentBackPressTime;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String uName = "",uEmail = "";
  List<dynamic> sortedCategoryId = [];

  @override
  void onInit() {
    // TODO: implement onInit
    getSortingData();
    getUserData();
    super.onInit();
  }

  Future<void> getSortingData() async {
    FirebaseFirestore _db = FirebaseFirestore.instance;
    QuerySnapshot aa = await _db.collection('catSort').where("sorting").get();
    sortedCategoryId = aa.docs[0]["sorting"];
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    userPhoto = await getUserImage();
    QuerySnapshot categorySnapshot = await FirebaseFirestore.instance.collection('categories').get();
    categories.assignAll(categorySnapshot.docs.map((doc) => doc['name'].toString()).toList());
    cat_id.assignAll(categorySnapshot.docs.map((doc) => doc['id'].toString()).toList());

    List<String> tempCategories = [];
    List<String> tempCat_id = [];
    for(int i = 0 ; i < cat_id.length ; i++){
      int tempIndex = cat_id.indexWhere((element) => element == sortedCategoryId[i].toString());
      tempCategories.add(categories[tempIndex]);
      tempCat_id.add(cat_id[tempIndex]);
    }
    categories.clear();
    cat_id.clear();
    categories.addAll(tempCategories);
    cat_id.addAll(tempCat_id);

    updateTabBar();

    if (categories.isNotEmpty) {
      changeCategory("000"); // 000 means all data
    }
  }

  updateTabBar(){
    categories.insert(0,"All");
    cat_id.insert(0,"000");
    tabController = TabController(length: categories.length, vsync: this);
    categoryRecived(true);

    tabController.addListener(() {
      if(tabController.indexIsChanging && tabController.index != tabController.previousIndex){
      }else{
        if(tabController.index != tabController.previousIndex){
          final category = cat_id[tabController.index];
          changeCategory(category);
        }
      }
    });
  }


  void changeCategory(String category) {
    selectedCategory.value = category;
    if (!newsPerCategory.containsKey(category)) {
      fetchNews(category);
    }

  }

  Future<void> fetchNews(String category) async {
    /*if (isLoading.value || noMoreDataInThiscategorie.contains(category)){
      isLoading.value = false;
      refreshNews(true);
      refreshNews(false);
      return;
    }*/

    if (noMoreDataInThiscategorie.contains(category)){
      refreshNews(true);
      refreshNews(false);
      return;
    }

    QuerySnapshot querySnapshotNew;
    if (!newsPerCategory.containsKey(category)) {
      querySnapshotNew = await _firestore
          .collection('news')
          .where('cat_id', isEqualTo: category == "000" ? null :category)
          .where('pinned', isEqualTo: true)
          .orderBy('timestamp', descending: true)
          .get();
      if (querySnapshotNew.docs.isNotEmpty) {
        pinnedNewsPerCategory[category] = querySnapshotNew.docs;
      }
    }

    try {
      QuerySnapshot querySnapshot;
      if (newsPerCategory.containsKey(category)) {
        var lastDoc = newsPerCategory[category]!.last;
        querySnapshot = await _firestore
            .collection('news')
            .where('cat_id', isEqualTo: category == "000" ? null :category)
            .orderBy('timestamp', descending: true)
            .startAfterDocument(lastDoc)
            .limit(newsLimit)
            .get();
      } else {
        querySnapshot = await _firestore
            .collection('news')
            .where('cat_id', isEqualTo: category == "000" ? null :category)
            .orderBy('timestamp', descending: true)
            .limit(newsLimit)
            .get();
      }

      if (querySnapshot.docs.isNotEmpty) {
        if (newsPerCategory.containsKey(category)) {
          newsPerCategory[category] = [...newsPerCategory[category]!, ...querySnapshot.docs];
        } else {
          //newsPerCategory[category] = querySnapshot.docs;

          if(pinnedNewsPerCategory[category] != null){
            Map<String, List<DocumentSnapshot>> tempData = <String, List<DocumentSnapshot>>{}.obs;
            tempData[category] = querySnapshot.docs;

            tempData.forEach((key, valueList) {
              if (pinnedNewsPerCategory.containsKey(key)) {
                List<DocumentSnapshot> list1 = pinnedNewsPerCategory[key]!;
                tempData[key] = valueList.where((doc2) => !list1.any((doc1) => doc1.id == doc2.id)).toList();
              }
            });

            newsPerCategory[category] = [...pinnedNewsPerCategory[category]!, ...tempData[category]!];
          }else{
            newsPerCategory[category] = querySnapshot.docs;
          }

        }
        refreshNews(true);
        refreshNews(false);
      } else {
        noMoreDataInThiscategorie.add(selectedCategory.value);
        if (noMoreDataInThiscategorie.contains(category)){
          refreshNews(true);
          refreshNews(false);
        }
      }
    } catch (e) {
      print('Error fetching news: $e');
    } finally {
      refreshNews(true);
      refreshNews(false);
    }
  }


  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Future<String> getUserImage() async{
    String photo = await SPHelper.getPhoto();
    return photo;
  }

  getUserData() async{
    uName = await SPHelper.getName();
    uEmail = await SPHelper.getEmail();
  }

  Future<void> refreshTab() async{
    await Future.delayed(const Duration(seconds: 1), () async {});
    removeNewsItem(selectedCategory.value);
  }

  void removeNewsItem(String category) {
    if (newsPerCategory.containsKey(category)) {
      newsPerCategory.removeWhere((key, value) => key == category);
      bool tempBool = noMoreDataInThiscategorie.contains(category);
      if(tempBool){
        noMoreDataInThiscategorie.remove(category);
      }
    }
    fetchNews(selectedCategory.value);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void deleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.black),
              SizedBox(width: 8),
              Text(
                'Delete Account',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
              ),
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                SPHelper.setLogedIn(false);
                Get.offAll(()=>LoginScreen());
              },
            ),
          ],
        );
      },
    );
  }
}
