import 'package:flutter/material.dart';
import 'package:homequest/routes/app_routes.dart';
import 'package:homequest/widgets/dashboard_drawer.dart';

import '../../widgets/dashboard_cart.dart';

class SellerDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seller Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
          ),
        ],
      ),
      drawer: DashboardDrawer(),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16),
        children: [
          DashboardCard(
            title: 'My Properties',
            icon: Icons.home,
            onTap: () => Navigator.pushNamed(context, AppRoutes.propertyList),
          ),
          DashboardCard(
            title: 'Add Property',
            icon: Icons.add_home,
            onTap: () => Navigator.pushNamed(context, AppRoutes.propertyForm),
          ),
          DashboardCard(
            title: 'Inquiries',
            icon: Icons.question_answer,
            onTap: () {},
          ),
          DashboardCard(
            title: 'Settings',
            icon: Icons.settings,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
