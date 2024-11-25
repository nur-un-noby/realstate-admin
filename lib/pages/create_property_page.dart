import 'dart:io';
import 'package:HomeQuest/utils/upload_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uuid/uuid.dart';
//import 'firebase_options.dart';

class CreatePropertyPage extends StatefulWidget {
  @override
  _CreatePropertyPageState createState() => _CreatePropertyPageState();
}

class _CreatePropertyPageState extends State<CreatePropertyPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  final uuid = const Uuid();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadProperty() async {
    if (_titleController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and select an image.')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Upload image to Firebase Storage
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final String imageUrl =
          await uploadImage(image: _imageFile!, id: fileName);

      // Save property details to Firestore
      await FirebaseFirestore.instance.collection('properties').add({
        "id": uuid.v1(),
        'title': _titleController.text,
        'location': _locationController.text,
        'price': double.parse(_priceController.text),
        'description': _descriptionController.text,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Property created successfully!')),
      );

      // Clear fields and image
      setState(() {
        _titleController.clear();
        _locationController.clear();
        _priceController.clear();
        _descriptionController.clear();
        _imageFile = null;
        _isUploading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Property'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Property Title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Property Title',
                prefixIcon: FaIcon(FontAwesomeIcons.home),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),

            // Location
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                prefixIcon: FaIcon(FontAwesomeIcons.mapMarkerAlt),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),

            // Price
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Price (BDT)',
                prefixIcon: FaIcon(FontAwesomeIcons.moneyBillWave),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),

            // Description
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                prefixIcon: FaIcon(FontAwesomeIcons.alignLeft),
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16.0),

            // Image Picker
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: _imageFile == null
                    ? Center(
                        child: Text(
                          'Tap to select an image',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : Image.file(_imageFile!, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 16.0),

            // Submit Button
            ElevatedButton.icon(
              onPressed: _isUploading ? null : _uploadProperty,
              icon: _isUploading
                  ? CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.0,
                    )
                  : FaIcon(FontAwesomeIcons.plusCircle),
              label: Text(_isUploading ? 'Uploading...' : 'Create Property'),
            ),
          ],
        ),
      ),
    );
  }
}
