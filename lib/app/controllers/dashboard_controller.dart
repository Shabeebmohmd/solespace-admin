import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sole_space_admin/app/data/models/order_model.dart';
import 'package:sole_space_admin/app/data/models/product_model.dart';
import 'package:sole_space_admin/app/data/services/order_service.dart';
import 'package:sole_space_admin/app/data/services/product_service.dart';
import 'package:sole_space_admin/app/data/services/user_service.dart';

class DashboardController extends GetxController {
  final OrderService _orderService = OrderService();
  final ProductService _productService = ProductService();
  final UserService _userService = UserService();

  // Observable variables for dashboard metrics
  final RxDouble totalSales = 0.0.obs;
  final RxInt totalOrders = 0.obs;
  final RxInt totalProducts = 0.obs;
  final RxInt totalCustomers = 0.obs;
  final RxList<Order> recentOrders = <Order>[].obs;
  final RxList<Product> topProducts = <Product>[].obs;
  final RxList<FlSpot> salesData = <FlSpot>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  void refreshDashboard() {
    isLoading.value = true;
    fetchDashboardData();
  }

  void fetchDashboardData() {
    isLoading.value = true;

    // Listen to orders stream
    _orderService.getOrders().listen(
      (orders) {
        _updateOrderMetrics(orders);
      },
      onError: (error) {
        Get.snackbar('Error', 'Failed to load orders data');
        isLoading.value = false;
      },
    );

    // Listen to products stream
    _productService.getProducts().listen(
      (products) {
        _updateProductMetrics(products);
      },
      onError: (error) {
        Get.snackbar('Error', 'Failed to load products data');
        isLoading.value = false;
      },
    );

    // Listen to users stream
    _userService.getTotalUsers().listen(
      (count) {
        totalCustomers.value = count;
      },
      onError: (error) {
        Get.snackbar('Error', 'Failed to load users data');
        isLoading.value = false;
      },
    );
  }

  void _updateOrderMetrics(List<Order> orders) {
    // Calculate total sales
    totalSales.value = orders.fold(0.0, (sum, order) => sum + order.total);

    // Update total orders
    totalOrders.value = orders.length;

    // Get recent orders (last 5)
    recentOrders.value = orders.take(5).toList();

    // Calculate monthly sales data
    _calculateMonthlySales(orders);

    isLoading.value = false;
  }

  void _updateProductMetrics(List<Product> products) {
    // Update total products
    totalProducts.value = products.length;

    // Get top selling products (based on stock quantity)
    topProducts.value =
        products.where((product) => product.stockQuantity > 0).toList()
          ..sort((a, b) => b.stockQuantity.compareTo(a.stockQuantity));
  }

  void _calculateMonthlySales(List<Order> orders) {
    // Initialize a map to store sales for each month
    final monthlySales = {
      for (var month in List.generate(12, (index) => index + 1)) month: 0.0,
    };

    // Get current year
    final currentYear = DateTime.now().year;

    // Calculate total sales for each month
    for (var order in orders) {
      final orderDate = order.createdAt;
      if (orderDate.year == currentYear) {
        final month = orderDate.month;
        monthlySales[month] = (monthlySales[month] ?? 0.0) + order.total;
      }
    }

    // Convert to FlSpot list for chart
    salesData.value =
        monthlySales.entries
            .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
            .toList();
  }

  String getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return '#4CAF50'; // Green
      case 'processing':
        return '#FFC107'; // Yellow
      case 'cancelled':
        return '#F44336'; // Red
      default:
        return '#9E9E9E'; // Grey
    }
  }
}
