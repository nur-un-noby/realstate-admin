import 'package:flutter/material.dart';
import '../models/user_type.dart';
import 'login_page.dart';
import 'register_page.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to Real Estate App',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50),
              _buildUserTypeSection(
                context,
                'Client',
                UserType.client,
                Icons.person,
              ),
              SizedBox(height: 20),
              _buildUserTypeSection(
                context,
                'Seller',
                UserType.seller,
                Icons.store,
              ),
              SizedBox(height: 20),
              _buildUserTypeSection(
                context,
                'Agent',
                UserType.agent,
                Icons.business,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeSection(
    BuildContext context,
    String title,
    UserType userType,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 48),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(userType: userType),
                    ),
                  ),
                  child: Text('Login'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterPage(userType: userType),
                    ),
                  ),
                  child: Text('Register'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}