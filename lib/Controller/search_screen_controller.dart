import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreenController extends GetxController{
  var query = ''.obs;
  var allDocuments = <Map<String, dynamic>>[].obs;
  var filteredNewsList = <Map<String, dynamic>>[].obs;

  RxBool refreshPage = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllArticles();
    debounce(query, (_) => searchArticles(), time: Duration(milliseconds: 500));
  }

  void updateQuery(String value) {
    query.value = value;
  }

  void fetchAllArticles() {
    refreshPage(true);
    FirebaseFirestore.instance.collection('news').get().then((snapshot) {

      List<Map<String, dynamic>> loadedNews = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      allDocuments.assignAll(loadedNews);
        refreshPage(false);
    });
  }

  void searchArticles() {
    refreshPage(true);
    if (query.value.isEmpty) {
        filteredNewsList.value = [];
      } else {
        String lowercaseSearchTerm = query.value.toLowerCase();
        filteredNewsList.value = allDocuments.where((doc) {
          String title = doc['title'].toLowerCase();
          return title.contains(lowercaseSearchTerm);
        }).toList();
      }
      refreshPage(false);
    }


  Future<void> fetchNews() async {
    if (query.value.isEmpty) {
      filteredNewsList.clear();
      return;
    }
    refreshPage(true);
    try {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('news')
          .where('title', isGreaterThanOrEqualTo: query.value)
          .where('title', isLessThanOrEqualTo: query.value + '\uf8ff')
          .get();

      List<Map<String, dynamic>> loadedNews = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      filteredNewsList.assignAll(loadedNews);
      debugPrint("newsList ==> ${filteredNewsList.length}");
      refreshPage(false);
    } catch (e) {
      refreshPage(false);
      print('Error fetching news: $e');
    }
  }

}