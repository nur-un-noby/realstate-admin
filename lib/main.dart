import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:homequest/models/user_type.dart';
import 'package:homequest/pages/dashboard/agent_dashboard.dart';
import 'package:homequest/pages/login_page.dart';
import 'package:homequest/pages/register_page.dart';
import 'package:homequest/pages/welcome_page.dart';
import 'package:homequest/routes/app_routes.dart';
import 'package:homequest/screens/client/client_dashboard.dart';
import 'package:homequest/screens/seller/seller_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Real Estate App',
      initialRoute: AppRoutes.welcome,
      routes: {
        AppRoutes.welcome: (context) => WelcomePage(),
        AppRoutes.login: (context) => LoginPage(userType: UserType.client),
        AppRoutes.register: (context) =>
            RegisterPage(userType: UserType.client),
        AppRoutes.clientDashboard: (context) => ClientDashboard(),
        AppRoutes.sellerDashboard: (context) => SellerDashboard(),
        AppRoutes.agentDashboard: (context) => AgentDashboard(),
      },
    );
  }
}
