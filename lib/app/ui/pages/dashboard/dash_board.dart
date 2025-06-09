import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sole_space_admin/app/core/widgets/custom_card.dart';
import 'package:sole_space_admin/app/constants/constants.dart';
import 'package:sole_space_admin/app/theme/app_color.dart';
import 'package:intl/intl.dart';
import 'package:sole_space_admin/app/controllers/dashboard_controller.dart';

class DashBoardPage extends StatelessWidget {
  const DashBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(controller),
                const SizedBox(height: 24),
                _buildSummaryCards(controller),
                const SizedBox(height: 24),
                _buildSalesChart(controller),
                const SizedBox(height: 24),
                _buildRecentOrders(controller),
                const SizedBox(height: 24),
                _buildTopProducts(controller),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeader(DashboardController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: Get.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Welcome back, Admin!',
              style: Get.textTheme.bodyLarge?.copyWith(color: Colors.grey),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.replay_outlined),
          onPressed: () {
            controller.refreshDashboard();
          },
        ),
      ],
    );
  }

  Widget _buildSummaryCards(DashboardController controller) {
    return SizedBox(
      height: MediaQuery.of(Get.context!).size.height * 0.18,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              return SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.50,
                child: _buildSummaryCard(
                  'Total Sales',
                  '\$${controller.totalSales.value.toStringAsFixed(2)}',
                  Icons.attach_money,
                  cardGradients[0],
                ),
              );
            case 1:
              return SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.50,
                child: _buildSummaryCard(
                  'Total Orders',
                  controller.totalOrders.value.toString(),
                  Icons.shopping_cart,
                  cardGradients[1],
                ),
              );
            case 2:
              return SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.50,
                child: _buildSummaryCard(
                  'Total Products',
                  controller.totalProducts.value.toString(),
                  Icons.inventory,
                  cardGradients[2],
                ),
              );
            case 3:
              return SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.50,
                child: _buildSummaryCard(
                  'Total Customers',
                  controller.totalCustomers.value.toString(),
                  Icons.people,
                  cardGradients[3],
                ),
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Gradient gradient,
  ) {
    return CustomCard(
      gradient: gradient,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesChart(DashboardController controller) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sales Overview', style: Get.textTheme.titleLarge),
          const SizedBox(height: 24),
          SizedBox(
            height: 300,
            child: Obx(() {
              if (controller.salesData.isEmpty) {
                return const Center(child: Text('No sales data available'));
              }
              return LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1000,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.2),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          );
                          String text;
                          switch (value.toInt()) {
                            case 1:
                              text = 'Jan';
                              break;
                            case 2:
                              text = 'Feb';
                              break;
                            case 3:
                              text = 'Mar';
                              break;
                            case 4:
                              text = 'Apr';
                              break;
                            case 5:
                              text = 'May';
                              break;
                            case 6:
                              text = 'Jun';
                              break;
                            case 7:
                              text = 'Jul';
                              break;
                            case 8:
                              text = 'Aug';
                              break;
                            case 9:
                              text = 'Sep';
                              break;
                            case 10:
                              text = 'Oct';
                              break;
                            case 11:
                              text = 'Nov';
                              break;
                            case 12:
                              text = 'Dec';
                              break;
                            default:
                              text = '';
                          }
                          return Text(text, style: style);
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1000,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '\$${value.toInt()}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          );
                        },
                        reservedSize: 42,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
                      left: BorderSide(color: Colors.grey.withOpacity(0.2)),
                    ),
                  ),
                  minX: 1,
                  maxX: 12,
                  minY: 0,
                  maxY:
                      controller.salesData.isEmpty
                          ? 1000
                          : controller.salesData
                                  .map((spot) => spot.y)
                                  .reduce((a, b) => a > b ? a : b) *
                              1.2,
                  lineBarsData: [
                    LineChartBarData(
                      spots: controller.salesData,
                      isCurved: true,
                      color: AppColors.primary,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: AppColors.primary,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.primary.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrders(DashboardController controller) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Orders', style: Get.textTheme.titleLarge),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.recentOrders.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No recent orders'),
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.recentOrders.length,
              itemBuilder: (context, index) {
                final order = controller.recentOrders[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                  title: Text('Order #${order.id.substring(0, 8)}'),
                  subtitle: Text(
                    DateFormat('MMM dd, yyyy').format(order.createdAt),
                  ),
                  trailing: Chip(
                    label: Text(
                      order.status,
                      style: TextStyle(
                        color: Color(
                          int.parse(
                            controller
                                .getStatusColor(order.status)
                                .replaceAll('#', '0xFF'),
                          ),
                        ),
                      ),
                    ),
                    backgroundColor: Color(
                      int.parse(
                        controller
                            .getStatusColor(order.status)
                            .replaceAll('#', '0xFF'),
                      ),
                    ).withOpacity(0.1),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTopProducts(DashboardController controller) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top Selling Products', style: Get.textTheme.titleLarge),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.topProducts.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No products available'),
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.topProducts.length,
              itemBuilder: (context, index) {
                final product = controller.topProducts[index];
                return ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                        product.imageUrls.isNotEmpty
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                product.imageUrls.first,
                                fit: BoxFit.cover,
                              ),
                            )
                            : const Icon(Icons.image),
                  ),
                  title: Text(product.name),
                  subtitle: Text('${product.stockQuantity} in stock'),
                  trailing: Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
