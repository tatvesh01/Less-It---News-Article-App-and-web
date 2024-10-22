import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String id;
  String name;

  //CategoryModel(this.id, this.name, {required String id, required String name});
  CategoryModel({
    required this.id,
    required this.name,
  });

  factory CategoryModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return CategoryModel(
      id: doc['id'] as String,
      name: doc['name'] as String,
    );
  }
}