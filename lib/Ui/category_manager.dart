import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/category_model.dart';
import '../Utils/helper.dart';

class CategoryManager extends StatefulWidget {
  @override
  _CategoryManagerState createState() => _CategoryManagerState();
}

class _CategoryManagerState extends State<CategoryManager> {
  final CollectionReference categories = FirebaseFirestore.instance.collection('categories');
  List<CategoryModel> categoryData = [];
  List<dynamic> categoryId = [];
  String parentId = "";
  @override
  void initState() {

    getSortingData();
    super.initState();
  }

  getData()async{
    QuerySnapshot snapshot = await categories.get();
    categoryData = snapshot.docs.map((doc) {
      return CategoryModel.fromDocumentSnapshot(doc);
    }).toList();

    List<CategoryModel> tempCatData = [];
    for(int i = 0 ; i < categoryData.length ; i++){
      int tempIndex = categoryData.indexWhere((element) => element.id == categoryId[i].toString());
      tempCatData.add(categoryData[tempIndex]);
    }
    categoryData.clear();
    categoryData.addAll(tempCatData);

    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Manager'),
      ),
      body:  categoryData.isNotEmpty ? ReorderableListView(
        buildDefaultDragHandles: false,
        onReorder: (oldIndex, newIndex) {

          setState(() {
            if (newIndex > oldIndex) newIndex--;
            CategoryModel item = categoryData.removeAt(oldIndex);
            categoryData.insert(newIndex, item);
          });

          categoryId.clear();
          categoryData.forEach((element) {
            categoryId.add(element.id);
          });
          addDocumentWithArray(categoryId);

        },
        children: categoryData.map((item) {
          var tempIndex = categoryData.indexOf(item);

          return categoryView(item,tempIndex);

        }).toList(),
      ):Center(child: Image.asset(Helper.noDataImg,height: 100,width: 100,),),



      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          _showCategoryDialog(context, null, null);
        },
        child: Icon(Icons.add,color: Helper.whiteColor,),
      ),
    );
  }

  Widget categoryView(CategoryModel category, int tempIndex){
    return Container(
      height: 100,
      key: Key("${category.id}"),
        margin: EdgeInsets.symmetric(vertical: 7,horizontal: 10),
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: Helper.greyColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Helper.greyColor,width: 1)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: ReorderableDragStartListener(
                index: tempIndex,
                child: Icon(Icons.menu),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(category.name,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showCategoryDialog(
                        context, category.id, category.name);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteCategory(category.id);
                  },
                ),
                SizedBox(width: 10,),


              ],
            ),
          ],
        )


    );
  }

  void _showCategoryDialog(BuildContext context, String? id, String? name) {
    final _categoryController = TextEditingController(text: name);
    final isEdit = id != null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Category' : 'Add Category'),
          content: TextFormField(
            controller: _categoryController,
            decoration: InputDecoration(labelText: 'Category Name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_categoryController.text.isNotEmpty) {
                  if (isEdit) {
                    _editCategory(id!, _categoryController.text);
                  } else {
                    _addCategory(_categoryController.text);
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(isEdit ? 'Update' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addCategory(String name) async {
    var code = Random().nextInt(900) + 100;
    await categories.add({'name': name,'id': code.toString()});
    categoryData.add(CategoryModel(id: code.toString(),name: name));
    categoryId.add(code.toString());
    await _db.collection('catSort').doc(parentId).update({'sorting': categoryId});
    setState(() {
    });
  }

  Future<void> _editCategory(String id, String name) async {
    //await categories.doc(id).update({'name': name});

    QuerySnapshot querySnapshot = await categories.where('id', isEqualTo: id).get();
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await doc.reference.update({'name': name});
    }
    int tempIndex = categoryData.indexWhere((element) => element.id == id.toString());
    categoryData[tempIndex].name = name;
    setState(() {

    });
    
  }

  Future<void> _deleteCategory(String id) async {
    //await categories.doc().delete();

    QuerySnapshot querySnapshot = await categories.where('id', isEqualTo: id).get();
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await doc.reference.delete();
    }

    int tempIndex = categoryData.indexWhere((element) => element.id == id.toString());
    categoryData.removeAt(tempIndex);
    categoryId.removeAt(tempIndex);
    await _db.collection('catSort').doc(parentId).update({'sorting': categoryId});
    setState(() {

    });
  }

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addDocumentWithArray(List<dynamic> data) async {
    await _db.collection('catSort').doc(parentId).update({'sorting': data});
  }

  Future<void> getSortingData() async {
    QuerySnapshot aa = await _db.collection('catSort').where("sorting").get();
    parentId = aa.docs[0].id;
    categoryId = aa.docs[0]["sorting"];
    getData();
  }
}