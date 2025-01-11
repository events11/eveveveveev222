import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage2 extends StatefulWidget {
  final String userId; 
  const ProfilePage2({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage2> {
  bool _isLoading = true;
  bool _isEditingName = false;
  bool _isEditingBio = false;

  String _name = '';
  String _bio = '';
  String _profileImageUrl = '';
  String _coverImageUrl = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('uid')
          .doc(widget.userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          _name = userDoc['name'] ?? 'اسم غير متوفر';
          _bio = userDoc['bio'] ?? 'لا يوجد سيرة ذاتية';
          _profileImageUrl = userDoc['profileImage'] ?? '';
          _coverImageUrl = userDoc['coverImage'] ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateUserInfo(String id) async {
    try {
      await FirebaseFirestore.instance.collection('uid').doc(id).update(
          {'name': _nameController.text, 'bio': _bioController.text, 'id': id});

      setState(() {
        _name = _nameController.text;
        _bio = _bioController.text;
        _isEditingName = false;
        _isEditingBio = false;
      });
    } catch (e) {
      print('Error updating user info: $e');
    }
  }

  Future<void> _pickAndUploadImage(String type) async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      try {
        String filePath = '${widget.userId}/$type.jpg';
        String imageUrl = await _uploadImageToStorage(filePath, image);

        await FirebaseFirestore.instance
            .collection('uid')
            .doc(widget.userId)
            .update({
          type == 'profile' ? 'profileImage' : 'coverImage': imageUrl,
        });

        setState(() {
          if (type == 'profile') {
            _profileImageUrl = imageUrl;
          } else {
            _coverImageUrl = imageUrl;
          }
        });
      } catch (e) {
        print("Error picking and uploading image: $e");
      }
    }
  }

  Future<String> _uploadImageToStorage(String filePath, File image) async {
    
    return 'uploaded_image_url';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 10),
                  _buildProfileInfo(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileHeader() {
  return Stack(
    children: [
      // صورة الغلاف
      Container(
        height: 300,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: _coverImageUrl.isNotEmpty
                ? NetworkImage(_coverImageUrl)
                : const AssetImage('assets/default_cover.jpg')
                    as ImageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      Positioned(
        top: 125,
        left: 0,
        child: CircleAvatar(
          radius: 90,
          backgroundImage: _profileImageUrl.isNotEmpty
              ? NetworkImage(_profileImageUrl)
              : const AssetImage('assets/default_profile.jpg')
                  as ImageProvider,
        ),
      ),
    ],
  );
}


  Widget _buildProfileInfo() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
         
          Text(
            _name,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),

        
          Text(
            _bio,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
