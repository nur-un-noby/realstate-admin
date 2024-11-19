import 'package:flutter/material.dart';
import 'package:homequest/routes/app_routes.dart';

import '../../widgets/dashboard_cart.dart';
import '../../widgets/dashboard_drawer.dart';

class AgentDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agent Dashboard'),
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
            title: 'Assigned Properties',
            icon: Icons.home,
            onTap: () => Navigator.pushNamed(context, AppRoutes.propertyList),
          ),
          DashboardCard(
            title: 'My Clients',
            icon: Icons.people,
            onTap: () {},
          ),
          DashboardCard(
            title: 'Schedule',
            icon: Icons.calendar_today,
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
