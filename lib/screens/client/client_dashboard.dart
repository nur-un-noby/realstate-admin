import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homequest/models/property.dart';
import 'package:homequest/services/firebase_services.dart';
import 'package:homequest/widgets/property_card.dart';


class ClientDashboard extends StatefulWidget {
  @override
  _ClientDashboardState createState() => _ClientDashboardState();
}

class _ClientDashboardState extends State<ClientDashboard> {
  final FirebaseService _firebaseService = FirebaseService();
  RangeValues _priceRange = RangeValues(0, 1000000);
  String _searchQuery = '';
  String _propertyType = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Properties'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search properties...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firebaseService.getProperties(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                var properties = snapshot.data!.docs
                    .map((doc) => Property.fromFirestore(doc))
                    .where((property) {
                  bool matchesSearch = property.title
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase());
                  bool matchesPrice = property.price >= _priceRange.start &&
                      property.price <= _priceRange.end;
                  bool matchesType = _propertyType == 'all' ||
                      property.type == _propertyType;
                  return matchesSearch && matchesPrice && matchesType;
                }).toList();

                return ListView.builder(
                  itemCount: properties.length,
                  itemBuilder: (context, index) {
                    return PropertyCard(property: properties[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Filter Properties'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Price Range'),
            RangeSlider(
              values: _priceRange,
              min: 0,
              max: 1000000,
              divisions: 100,
              labels: RangeLabels(
                '\$${_priceRange.start.round()}',
                '\$${_priceRange.end.round()}',
              ),
              onChanged: (values) => setState(() => _priceRange = values),
            ),
            DropdownButton<String>(
              value: _propertyType,
              items: [
                DropdownMenuItem(value: 'all', child: Text('All')),
                DropdownMenuItem(value: 'sale', child: Text('For Sale')),
                DropdownMenuItem(value: 'rent', child: Text('For Rent')),
              ],
              onChanged: (value) => setState(() => _propertyType = value!),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Apply'),
          ),
        ],
      ),
    );
  }
}
