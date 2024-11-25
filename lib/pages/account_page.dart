import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  List<Map<String, dynamic>> _userProperties = [];
  File? _profileImage;
  TextEditingController _nicknameController = TextEditingController();
  String? _nickname;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  // Fetch user data from Firebase Auth and Firestore
  void _getUserData() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      setState(() {
        _user = currentUser;
        _nickname = currentUser.displayName ?? 'John Doe';
        _nicknameController.text = _nickname!;
      });
      _fetchUserProperties(currentUser.uid);
    }
  }

  // Fetch user properties from Firestore
  void _fetchUserProperties(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('properties')
          .where('userId', isEqualTo: userId)
          .get();

      setState(() {
        _userProperties = snapshot.docs.map((doc) {
          return {
            'title': doc['title'],
            'location': doc['location'],
            'price': doc['price'],
            'imageUrl': doc['imageUrl'],
          };
        }).toList();
      });
    } catch (e) {
      print("Error fetching properties: $e");
    }
  }

  // Logout the user
  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  // Update nickname in Firestore and Firebase Auth
  Future<void> _updateNickname() async {
    String newNickname = _nicknameController.text;
    try {
      await _firestore.collection('users').doc(_user?.uid).update({
        'nickname': newNickname,
      });
      setState(() {
        _nickname = newNickname;
      });
      await _user?.updateDisplayName(newNickname);
    } catch (e) {
      print("Error updating nickname: $e");
    }
  }

  // Update profile picture by picking from gallery
  Future<void> _updateProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // Update password
  Future<void> _updatePassword(String newPassword) async {
    try {
      await _user?.updatePassword(newPassword);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Password updated successfully'),
      ));
    } catch (e) {
      print("Error updating password: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error updating password'),
      ));
    }
  }

  // Show settings dialog
  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Update Nickname
            TextField(
              controller: _nicknameController,
              decoration: InputDecoration(labelText: 'Nickname'),
              onSubmitted: (value) => _updateNickname(),
            ),
            SizedBox(height: 16.0),
            // Change Profile Picture
            ElevatedButton(
              onPressed: _updateProfilePicture,
              child: Text('Change Profile Picture'),
            ),
            SizedBox(height: 16.0),
            // Update Password
            ElevatedButton(
              onPressed: () {
                // This should open a dialog to enter a new password
                _updatePassword("newPassword123"); // Example new password
              },
              child: Text('Update Password'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _user == null
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User profile info section
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : (_user?.photoURL != null
                              ? NetworkImage(_user!.photoURL!)
                              : AssetImage('assets/default_avatar.png'))
                              as ImageProvider,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Center(
                    child: Text(
                      _nickname ?? 'John Doe',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Center(
                    child: Text(
                      _user?.email ?? 'john.doe@example.com',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 32.0),

                  // Dashboard section
                  Text(
                    'Your Dashboard',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),

                  // Display user-created properties
                  _userProperties.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(child: Text('No properties created yet.')),
                        )
                      : Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _userProperties.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  margin: EdgeInsets.symmetric(vertical: 8.0),
                                  elevation: 4.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(16.0),
                                    title: Text(
                                      _userProperties[index]['title'],
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(_userProperties[index]['location']),
                                    trailing: Text(
                                      'BDT ${_userProperties[index]['price']}',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        _userProperties[index]['imageUrl'],
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                  SizedBox(height: 32.0),

                  // Settings and Logout buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: FaIcon(FontAwesomeIcons.cogs, color: Colors.blue),
                      title: Text('Settings', style: TextStyle(fontSize: 18)),
                      onTap: _showSettingsDialog,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: FaIcon(FontAwesomeIcons.signOutAlt, color: Colors.red),
                      title: Text('Logout', style: TextStyle(fontSize: 18)),
                      onTap: _logout,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
