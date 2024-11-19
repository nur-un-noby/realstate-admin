import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homequest/services/firebase_services.dart';

class AddPropertyScreen extends StatefulWidget {
  @override
  _AddPropertyScreenState createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseService _firebaseService = FirebaseService();
  final List<String> _images = [];
  String _title = '';
  double _price = 0;
  String _description = '';
  String _type = 'sale';

  Future<void> _pickImages() async {
    // Implement image picking functionality
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _firebaseService.addProperty(
          sellerId: FirebaseAuth.instance.currentUser!.uid,
          title: _title,
          price: _price,
          description: _description,
          type: _type,
          images: _images,
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Property')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Title'),
              onSaved: (value) => _title = value!,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter title' : null,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              onSaved: (value) => _price = double.parse(value!),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter price' : null,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
              onSaved: (value) => _description = value!,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter description' : null,
            ),
            DropdownButtonFormField<String>(
              value: _type,
              items: [
                DropdownMenuItem(value: 'sale', child: Text('For Sale')),
                DropdownMenuItem(value: 'rent', child: Text('For Rent')),
              ],
              onChanged: (value) => setState(() => _type = value!),
            ),
            ElevatedButton(
              onPressed: _pickImages,
              child: Text('Add Images'),
            ),
            ElevatedButton(
              onPressed: _handleSubmit,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}