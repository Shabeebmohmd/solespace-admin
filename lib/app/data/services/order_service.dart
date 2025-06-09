import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sole_space_admin/app/data/models/order_model.dart' as models;

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all orders from all users
  Stream<List<models.Order>> getOrders() {
    return _firestore.collection('users').snapshots().asyncMap((
      usersSnapshot,
    ) async {
      List<models.Order> allOrders = [];

      for (var userDoc in usersSnapshot.docs) {
        try {
          final ordersSnapshot =
              await userDoc.reference
                  .collection('orders')
                  .orderBy('createdAt', descending: true)
                  .get();

          for (var orderDoc in ordersSnapshot.docs) {
            try {
              final orderData = orderDoc.data();
              // Add userId and id to the order data
              orderData['userId'] = userDoc.id;
              orderData['id'] = orderDoc.id;

              final order = models.Order.fromJson(orderData);
              allOrders.add(order);
            } catch (e) {
              log(
                'Error parsing order ${orderDoc.id} for user ${userDoc.id}: $e',
              );
              // Continue with other orders even if one fails
              continue;
            }
          }
        } catch (e) {
          log('Error fetching orders for user ${userDoc.id}: $e');
          // Continue with other users even if one fails
          continue;
        }
      }

      // Sort all orders by createdAt
      allOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      log('All orders: $allOrders');
      return allOrders;
    });
  }

  // Get orders by status from all users
  Stream<List<models.Order>> getOrdersByStatus(String status) {
    return _firestore.collection('users').snapshots().asyncMap((
      usersSnapshot,
    ) async {
      List<models.Order> filteredOrders = [];

      for (var userDoc in usersSnapshot.docs) {
        try {
          // First get all orders for the user
          final ordersSnapshot =
              await userDoc.reference
                  .collection('orders')
                  .orderBy('createdAt', descending: true)
                  .get();

          // Then filter by status in memory
          for (var orderDoc in ordersSnapshot.docs) {
            try {
              final orderData = orderDoc.data();
              if (orderData['status'] == status) {
                // Add userId and id to the order data
                orderData['userId'] = userDoc.id;
                orderData['id'] = orderDoc.id;

                final order = models.Order.fromJson(orderData);
                filteredOrders.add(order);
              }
            } catch (e) {
              log(
                'Error parsing order ${orderDoc.id} for user ${userDoc.id}: $e',
              );
              // Continue with other orders even if one fails
              continue;
            }
          }
        } catch (e) {
          log('Error fetching orders for user ${userDoc.id}: $e');
          // Continue with other users even if one fails
          continue;
        }
      }

      // Sort all orders by createdAt
      filteredOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return filteredOrders;
    });
  }

  // Update order status
  Future<void> updateOrderStatus(
    String userId,
    String orderId,
    String newStatus,
  ) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('orders')
          .doc(orderId)
          .update({
            'status': newStatus,
            'updatedAt': DateTime.now().toIso8601String(),
          });
    } catch (e) {
      log('Error updating order status: $e');
      throw Exception('Failed to update order status: $e');
    }
  }

  // Update tracking number
  Future<void> updateTrackingNumber(
    String userId,
    String orderId,
    String trackingNumber,
  ) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('orders')
          .doc(orderId)
          .update({
            'trackingNumber': trackingNumber,
            'updatedAt': DateTime.now().toIso8601String(),
          });
    } catch (e) {
      log('Error updating tracking number: $e');
      throw Exception('Failed to update tracking number: $e');
    }
  }

  // Get order by ID
  Future<models.Order?> getOrderById(String userId, String orderId) async {
    try {
      final doc =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('orders')
              .doc(orderId)
              .get();

      if (!doc.exists) {
        return null;
      }

      final orderData = doc.data()!;
      orderData['userId'] = userId;
      orderData['id'] = doc.id;

      return models.Order.fromJson(orderData);
    } catch (e) {
      log('Error getting order by ID: $e');
      return null;
    }
  }
}
