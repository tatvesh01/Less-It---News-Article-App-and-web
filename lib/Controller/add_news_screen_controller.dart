import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Utils/global.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
//TODO comment
// import 'package:firebase_storage/firebase_storage.dart';
// import 'dart:html' as htmls;

class AddNewsScreenController extends GetxController {

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  //final descriptionController = TextEditingController();
  String? selectedCategory;
  String? selectedCatId;
  final List<String> categories = [];
  final List<String> catIdList = [];
  RxBool refreshPage = false.obs;
  RxBool showLoading = false.obs;
  RxBool editNews = false.obs;
  RxBool isChecked = false.obs;
  final QuillEditorController descController = QuillEditorController();

  String serverKey = "";

  List<String> uploadedFileURLs = [];
  List<Map<String, dynamic>> uploadedImages = [];

  List<String> uploadedFileURLs2 = [];
  List<Map<String, dynamic>> uploadedImages2 = [];

  @override
  void onInit() {
    // TODO: implement onInit
    getCategory();
    _requestImageStoragePermission();
    getNotificationKey();
    super.onInit();
  }


  Future<void> pickImages(bool isMainScreen) async {
    //TODO comment
    // htmls.FileUploadInputElement uploadInput = htmls.FileUploadInputElement();
    // uploadInput.accept = 'image/*';
    // uploadInput.multiple = true;
    // uploadInput.click();
    //
    // uploadInput.onChange.listen((event) {
    //   final files = uploadInput.files!;
    //   for (var file in files) {
    //     final reader = htmls.FileReader();
    //     reader.readAsDataUrl(file);
    //     reader.onLoadEnd.listen((event) {
    //
    //       final fileName = file.name; // Get the file name
    //       final extension = fileName.split('.').last; // Get the file extension
    //
    //       if(isMainScreen){
    //         uploadedImages.add({
    //           'base64': reader.result as String,
    //           'extension': extension,
    //           'isMain': true,
    //         });
    //       }else{
    //         uploadedImages2.add({
    //           'base64': reader.result as String,
    //           'extension': extension,
    //           'isMain': false,
    //         });
    //       }
    //
    //       refreshPage(true);
    //       refreshPage(false);
    //     });
    //   }
    // });
  }

  Future<void> uploadImages() async {
//TODO comment
    // List<Map<String, dynamic>> allImages = [];
    //
    // allImages.addAll(uploadedImages);
    // allImages.addAll(uploadedImages2);
    //
    //
    // for (var image in allImages) {
    //
    //   final String base64Image = image['base64'];
    //   final String extension = image['extension'];
    //
    //   final String base64String = base64Image.split(',').last;
    //   final bytes = Base64Decoder().convert(base64String); // Decode Base64 string
    //
    //   final blob = htmls.Blob([bytes]);
    //
    //   try {
    //     FirebaseStorage storage = FirebaseStorage.instance;
    //     final ref = storage.ref().child('${DateTime.now().millisecondsSinceEpoch}.${extension}');
    //     await ref.putBlob(blob);
    //
    //     UploadTask uploadTask = ref.putBlob(blob);
    //
    //     await uploadTask.whenComplete(() async {
    //       String downloadURL = await ref.getDownloadURL();
    //
    //       bool isMain = image['isMain'];
    //       if(isMain){
    //         uploadedFileURLs.add(downloadURL);
    //       }else{
    //         uploadedFileURLs2.add(downloadURL);
    //       }
    //     }).catchError((error) {
    //       showLoading(false);
    //       print('Error occurred while uploading: $error');
    //     });
    //   } catch (e) {
    //     showLoading(false);
    //     print("Error uploading: $e");
    //   }
    // }
  }

  Future<void> uploadImagesWhileEditing(bool isMain) async {
//TODO comment
    // List<Map<String, dynamic>> allImages = [];
    //
    // if(isMain){
    //   allImages.addAll(uploadedImages);
    // }else{
    //   allImages.addAll(uploadedImages2);
    // }
    //
    // for (var image in allImages) {
    //
    //   final String base64Image = image['base64'];
    //   final String extension = image['extension'];
    //
    //   final String base64String = base64Image.split(',').last;
    //   final bytes = Base64Decoder().convert(base64String); // Decode Base64 string
    //
    //   final blob = htmls.Blob([bytes]);
    //
    //   try {
    //     FirebaseStorage storage = FirebaseStorage.instance;
    //     final ref = storage.ref().child('${DateTime.now().millisecondsSinceEpoch}.${extension}');
    //     await ref.putBlob(blob);
    //
    //     UploadTask uploadTask = ref.putBlob(blob);
    //
    //     await uploadTask.whenComplete(() async {
    //       String downloadURL = await ref.getDownloadURL();
    //
    //       bool isMain = image['isMain'];
    //       if(isMain){
    //         uploadedFileURLs.add(downloadURL);
    //       }else{
    //         uploadedFileURLs2.add(downloadURL);
    //       }
    //     }).catchError((error) {
    //       showLoading(false);
    //       print('Error occurred while uploading: $error');
    //     });
    //   } catch (e) {
    //     showLoading(false);
    //     print("Error uploading: $e");
    //   }
    // }
  }



  void getCategory() async {
    final QuerySnapshot categorySnapshot = await FirebaseFirestore.instance
        .collection('categories').get();
    categories.clear();
    catIdList.clear();
    categories.addAll(categorySnapshot.docs.map((doc) => doc['name'].toString()).toList());
    catIdList.addAll(categorySnapshot.docs.map((doc) => doc['id'].toString()).toList());
    refreshPage(true);
    refreshPage(false);
  }


  Future<void> addNews(bool hasImages) async {

    DateTime currentTime = DateTime.now();
    String iso8601Timestamp = currentTime.toIso8601String();

    if (formKey.currentState!.validate() && selectedCategory != null) {
      try {
        await FirebaseFirestore.instance.collection('news').add({
          'title': titleController.text,
          'description': await descController.getText(),
          'category': selectedCategory,
          'cat_id': selectedCatId,
          'timestamp': iso8601Timestamp,
          'imgs': hasImages ? uploadedFileURLs : [],
          'imgsIn': hasImages ? uploadedFileURLs2 : [],
          'pinned': isChecked.value,
        });

        Global.showToast('News Added Successfully');
        sendFCMNotification(titleController.text.toString(), 'New offer arrived..');
        clearAllData();
        showLoading(false);
      } catch (e) {
        showLoading(false);
        Global.showToast('Failed to add news');
      }
    }else{
      showLoading(false);
    }
  }

  String permissionStatus = "Unknown";

  Future<void> _requestImageStoragePermission() async {
    PermissionStatus status;
    status = await Permission.storage.request();

      permissionStatus = status.isGranted
          ? "Permission Granted"
          : status.isDenied
          ? "Permission Denied"
          : status.isPermanentlyDenied
          ? "Permission Permanently Denied"
          : "Permission Status Unknown";


    debugPrint("permissionStatus ==> ${permissionStatus}");
    if (status.isPermanentlyDenied) {
      Global.showToast("please allow storage permission");
    }
  }

  void removeImg(int index, bool fromMainImage) {
    if(fromMainImage){
      uploadedImages.removeAt(index);
    }else{
      uploadedImages2.removeAt(index);
    }
    refreshPage(true);
    refreshPage(false);
  }


  String editTimeDocId = "";
  void editNewsTimeRetrive(docId) async{
    try {
      editNews(true);
      editTimeDocId = docId;
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await FirebaseFirestore.instance.collection('news').doc(editTimeDocId).get();
      if (documentSnapshot.exists) {
        documentSnapshot.data();

        titleController.text = documentSnapshot["title"];
        //descriptionController.text = documentSnapshot["description"];
        await descController.setText(documentSnapshot["description"]);
        descController.enableEditor(true);
        selectedCategory = documentSnapshot["category"];
        selectedCatId = documentSnapshot["cat_id"];

        Map<String, dynamic>? newsData = documentSnapshot.data() as Map<String, dynamic>?;
        bool hasPinnedKey = newsData!.containsKey("pinned");
        if(hasPinnedKey){
          isChecked(documentSnapshot["pinned"]);
        }else{
          isChecked(false);
        }


        List<dynamic> imageList = documentSnapshot["imgs"];
        uploadedImages.clear();
        imageList.forEach((element) {
          uploadedImages.add({
            'base64': element,
            'extension': "url",
            'isMain': true,
          });
        });

        List<dynamic> imageListIn = documentSnapshot["imgsIn"];
        uploadedImages2.clear();
        imageListIn.forEach((element) {
          uploadedImages2.add({
            'base64': element,
            'extension': "url",
            'isMain': false,
          });
        });

        refreshPage(true);
        refreshPage(false);

      } else {
        print('Document does not exist.');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }


  Future<void> updateNews(bool hasImages) async {


    if (formKey.currentState!.validate() && selectedCategory != null) {
      try {
        await FirebaseFirestore.instance.collection('news').doc(editTimeDocId).update({
          'title': titleController.text,
          'description': await descController.getText(),
          'category': selectedCategory,
          'cat_id': selectedCatId,
          //'timestamp': iso8601Timestamp,
          'imgs': hasImages ? uploadedFileURLs : [],
          'imgsIn': hasImages ? uploadedFileURLs2 : [],
          'pinned': isChecked.value,
        });

        Global.showToast('News Updated Successfully');
        clearAllData();
        editNews(false);
        showLoading(false);
      } catch (e) {
        showLoading(false);
        Global.showToast('Failed to add news');
      }
    }else{
      showLoading(false);
    }
  }

  clearAllData(){
    titleController.text = "";
    //descriptionController.text = "";
    descController.clear();
    selectedCategory = categories[0];
    selectedCatId = catIdList[0];
    uploadedImages.clear();
    uploadedImages2.clear();
  }

  getNotificationKey()async{
    final datas = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    final client = await clientViaServiceAccount(ServiceAccountCredentials.fromJson(
        {
          "type": "service_account",
          "project_id": "lessit-new",
          "private_key_id": "56afc475e332c8693b18a6e6e040bdcbae816fd0",
          "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC4ScMkWXWN+IOz\nZPFasT+u19pDHio4sQtxwHE03Cv6GKQzv/mjBIoET+jStbO+hoWoDdwHyZa0eHl6\ntaY5XdU2tv/TFmDIDm9Zbq9wdug3fwEa+PHuDWTfSyTug8L3tZfm2mJoX/Ks+ZX5\nRrHeDyJCujuXRKvKTj5lWblr7G/AxCkqwRzpMssXkl92gjG7T/Uoimqy5Thgial0\n7+UmMnD+YyQ6DtO0AONAfNDA7YOjkjXbR8PTE2emh4yXiTwSr/Cd3YmzbaxQiBRY\nbuEjx0Tg8fvSDP2pmI2dq3RKFNNiJXybZ3dhD+FEslU90N57ryzjJ7yXZCsBo8gp\n3cbDPHYzAgMBAAECggEABh7nt6SuU4F2LlZ4mwCEEvSMWpT9O1Ygq9iDv15d/40j\nTFdgnS92E1/sEFjZ7XFeWGSNcvIZFUljD4D0/QwcHBhxNWZANKTLbKGme1/CUAWM\ngy7S1OCRAcbnJRzZ3uGjIpcM6avgzX9EoeYyhiOOib98YdvKsN9vEcKsdo8rGbCG\nWXhwuwsjdwt4Cibslh7e1kGOHvZyYRit1sIe1tXsk5nh5STDzklxMTvMNreY/oYS\nwWd1g+jeQ+sKDAWEIYmk7c7XJ0L0fNuLfME3o7hHXu+mtAKrDBAtj/qDloYkW3/e\nFNxrwx1KZP3VINQpANgyAw1AsyBa666g2xq33J/WsQKBgQDw3N2p01ptt316+7y2\nlY2qzO/bTDXYYoVeHvKcocSE9SvhWjaVPASohvpoLw+di/n1rCqbHj4wdZV+uiQ2\ndCZesn1Oz2DFBqdHiI+urKt16UodYA1FcgjpeYE/p8QT8jXn7ccm2tuAeEXwZT7Y\nOO1G8Rvm4rUKQc3zAf3qs8mjXQKBgQDD3rE+xRnafeximmm8apYI1WcUofj/mt0j\nLdl/modlJx0N1CmtDmFvpga/JjxVzvE/2ny1NUwjk0WP5XGMl1mvx1XsjMUwsyzk\nnNL/Y+iPAD0e24feAHQV+GeSNXB6Pueh6/q5LJ41F6ry67UDjh9qdsxGkVrps/hs\n58mOg672zwKBgFNMfxiBcK+rGqlSsEQQ2qqsL3OPGrwX7nnLiColQ/qbc65+7YuU\n8yN5ctZfGC5rP2n4Pc/hmK5Xq/jk1StD5hUv82gzDgt1rpptnwtQygeAQ9J+6ngO\n5QghrlJeadBgHsZ0FEDaxbjbX4yw5xgOL/kt33FtDCFc+qXFFZR60ww9AoGBAJuK\nXUBWbuhl9PB8ZJj+HzTWmmv1D/GSvibwgvZk9T3raJQRtiK598AcnODwcRtHIacu\nTrfrohHiImxZrOkTS2JeLiqRwwmgT3cf3iJ26Ted3euCM4uk2oqT31No4nABQhoA\ndfLUrrHEoLkVWoJ/Ow1lV2R2izZo908sZY+pnKhbAoGAVZM/vxgUoajeDagEB7HH\n7n3sPXJ6hXvRFX5hHa42jYgj/Gh+225AHS9vYxpS87/hXtdURgK022ntewAcnt3H\ntmGug75Pa4/mPJvfZktk/2FshTF206nPBQ0M0VxCahFOMb2axIyKYn9UyDa+PnjI\nnvPCTfJMkRv0JnUOP0uDdMU=\n-----END PRIVATE KEY-----\n",
          "client_email": "firebase-adminsdk-3tjwg@lessit-new.iam.gserviceaccount.com",
          "client_id": "106235062433262755229",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-3tjwg%40lessit-new.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }
    ), datas);

    serverKey = client.credentials.accessToken.data;
  }

  Future<void> sendFCMNotification(String title, String body) async {

    final String fcmUrl = 'https://fcm.googleapis.com/v1/projects/lessit-new/messages:send';

    final Map<String, dynamic> notificationData = {
      'message': {
        'topic': "notification",
        'notification': {
          'title': title,
          'body': body,
        },
      },
    };

    final response = await http.post(
      Uri.parse(fcmUrl),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $serverKey',
      },
      body: jsonEncode(notificationData),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully!');
    } else {
      print('Failed to send notification: ${response.body}');
    }
  }
}
