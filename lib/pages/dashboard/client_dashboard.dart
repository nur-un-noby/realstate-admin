import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homequest/routes/app_routes.dart';
import 'package:homequest/widgets/dashboard_cart.dart';
import 'package:homequest/widgets/dashboard_drawer.dart';

class ClientDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Dashboard'),
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
            title: 'Browse Properties',
            icon: Icons.home,
            onTap: () => Navigator.pushNamed(context, AppRoutes.propertyList),
          ),
          DashboardCard(
            title: 'My Favorites',
            icon: Icons.favorite,
            onTap: () {},
          ),
          DashboardCard(
            title: 'My Inquiries',
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
