// lib/screens/property_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/property.dart';

class PropertyDetailScreen extends StatefulWidget {
  final Property property;

  PropertyDetailScreen({required this.property});

  @override
  _PropertyDetailScreenState createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  final _commentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final doc = await _firestore
          .collection('favorites')
          .doc('${userId}_${widget.property.id}')
          .get();
      setState(() {
        _isFavorite = doc.exists;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final docRef = _firestore
          .collection('favorites')
          .doc('${userId}_${widget.property.id}');

      if (_isFavorite) {
        await docRef.delete();
      } else {
        await docRef.set({
          'userId': userId,
          'propertyId': widget.property.id,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      setState(() {
        _isFavorite = !_isFavorite;
      });
    }
  }

  Future<void> _submitReview() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null && _commentController.text.isNotEmpty) {
      await _firestore.collection('reviews').add({
        'userId': userId,
        'propertyId': widget.property.id,
        'comment': _commentController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _commentController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Review submitted successfully')),
      );
    }
  }

  void _contactSeller() {
    // Implement contact functionality
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contact Seller'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Send Email'),
              onTap: () {
                // Implement email functionality
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Call'),
              onTap: () {
                // Implement call functionality
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Property Details'),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : null,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Carousel
            if (widget.property.images.isNotEmpty)
              CarouselSlider(
                options: CarouselOptions(
                  height: 300,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  enableInfiniteScroll: false,
                ),
                items: widget.property.images.map((imageUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    },
                  );
                }).toList(),
              ),

            // Property Details
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.property.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${widget.property.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.green,
                        ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(widget.property.description),
                  SizedBox(height: 16),
                  
                  // Property Type Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.property.type.toUpperCase(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  // Contact Button
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _contactSeller,
                    child: Text('Contact Seller'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 45),
                    ),
                  ),

                  // Reviews Section
                  SizedBox(height: 24),
                  Text(
                    'Reviews',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Write a review...',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _submitReview,
                      ),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 16),
                  
                  // Reviews Stream
                  StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('reviews')
                        .where('propertyId', isEqualTo: widget.property.id)
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error loading reviews');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var review = snapshot.data!.docs[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Text(review['comment']),
                              subtitle: Text(
                                'Posted on ${(review['timestamp'] as Timestamp).toDate().toString()}',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}