import 'package:bek_shop/data/models/product/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductRepository {
  final FirebaseFirestore _firestore;

  ProductRepository({required FirebaseFirestore firebaseFirestore})
    : _firestore = firebaseFirestore;

  Future<void> addProduct({required ProductModel productModel}) async {
    try {
      var newProduct = await _firestore.collection("products").add(productModel.toJson());
      await _firestore.collection("products").doc(newProduct.id).update({
        "product_id": newProduct.id,
      });
      debugPrint("HAMMASI YAXSHI PRODUCT ADDED SUCCESS");
    } on FirebaseException catch (error) {
      debugPrint("ISHKAL BRATAN PRODUCT ADDED FAIL");
      debugPrint("ISHKAL ERROR: $error");
    }
  }

  Future<void> deleteProduct({required String productId}) async {
    try {
      await _firestore.collection("products").doc(productId).delete();
      debugPrint("HAMMASI YAXSHI PRODUCT DELETED SUCCESS");
    } on FirebaseException catch (error) {
      debugPrint("ISHKAL BRATAN PRODUCT DELETED FAIL");
      debugPrint("ISHKAL ERROR: $error");
    }
  }

  Future<void> updateProduct({required ProductModel productModel}) async {
    try {
      await _firestore
          .collection("products")
          .doc(productModel.productId)
          .update(productModel.toJson());

      debugPrint("HAMMASI YAXSHI PRODUCT UPDATED SUCCESS");
    } on FirebaseException catch (error) {
      debugPrint("ISHKAL BRATAN PRODUCT UPDATED FAIL");
      debugPrint("ISHKAL ERROR: $error");
    }
  }

  Stream<List<ProductModel>> getProductsByCategoryId({required String categoryId}) => _firestore
      .collection("products")
      .where("category_id", isEqualTo: categoryId)
      .orderBy("created_at", descending: true)
      .snapshots()
      .map((querySnapshot) {
        return querySnapshot.docs.map((doc) => ProductModel.fromJson(doc.data())).toList();
      });

  Stream<List<ProductModel>> searchProductsByCategoryIdAndName({
    required String categoryId,
    required String query,
  }) {
    return FirebaseFirestore.instance
        .collection('products')
        .where("category_id", isEqualTo: categoryId)
        .orderBy("search_keywords")
        .startAt([query.toLowerCase()])
        .endAt(["${query.toLowerCase()}\uf8ff"])
        .snapshots()
        .map((querySnapshot) {
          return querySnapshot.docs.map((doc) => ProductModel.fromJson(doc.data())).toList();
        });
  }

  Stream<List<ProductModel>> globalSearchProductsByCategoryIdAndName({required String query}) {
    return FirebaseFirestore.instance
        .collection('products')
        .orderBy("search_keywords")
        .startAt([query.toLowerCase()])
        .endAt(["${query.toLowerCase()}\uf8ff"])
        .snapshots()
        .map((querySnapshot) {
          return querySnapshot.docs.map((doc) => ProductModel.fromJson(doc.data())).toList();
        });
  }
}
