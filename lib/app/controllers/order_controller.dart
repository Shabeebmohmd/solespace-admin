import 'package:get/get.dart';
import 'package:sole_space_admin/app/data/models/order_model.dart';
import 'package:sole_space_admin/app/data/services/order_service.dart';

class OrderController extends GetxController {
  final OrderService _orderService = OrderService();
  final RxList<Order> orders = <Order>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedStatus = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  void fetchOrders() {
    isLoading.value = true;
    if (selectedStatus.value == 'all') {
      _orderService.getOrders().listen(
        (orderList) {
          orders.value = orderList;
          isLoading.value = false;
        },
        onError: (error) {
          Get.snackbar('Error', 'Failed to load orders');
          isLoading.value = false;
        },
      );
    } else {
      _orderService
          .getOrdersByStatus(selectedStatus.value)
          .listen(
            (orderList) {
              orders.value = orderList;
              isLoading.value = false;
            },
            onError: (error) {
              Get.snackbar('Error', 'Failed to load orders');
              isLoading.value = false;
            },
          );
    }
  }

  Future<void> updateOrderStatus(
    String userId,
    String orderId,
    String newStatus,
  ) async {
    try {
      isLoading.value = true;
      await _orderService.updateOrderStatus(userId, orderId, newStatus);
      Get.snackbar('Success', 'Order status updated successfully');
      fetchOrders(); // Refresh the orders list
    } catch (e) {
      Get.snackbar('Error', 'Failed to update order status');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateTrackingNumber(
    String userId,
    String orderId,
    String trackingNumber,
  ) async {
    try {
      isLoading.value = true;
      await _orderService.updateTrackingNumber(userId, orderId, trackingNumber);
      Get.snackbar('Success', 'Tracking number updated successfully');
      fetchOrders(); // Refresh the orders list
    } catch (e) {
      Get.snackbar('Error', 'Failed to update tracking number');
    } finally {
      isLoading.value = false;
    }
  }

  void filterByStatus(String status) {
    if (selectedStatus.value != status) {
      selectedStatus.value = status;
      fetchOrders();
    }
  }

  String getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return '#FFA500'; // Orange
      case 'processing':
        return '#1E90FF'; // Dodger Blue
      case 'shipped':
        return '#4169E1'; // Royal Blue
      case 'delivered':
        return '#32CD32'; // Lime Green
      case 'cancelled':
        return '#FF0000'; // Red
      default:
        return '#808080'; // Gray
    }
  }
}
