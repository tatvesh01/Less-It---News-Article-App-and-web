import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_app/Utils/global.dart';
import 'package:news_app/Utils/helper.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../Controller/add_news_screen_controller.dart';
import 'category_manager.dart';
import 'news_manager.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'dart:convert';


class AddNewsScreen extends StatefulWidget {
  @override
  _AddNewsScreenState createState() => _AddNewsScreenState();
}

class _AddNewsScreenState extends State<AddNewsScreen> {

  final AddNewsScreenController addNewsController = Get.put(AddNewsScreenController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Add News'),
      ),
      body: Obx(()=> !addNewsController.refreshPage.value? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Form(
              key: addNewsController.formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    TextFormField(
                      controller: addNewsController.titleController,
                      decoration: InputDecoration(labelText: 'Title',
                        labelStyle: TextStyle(color: Helper.blackColor),
                        hintStyle: TextStyle(color: Helper.greyColor),
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                        filled: true,
                        fillColor: Helper.greyColor.withOpacity(0.1),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Helper.greyColor, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Helper.greyColor, width: 1.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.redAccent, width: 1.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.redAccent, width: 1.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the title';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10,),
                    /*TextFormField(
                      controller: addNewsController.descriptionController,
                      decoration: InputDecoration(labelText: 'Description',
                        labelStyle: TextStyle(color: Helper.blackColor),
                        hintStyle: TextStyle(color: Helper.greyColor),
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                        filled: true,
                        fillColor: Helper.greyColor.withOpacity(0.1),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Helper.greyColor, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Helper.greyColor, width: 1.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.redAccent, width: 1.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.redAccent, width: 1.0),
                        ),
                      ),
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the description';
                        }
                        return null;
                      },
                    ),*/

                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Helper.greyColor,width: 1),
                      ),
                      child: Column(
                        children: [
                          ToolBar(
                            toolBarColor: Colors.cyan.shade50,
                            activeIconColor: Colors.green,
                            padding: const EdgeInsets.all(8),
                            iconSize: 20,
                            controller: addNewsController.descController,
                          ),

                          SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: QuillHtmlEditor(
                              hintText: 'Description',
                              controller: addNewsController.descController,
                              isEnabled: true,
                              minHeight: MediaQuery.of(context).size.height * 0.3,
                              hintTextAlign: TextAlign.start,
                              padding: const EdgeInsets.only(left: 10, top: 5),
                              hintTextPadding: EdgeInsets.zero,
                              backgroundColor: Colors.white,
                              onFocusChanged: (hasFocus) => debugPrint('has focus $hasFocus'),
                              onTextChanged: (text) => debugPrint('widget text change $text'),
                              onEditorCreated: () => debugPrint('Editor has been loaded'),
                              onEditorResized: (height) =>
                                  debugPrint('Editor resized $height'),
                              onSelectionChanged: (sel) =>
                                  debugPrint('${sel.index},${sel.length}'),
                          ),
                        ),
                      ),
                        ],
                      ),
                    ),

                    SizedBox(height: 15,),
                    DropdownButtonFormField<String>(
                      value: addNewsController.selectedCategory,
                      hint: Text('Select Category'),
                      decoration:  InputDecoration(
                        labelText: 'Select Category',
                        labelStyle: TextStyle(color: Helper.blackColor),
                        filled: true,
                        fillColor: Helper.greyColor.withOpacity(0.1),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Helper.greyColor, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Helper.greyColor, width: 1.0),
                        ),
                      ),
                        dropdownColor: Helper.whiteColor, // Custom dropdown color
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Helper.greyColor,
                        ),
                      onChanged: (value) {
                        setState(() {
                          addNewsController.selectedCategory = value;
                          int tempIndex = addNewsController.categories.indexWhere((element) => element == value);
                          addNewsController.selectedCatId = addNewsController.catIdList[tempIndex];
                        });
                      },
                      items: addNewsController.categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 20),


                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     addNewsController.uploadedImages.isNotEmpty
                         ? Container(
                       height: 140,
                       padding: EdgeInsets.all(10),
                       decoration: BoxDecoration(
                           color: Helper.greyColor.withOpacity(0.5),
                           borderRadius: BorderRadius.all(Radius.circular(10)),
                           border: Border.all(color:Helper.greyColor,width: 2 )
                       ),
                       child: ListView.builder(
                         shrinkWrap: true,
                         scrollDirection: Axis.horizontal,
                         itemCount: addNewsController.uploadedImages.length,
                         itemBuilder: (context, index) {

                           String image = addNewsController.uploadedImages[index]["base64"];

                           return Padding(
                             padding: const EdgeInsets.all(2.0),
                             child: Container(
                               height: 120,
                               width: 120,
                               child: Stack(
                                 children: [
                                   Positioned.fill(
                                     child: ClipRRect(
                                       borderRadius: BorderRadius.circular(10),
                                       child: Image.network(image,
                                         fit: BoxFit.cover,
                                       ),
                                     ),
                                   ),
                                   Positioned(
                                       top: 5,
                                       right: 5,
                                       child: InkWell(onTap: (){
                                         addNewsController.removeImg(index,true);
                                       },child: Image.asset(Helper.closeImg,height: 35,width: 35,color: Colors.white,))
                                   ),
                                 ],
                               ),
                             ),
                           );
                         },
                       ),
                     )
                         : Column(
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         Text('Select Image For Main Screen',style: TextStyle(color: Helper.blackColor,fontSize: 18,fontWeight: FontWeight.w500),),
                         InkWell(onTap: () {
                           addNewsController.pickImages(true);
                         }, child: Image.asset(Helper.addImg,color: Helper.greyColor,height: 80,width: 80,)),
                       ],
                     ),


                     SizedBox(width: 100),


                     addNewsController.uploadedImages2.isNotEmpty
                         ? Container(
                       height: 140,
                       padding: EdgeInsets.all(10),
                       decoration: BoxDecoration(
                           color: Helper.greyColor.withOpacity(0.5),
                           borderRadius: BorderRadius.all(Radius.circular(10)),
                         border: Border.all(color:Helper.greyColor,width: 2 )
                       ),
                       child: ListView.builder(
                         shrinkWrap: true,
                         scrollDirection: Axis.horizontal,
                         itemCount: addNewsController.uploadedImages2.length,
                         itemBuilder: (context, index) {

                           String image = addNewsController.uploadedImages2[index]["base64"];

                           return Padding(
                             padding: const EdgeInsets.all(2.0),
                             child: Container(
                               height: 120,
                               width: 120,
                               child: Stack(
                                 children: [
                                   Positioned.fill(
                                     child: ClipRRect(
                                       borderRadius: BorderRadius.circular(10),
                                       child: Image.network(image,
                                         fit: BoxFit.cover,
                                       ),
                                     ),
                                   ),
                                   Positioned(
                                       top: 5,
                                       right: 5,
                                       child: InkWell(onTap: (){
                                         addNewsController.removeImg(index,false);
                                       },child: Image.asset(Helper.closeImg,height: 35,width: 35,color: Colors.white,))
                                   ),
                                 ],
                               ),
                             ),
                           );
                         },
                       ),
                     )
                         : Column(
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         Text('Select Image For Full Screen Article',style: TextStyle(color: Helper.blackColor,fontSize: 18,fontWeight: FontWeight.w500),),

                         InkWell(onTap: () {
                           addNewsController.pickImages(false);
                         }, child: Image.asset(Helper.addImg,color: Helper.greyColor,height: 80,width: 80,)),
                       ],
                     ),
                   ],
                 ),

                    SizedBox(height: 20),
                    InkWell(
                      onTap: (){
                        setState(() {
                          addNewsController.isChecked(!addNewsController.isChecked.value);
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            checkColor: Helper.whiteColor,
                            activeColor: Helper.blackColor,
                            value: addNewsController.isChecked.value,
                            onChanged: (bool? value) {
                              addNewsController.isChecked(value!);
                            },
                          ),
                          Text('Pinned Article?'),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Helper.lightBlackColor,
                        ),
                        onPressed: ()async{
                          if (await addNewsController.descController.getText() == "") {
                            Global.showToast("Please enter description");
                            return;
                          }
                          if (!addNewsController.formKey.currentState!.validate() || addNewsController.selectedCategory == null) {
                            return;
                          }
                          if(addNewsController.uploadedImages.isEmpty || addNewsController.uploadedImages2.isEmpty){
                            Global.showToast("Please Select Image First.");
                            return;
                          }

                          addNewsController.showLoading(true);
                          if(!addNewsController.editNews.value){
                            addNewsController.uploadedFileURLs.clear();
                            addNewsController.uploadedFileURLs2.clear();
                            addNewsController.uploadImages().then((value) {
                              addNewsController.addNews(true);
                            });
                          }else{

                            if(addNewsController.uploadedImages[0]["extension"] == "url" || addNewsController.uploadedImages2[0]["extension"] == "url"){

                              if(addNewsController.uploadedImages[0]["extension"] == "url"){
                                addNewsController.uploadedFileURLs.clear();
                                addNewsController.uploadedImages.forEach((element) {
                                  addNewsController.uploadedFileURLs.add(element["base64"]);
                                });
                                if(addNewsController.uploadedImages2[0]["extension"] == "url"){
                                  addNewsController.uploadedFileURLs2.clear();
                                  addNewsController.uploadedImages2.forEach((element) {
                                    addNewsController.uploadedFileURLs2.add(element["base64"]);
                                  });
                                  addNewsController.updateNews(true);
                                }else{
                                  addNewsController.uploadedFileURLs2.clear();
                                  addNewsController.uploadImagesWhileEditing(false).then((value) {
                                    addNewsController.updateNews(true);
                                  });
                                }

                              } else if(addNewsController.uploadedImages2[0]["extension"] == "url"){
                                addNewsController.uploadedFileURLs2.clear();
                                addNewsController.uploadedImages2.forEach((element) {
                                  addNewsController.uploadedFileURLs2.add(element["base64"]);
                                });
                                if(addNewsController.uploadedImages[0]["extension"] == "url"){
                                  addNewsController.uploadedFileURLs.clear();
                                  addNewsController.uploadedImages.forEach((element) {
                                    addNewsController.uploadedFileURLs.add(element["base64"]);
                                  });
                                  addNewsController.updateNews(true);
                                }else{
                                  addNewsController.uploadedFileURLs.clear();
                                  addNewsController.uploadImagesWhileEditing(true).then((value) {
                                    addNewsController.updateNews(true);
                                  });
                                }

                                /*addNewsController.uploadedFileURLs.clear();
                                addNewsController.uploadImagesWhileEditing(true).then((value) {
                                  addNewsController.updateNews(true);
                                });*/
                              }
                            }else{
                              addNewsController.uploadedFileURLs.clear();
                              addNewsController.uploadedFileURLs2.clear();
                              addNewsController.uploadImages().then((value) {
                                addNewsController.updateNews(true);
                              });
                            }
                          }

                        },
                        child: Text(addNewsController.editNews.value ? "Update News" :'Add News',style: TextStyle(color: Helper.whiteColor,fontSize: 16),),
                      ),
                    ),

                    SizedBox(height: 40),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [


                        Center(child: InkWell(
                            onTap: ()async{
                              var result = await Get.to(NewsManager());

                              if(result != null){
                                debugPrint("result ==> ${result}");
                                addNewsController.editNewsTimeRetrive(result);
                              }
                            },child: Text('News Manager',style: TextStyle(color: Helper.blackColor,fontSize: 16,decoration: TextDecoration.underline),))),

                    SizedBox(width: 100),

                        Center(child: InkWell(
                            onTap: ()async{
                              var result = await Get.to(CategoryManager());
                              addNewsController.getCategory();
                            },child: Text('Category Manager',style: TextStyle(color: Helper.blackColor,fontSize: 16,decoration: TextDecoration.underline),))),

                      ],
                    ),
                  ],
                ),
              ),
            ),

            addNewsController.showLoading.value? Center(child: Container(height: 100,width:100,
                decoration: BoxDecoration(
                    color: Helper.whiteColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Helper.blackColor,width: 2)
                )
                ,child: Center(child: CircularProgressIndicator()))) : SizedBox()
          ],
        ),
      ) : SizedBox()),
    );
  }



}
