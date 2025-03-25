import 'package:bek_shop/data/models/category/category_model.dart';
import 'package:bek_shop/data/models/product/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryRepository {
  final FirebaseFirestore _firestore;

  CategoryRepository({required FirebaseFirestore firebaseFirestore})
    : _firestore = firebaseFirestore;

  Future<void> addCategory({required CategoryModel categoryModel}) async {
    try {
      var newStudent = await _firestore.collection("categories").add(categoryModel.toJson());
      await _firestore.collection("categories").doc(newStudent.id).update({
        "category_id": newStudent.id,
      });
      debugPrint("HAMMASI YAXSHI CATEGORY ADDED SUCCESS");
    } on FirebaseException catch (error) {
      debugPrint("ISHKAL BRATAN CATEGORY ADDED FAIL");
      debugPrint("ISHKAL ERROR: $error");
    }
  }

  Future<void> deleteCategory({required String categoryId}) async {
    try {
      await _firestore.collection("categories").doc(categoryId).delete();
      debugPrint("HAMMASI YAXSHI CATEGORY DELETED SUCCESS");
    } on FirebaseException catch (error) {
      debugPrint("ISHKAL BRATAN CATEGORY DELETED FAIL");
      debugPrint("ISHKAL ERROR: $error");
    }
  }

  Future<void> updateCategory({required CategoryModel categoryModel}) async {
    try {
      await _firestore
          .collection("categories")
          .doc(categoryModel.categoryId)
          .update(categoryModel.toJson());

      debugPrint("HAMMASI YAXSHI CATEGORY UPDATED SUCCESS");
    } on FirebaseException catch (error) {
      debugPrint("ISHKAL BRATAN CATEGORY UPDATED FAIL");
      debugPrint("ISHKAL ERROR: $error");
    }
  }

  Stream<List<CategoryModel>> getAllCategories() {
    return _firestore
        .collection("categories")
        .orderBy("created_at", descending: true)
        .snapshots()
        .map((data) {
          return data.docs.map((doc) => CategoryModel.fromJson(doc.data())).toList();
        });
  }
}
