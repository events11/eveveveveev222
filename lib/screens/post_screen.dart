import 'dart:io';
import 'package:flutter_application_1/generated/l10n.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'language_screen.dart';
import 'pagewa_screen.dart';
import 'package:intl/intl.dart';

class CreatePostPage extends StatefulWidget {
  static const String screenRoute = 'post_screen'; 

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _filterByCategory = TextEditingController();
  final TextEditingController _currentFilter = TextEditingController();
  final TextEditingController _ruleController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  File? _pickedFile; 
  DateTime? _selectedDateTime; 
  
  Future<void> _selectDateTime() async {
    
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      locale: const Locale('en', 'US'),
    );

    if (selectedDate != null) {
      
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
        builder: (BuildContext context, Widget? child) {
          return Localizations.override(
            context: context,
            locale: const Locale('en', 'US'), 
            child: child,
          );
        },
      );

      if (selectedTime != null) {
        
        setState(() {
          _selectedDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 246, 246),
      appBar: AppBar(
        title: Text(S.of(context).Createapost),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              TextField(
                controller: _titleController,
                maxLines: null, // السماح بخطوط متعددة
                decoration: InputDecoration(
                  hintText: (S.of(context).Title),//////////////////////////////////////
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
const SizedBox(height: 16.0),
              
              TextField(
                controller: _postController,
                maxLines: null, 
                decoration: InputDecoration(
                  hintText: (S.of(context).Text),//////////////////////////////////////
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),

              const SizedBox(height: 16.0),
              
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  hintText: (S.of(context).Addalocation), //////////////////////////////////////////
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),

              const SizedBox(height: 16.0),
              
              GestureDetector(
                onTap: _selectDateTime,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 14, 18, 22), width: 2),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Text(
                    _selectedDateTime == null
                        ? (S.of(context).Timeanddate)///////////////////////////////
                        : ': ${_selectedDateTime!.toLocal().toString().split(' ')[0]} ${_selectedDateTime!.toLocal().toString().split(' ')[1].substring(0, 5)}',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 1, 3, 4),
                        fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              //
              TextField(
                controller: _ruleController,
                maxLines: null, 
                decoration: InputDecoration(
                  hintText: (S.of(context).SetRulesandTicketPrice),///////////////////////////////
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                
                ),
              ),

              const SizedBox(height: 16.0),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                onPressed: () async {
              
                  final selectedOption = await showMenu<int>(
                    context: context,
                    position: RelativeRect.fromLTRB(
                        0, 100, 0, 0), 
                    items: [
                      PopupMenuItem<int>(
                        value: 1, // قيمة الخيار الأول
                        child: Row(
                          children: [
                            Icon(Icons.person), // أيقونة بجانب النص
                            SizedBox(width: 10), 
                            Text(S.of(context).PersonalEvents),////////////////////// // 
                          ],
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 2, 
                        child: Row(
                          children: [
                            Icon(Icons.people), 
                            SizedBox(width: 10),
                             Text(S.of(context).PublicEvents),//////////////////////
                          ],
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 3, 
                        child: Row(
                          children: [
                            Icon(Icons.business), 
                            SizedBox(width: 10),
                           Text(S.of(context).OrganizationalEvents),//////////////////////
                          ],
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 4, 
                        child: Row(
                          children: [
                            Icon(Icons.beach_access), 
                            SizedBox(width: 10),
                             Text(S.of(context).RecreationalEvents),//////////////////////
                          ],
                        ),
                      ),
                    ],
                  );

                 
                  if (selectedOption != null) {
                    setState(() {
                      
                      _currentFilter.text =
                          '$selectedOption';
                    });
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.category, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      _currentFilter.text.isEmpty
                          ? (S.of(context).SelectEventType)//////////////////////
                          : _currentFilter.text,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),

              

              const SizedBox(height: 10.0),
              ElevatedButton.icon(
                  onPressed: () => _pickMedia(context),
                  icon: Icon(Icons.photo),
                  label: Text(S.of(context).Addphotovideo)),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                    onPressed: _createPost,
                    child: Text(S.of(context).Sharethepost)),
              ),

              
            ],
          ),
        ),
      ),
    );
  }

// داFirebase Storage
  Future<String?> uploadFileToStorage(File file) async {
    try {
      
      String fileName = '${DateTime.now().millisecondsSinceEpoch}';
      if (file.path.endsWith('.mp4')) {
        fileName += '.mp4'; 
      } else {
       
        fileName += '.jpg';
      }

      final storageReference =
          FirebaseStorage.instance.ref().child('uploads/media/$fileName');
      final uploadTask = storageReference.putFile(file);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('خطأ في تحميل الملف إلى Firebase Storage: $e');
      return null; // 
    }
  }

  
  Future<void> _pickMedia(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo),
              title: Text(S.of(context).Chooseapictur),
              onTap: () async {
                Navigator.pop(context,
                    await picker.pickImage(source: ImageSource.gallery));
              },
            ),
            ListTile(
              leading: Icon(Icons.videocam),
              title: Text(S.of(context).Videoselection),
              onTap: () async {
                Navigator.pop(context,
                    await picker.pickVideo(source: ImageSource.gallery));
              },
            ),
          ],
        );
      },
    );

    if (pickedFile != null) {
      setState(() {
        
        if (pickedFile.path.endsWith('.mp4')) {
    
          _pickedFile = File(pickedFile.path);
        } else {
         
          _pickedFile = File(pickedFile.path);
        }
      });
    }
  }

  void addPost(
    String userId,
    String userName,
    String content, {
    String? ImageUrl,
    String? VideoUrl,
    String? location,
    String? rule,
    DateTime? timestamp,
    String? title,
    required int del,
    //String? category,
    required int category,
  }) {
    
    final postData = {
      'userId': userId,
      'userName': userName,
      'content': content,
      'ImageUrl': ImageUrl ?? '', 
      'VideoUrl': VideoUrl ?? '',
      'location': location ?? '', 
      'category': category,
      'rule': rule ?? '',
      'times': FieldValue.serverTimestamp(),
      'timestamp': timestamp ?? '',
      'del': 1,
      'isCurrentUser': userId ==
          FirebaseAuth.instance.currentUser!.uid, 
      'title': title ??'',
      
    };

    if (timestamp != null) {
      postData['timestamp'] = timestamp;
    }

    
    FirebaseFirestore.instance.collection('users').add(postData).then((value) {
      print('تمت إضافة المنشور بنجاح.');
    }).catchError((error) {
      print('فشل في إضافة المنشور: $error');
    });
  }


  void _createPost() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final postText = _postController.text.trim();
      final location = _locationController.text.trim();
      final rule = _ruleController.text.trim();
      final category = int.tryParse(_currentFilter.text.trim()) ?? 0;
 final title= _titleController.text.trim();
      if (postText.isEmpty && _pickedFile == null && location.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).Pleaseenter),//////////////////////
          ),
        );
        return;
      }

      DateTime? timestamp = _selectedDateTime;
      String? imageUrl;
      String? videoUrl;

      if (_pickedFile != null) {
        imageUrl = await uploadFileToStorage(_pickedFile!);
        if (imageUrl == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('فشل تحميل الملف.')),
          );
          return;
        }
      }

      addPost(
        FirebaseAuth.instance.currentUser!.uid,
        FirebaseAuth.instance.currentUser!.displayName ?? "مجهول",
        postText,
        ImageUrl: imageUrl,
        location: location,
        category: category,
        timestamp: timestamp,
        rule: rule,
        del: 1,
        title: title,
      );

      
      _postController.clear();
      _locationController.clear();
      _ruleController.clear();
      _titleController.clear();
      setState(() {
        _pickedFile = null;
        _selectedDateTime = null;
        _currentFilter.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).Theposthasbeenpublishedsuccessfully),//////////////////////
        ),
      );
    }
  }
}
