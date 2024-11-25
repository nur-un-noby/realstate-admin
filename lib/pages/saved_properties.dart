import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SavedPropertiesPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Properties'),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('saved_properties').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No saved properties.'));
          }

          final savedProperties = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: savedProperties.length,
            itemBuilder: (context, index) {
              final savedProperty = savedProperties[index];
              return _buildSavedPropertyCard(savedProperty['propertyId']);
            },
          );
        },
      ),
    );
  }

  Widget _buildSavedPropertyCard(String propertyId) {
    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('properties').doc(propertyId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return SizedBox.shrink();
        }

        final property = snapshot.data!;
        return Card(
          elevation: 4.0,
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: FaIcon(
              FontAwesomeIcons.home,
              color: Colors.blueAccent,
            ),
            title: Text(property['title']),
            subtitle: Text(property['location']),
            trailing: Text(
              'BDT ${property['price'].toStringAsFixed(2)}',
              style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
