import 'package:flutter/material.dart';
import 'package:sole_space_admin/app/routes/app_routes.dart';

final menuItems = [
  {'icon': Icons.dashboard, 'title': 'Dashboard', 'route': AppRoutes.dashboard},
  {
    'icon': Icons.add_box,
    'title': 'Manage Brands',
    'route': AppRoutes.manageBrand,
  },
  {
    'icon': Icons.inventory,
    'title': 'Manage Products',
    'route': AppRoutes.manageProducts,
  },
  {
    'icon': Icons.shopping_cart,
    'title': 'Manage Orders',
    'route': AppRoutes.manageOrders,
  },
  {
    'icon': Icons.people,
    'title': 'Manage Users',
    'route': AppRoutes.manageUsers,
  },
];

// First, define your gradients list outside build method or at class level
final List<Gradient> cardGradients = [
  const LinearGradient(
    colors: [Color(0xFF6448FE), Color(0xFF5FC6FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  const LinearGradient(
    colors: [Color(0xFFFF9A9E), Color(0xFFFAD0C4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  const LinearGradient(
    colors: [Color(0xFF08AEEA), Color(0xFF2AF598)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  const LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  const LinearGradient(
    colors: [Color(0xFFa18cd1), Color(0xFFfbc2eb)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
];
