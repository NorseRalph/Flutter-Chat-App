import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? _pickedImage;
  String? _userName;
  String? _userImageUrl;
  TextEditingController? _userNameController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      _userNameController!.text = userData['username'] ?? '';
      _userName = userData['username'];
      _userImageUrl = userData['imageUrl'];
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);
    if (pickedImage != null) {
      setState(() {
        _pickedImage = File(pickedImage.path);
        _isLoading = true;
      });
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    final user = _auth.currentUser;
    if (user != null && _pickedImage != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${user.uid}.jpg');
      await ref.putFile(_pickedImage!);
      final url = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'imageUrl': url});
      setState(() {
        _userImageUrl = url;
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile picture updated successfully')));
    }
  }

  Future<void> _saveForm() async {
    final isValid = _userNameController!.text.isNotEmpty;
    if (!isValid || _userName == _userNameController!.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No changes detected')));
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final user = _auth.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'username': _userNameController!.text});
      setState(() {
        _userName = _userNameController!.text;
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Username updated successfully')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFFEB81C),
        actions: [
          if (_isLoading)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: CircularProgressIndicator(color: Colors.white),
            ),
          if (!_isLoading)
            IconButton(
              icon: Icon(Icons.save, color: Colors.white),
              onPressed: _saveForm,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundImage: _pickedImage != null
                  ? FileImage(_pickedImage!)
                  : (_userImageUrl != null
                          ? NetworkImage(_userImageUrl!)
                          : AssetImage('assets/images/imperial_logo.png'))
                      as ImageProvider,
              child: _pickedImage == null && _userImageUrl == null
                  ? Icon(Icons.person, size: 60)
                  : null,
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.image),
              label: Text('Change profile picture'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFEB81C),
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _userNameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            if (user != null)
              Text(
                'Email: ${user.email}',
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _userNameController?.dispose();
    super.dispose();
  }
}
