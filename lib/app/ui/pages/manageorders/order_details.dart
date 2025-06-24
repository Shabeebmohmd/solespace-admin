import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sole_space_admin/app/controllers/order_controller.dart';
import 'package:sole_space_admin/app/core/widgets/custom_app_bar.dart';
import 'package:sole_space_admin/app/data/models/order_model.dart';

class OrderDetailspage extends StatelessWidget {
  final Order order = Get.arguments;
  final _orderController = Get.find<OrderController>();
  OrderDetailspage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: Text('Order Details')),
        body: SingleChildScrollView(
          child: Obx(() {
            if (_orderController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (_orderController.orders.isEmpty) {
              return const Center(child: Text('No order to show'));
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildOrderCard(context, order, _orderController),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildOrderCard(
    BuildContext context,
    Order order,
    OrderController controller,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id.substring(0, 8)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildStatusChip(order.status, controller),
              ],
            ),
            const SizedBox(height: 8),
            Text('Customer: ${order.fullName ?? 'N/A'}'),
            Text('Phone: ${order.phoneNumber ?? 'N/A'}'),
            Text('Address: ${order.address ?? 'N/A'}'),
            Text('City: ${order.city ?? 'N/A'}'),
            Text('State: ${order.state ?? 'N/A'}'),
            Text('Postal Code: ${order.postalCode ?? 'N/A'}'),
            const SizedBox(height: 8),
            Text(
              'Total: \$${order.total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildOrderItems(order.items),
            const SizedBox(height: 16),
            _buildActionButtons(context, order, controller),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, OrderController controller) {
    final color = Color(
      int.parse(controller.getStatusColor(status).replaceAll('#', '0xFF')),
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    Order order,
    OrderController controller,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (order.status == 'pending')
          TextButton(
            onPressed:
                () => _showStatusUpdateDialog(context, order, controller),
            child: const Text('Update Status'),
          ),
        if (order.status == 'shipped')
          TextButton(
            onPressed:
                () => _showTrackingNumberDialog(context, order, controller),
            child: const Text('Add Tracking'),
          ),
      ],
    );
  }

  void _showStatusUpdateDialog(
    BuildContext context,
    Order order,
    OrderController controller,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Update Order Status'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (order.status == 'pending') ...[
                  ListTile(
                    title: const Text('Processing'),
                    onTap: () {
                      controller.updateOrderStatus(
                        order.userId,
                        order.id,
                        'processing',
                      );
                      Navigator.pop(context);
                    },
                  ),
                ],
                if (order.status == 'pending' ||
                    order.status == 'processing') ...[
                  ListTile(
                    title: const Text('Shipped'),
                    onTap: () {
                      controller.updateOrderStatus(
                        order.userId,
                        order.id,
                        'shipped',
                      );
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Delivered'),
                    onTap: () {
                      controller.updateOrderStatus(
                        order.userId,
                        order.id,
                        'delivered',
                      );
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Cancelled'),
                    onTap: () {
                      controller.updateOrderStatus(
                        order.userId,
                        order.id,
                        'cancelled',
                      );
                      Navigator.pop(context);
                    },
                  ),
                ],
              ],
            ),
          ),
    );
  }

  void _showTrackingNumberDialog(
    BuildContext context,
    Order order,
    OrderController controller,
  ) {
    final trackingController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Tracking Number'),
            content: TextField(
              controller: trackingController,
              decoration: const InputDecoration(
                labelText: 'Tracking Number',
                hintText: 'Enter tracking number',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (trackingController.text.isNotEmpty) {
                    controller.updateTrackingNumber(
                      order.userId,
                      order.id,
                      trackingController.text,
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  Widget _buildOrderItems(List<OrderItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  if (item.imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.imageUrl!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Size: ${item.size}'),
                        Text('Quantity: ${item.quantity}'),
                      ],
                    ),
                  ),
                  Text('\$${item.price.toStringAsFixed(2)}'),
                ],
              ),
            );
          }).toList(),
    );
  }
}
