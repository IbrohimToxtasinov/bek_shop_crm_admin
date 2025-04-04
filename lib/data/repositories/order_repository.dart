import 'package:bek_shop/data/models/order/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderRepository {
  final FirebaseFirestore _firestore;

  OrderRepository({required FirebaseFirestore firebaseFirestore}) : _firestore = firebaseFirestore;

  Future<void> createOrder({required OrderModel orderModel}) async {
    try {
      var newStudent = await _firestore.collection("orders").add(orderModel.toJson());
      await _firestore.collection("orders").doc(newStudent.id).update({"order_id": newStudent.id});
      debugPrint("HAMMASI YAXSHI ORDER ADDED SUCCESS");
    } on FirebaseException catch (error) {
      debugPrint("ISHKAL BRATAN ORDER ADDED FAIL");
      debugPrint("ISHKAL ERROR: $error");
    }
  }

  Future<void> deleteOrderById({required String orderId}) async {
    try {
      await _firestore.collection("orders").doc(orderId).delete();
      debugPrint("HAMMASI YAXSHI ORDER DELETED SUCCESS");
    } on FirebaseException catch (error) {
      debugPrint("ISHKAL BRATAN ORDER DELETED FAIL");
      debugPrint("ISHKAL ERROR: $error");
    }
  }

  Future<void> updateOrder({required OrderModel orderModel}) async {
    try {
      await _firestore.collection("orders").doc(orderModel.orderId).update(orderModel.toJson());

      debugPrint("HAMMASI YAXSHI ORDER UPDATED SUCCESS");
    } on FirebaseException catch (error) {
      debugPrint("ISHKAL BRATAN ORDER UPDATED FAIL");
      debugPrint("ISHKAL ERROR: $error");
    }
  }

  Stream<List<OrderModel>> getAllOrders() {
    return _firestore.collection("orders").orderBy("create_at", descending: true).snapshots().map((
      data,
    ) {
      return data.docs.map((doc) => OrderModel.fromJson(doc.data())).toList();
    });
  }

  Stream<List<OrderModel>> searchOrdersByClientName({required String query}) {
    return FirebaseFirestore.instance
        .collection('orders')
        .orderBy("search_keywords")
        .startAt([query.toLowerCase()])
        .endAt(["${query.toLowerCase()}\uf8ff"])
        .snapshots()
        .map((querySnapshot) {
          return querySnapshot.docs.map((doc) => OrderModel.fromJson(doc.data())).toList();
        });
  }
}
