import 'package:HomeQuest/pages/all_products_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'create_property_page.dart';
import 'saved_properties.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'account_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ProductListPage(), // Home page content
    CreatePropertyPage(),
    SavedPropertiesPage(),
    AccountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Real state App"),
        actions: [
          ElevatedButton(onPressed: () {}, child: const Icon(Icons.search))
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.plusCircle),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.bookmark),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.userCircle),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
