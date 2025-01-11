import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_1/generated/l10n.dart';
import 'package:flutter_application_1/screens/Video_screen.dart';
import 'package:flutter_application_1/screens/welcome_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';


//import 'package:timeago/timeago.dart' as timeago; // استيراد مكتبة timeago
class ProfilePage extends StatefulWidget {
  static const String screenRoute = 'ProfilePage_screen';
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String _name = '';
  String _bio = '';
  String _profileImageUrl =
      'https://www.w3schools.com/w3images/avatar2.png'; // صورة افتراضية
  String _coverImageUrl =
      'https://www.w3schools.com/w3images/lights.jpg'; // صورة غلاف افتراضية
  bool _isLoading = true;
  bool _isEditingName = false;
  bool _isEditingBio = false;
  Timer? _refreshTimer;
  List<Map<String, dynamic>> _userList = []; // قائمة المستخدمين
  bool _isLoadinguid = true; // للتحقق من تحميل المستخدمين

  List<Map<String, dynamic>> _userPosts = []; // قائمة المنشورات
  bool _isLoadingPosts = true; // مؤشر التحميل

  // المتحولات الخاصة بالحقلين
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkUserLoggedIn();// التحقق من تسجيل الدخول
    _loadUserData();
    _fetchuid(); // جلب المستخدمين عند تحميل الصفحة
    _fetchUserPosts(); // تحميل المنشورات
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
    _refreshTimer?.cancel();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _fetchUserPosts();
    });
  }

  Future<void> _fetchUserPosts() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      print("لم يتم تسجيل الدخول.");
      return;
    }
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users') // تأكد من اسم المجموعة الصحيح
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          // تصفية المنشورات بناءً على uid
          //.orderBy('times', descending: true)

          .get();

      if (snapshot.docs.isEmpty) {
        print("لا توجد منشورات.");
      }


      List<Map<String, dynamic>> users = snapshot.docs.map((doc) {
        print(doc.id + "hello3");
        // التحقق من وجود الحقل 'timestamp' وعدم كونه null
        Timestamp times = doc['times'] ??
            Timestamp.now(); // استخدام قيمة افتراضية إذا كانت null

        String content = doc['content'] ?? '';
        String location =
            doc['location'] ?? ''; // تأكد من وجود الحقل 'location'
        String rule = doc['rule'] ?? ''; // تأكد من وجود الحقل 'rule'
        String? imageUrl = doc['ImageUrl'];
        DateTime? timestamp; // تأكد من وجود الحقل 'ImageUrl'
        
        return {
          'content': doc['content'] ?? '',
          'times': times,
          'location': location,
          'rule': rule,
          'ImageUrl': imageUrl,
          'timestamp': timestamp ?? '',
          'del': doc['del'],
          'id':doc.id

          // استخدام timestamp بشكل صحيح
        };
      }).toList();

      print('تم جلب البيانات بنجاح!');
      setState(() {
        _userPosts = users;
        _isLoadingPosts = false;
      });
    } catch (e) {
      print("Error fetching posts: $e");
      setState(() {
        _isLoadingPosts = false;
      });
    }
  }



Future<void> _checkUserLoggedIn() async {
  User? currentUser = _auth.currentUser;
  if (currentUser == null) {
    // إذا لم يتم تسجيل الدخول، الانتقال إلى صفحة تسجيل الدخول
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, 'WelcomeScreen');
    });
  }
}









// جلب المستخدمين من Firestore
  Future<void> _fetchuid() async {
    try {
      // جلب البيانات من مجموعة uid
      QuerySnapshot snapshot = await _firestore.collection('uid').get();
      List<Map<String, dynamic>> uid = [];

      // طباعة لتسجيل عدد المستندات
      print("Number of documents fetched: ${snapshot.docs.length}");

      // التحقق من وجود مستندات في Firestore
      if (snapshot.docs.isEmpty) {
        print("No users found in Firestore.");
      }

      for (var doc in snapshot.docs) {
        // طباعة بيانات المستخدم
        print("User Data: ${doc.data()}");

        uid.add({
          'uid': doc.id,
          'name': doc['name'] ?? S.of(context).Namenotavailable,
        });
      }

      // تحديث الحالة بعد جلب البيانات
      setState(() {
        _userList = uid;
        _isLoadinguid = false;
      });
    } catch (e) {
      print("Error fetching uid: $e");
      setState(() {
        _isLoadinguid = false;
      });
    }
  }

  // إضافة المستخدم إلى الأعضاء
  Future<void> _addMember(String userId) async {
    try {
      // إضافة العضو إلى مجموعة الأعضاء (يمكنك تعديل هذه الدالة حسب هيكل قاعدة البيانات لديك)
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await _firestore.collection('members').add({
          'userId': userId,
          'addedBy': currentUser.uid,
          'times': FieldValue.serverTimestamp(),
          'isAdded': true,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).Memberhasbeenaddedsuccessfully)),
        );
        _fetchuid();
      }
    } catch (e) {
      print("Error adding member: $e");
    }
  }

  // تحميل بيانات المستخدم من Firebase
  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot userData =
            await _firestore.collection('uid').doc(user.uid).get();

        if (userData.exists) {
          setState(() {
            _name = userData['name'] ?? S.of(context).Namenotavailable;
            _bio = userData['bio'] ?? S.of(context).NoCV;
            _profileImageUrl = userData['profileImage'] ?? _profileImageUrl;
            _coverImageUrl = userData['coverImage'] ?? _coverImageUrl;
            _nameController.text = _name;
            _bioController.text = _bio;
            _isLoading = false;
          });
        } else {
          // في حالة عدم وجود الوثيقة، يمكن إعداد قيم افتراضية
          await _firestore.collection('uid').doc(user.uid).set({
            'name': 'اسم جديد',
            'bio': 'أضف سيرتك الذاتية هنا',
            'profileImage': _profileImageUrl,
            'coverImage': _coverImageUrl,
          });
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print("Error loading user data: $e");
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

// تحديث الاسم والسيرة الذاتية في Firebase
  Future<void> _updateUserInfo() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        await _firestore.collection('uid').doc(user.uid).update({
          'name': _nameController.text,
          'bio': _bioController.text,
        });

        setState(() {
          _name = _nameController.text;
          _bio = _bioController.text;
          _isEditingName = false;
          _isEditingBio = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تحديث البيانات بنجاح')),
        );
      } catch (e) {
        print("Error updating user info: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حدث خطأ أثناء التحديث')),
        );
      }
    }
  }

  // رفع صورة جديدة للمستخدم
  Future<void> _updateUserImage(String type, String imageUrl) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        String fieldName = type == 'profile' ? 'profileImage' : 'coverImage';

        await _firestore.collection('uid').doc(user.uid).update({
          fieldName: imageUrl,
        });
      } catch (e) {
        print("Error updating image: $e");
      }
    }
  }

  Future<String> _uploadImageToStorage(String path, File image) async {
    try {
      final storageRef = _firebaseStorage.ref().child(path);
      await storageRef.putFile(image);
      String imageUrl = await storageRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print("Error uploading image: $e");
      throw Exception("Failed to upload image");
    }
  }

/*
  // تحديث صورة الملف الشخصي أو صورة الغلاف في Firestore
  Future<void> _updateUserImage(String type, String imageUrl) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('uid').doc(user.uid).update({
          type == 'profile' ? 'profileImage' : 'coverImage': imageUrl,
        });
      } catch (e) {
        print("Error updating image: $e");
      }
    }
  }*/
  Future<void> _pickAndUploadImage(String type) async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      try {
        User? user = _auth.currentUser;
        if (user != null) {
          String imageUrl = await _uploadImageToStorage(
            '${user.uid}/${type == 'profile' ? 'profile_image.jpg' : 'cover_image.jpg'}',
            image,
          );
          await _updateUserImage(type, imageUrl);

          setState(() {
            if (type == 'profile') {
              _profileImageUrl = imageUrl;
            } else {
              _coverImageUrl = imageUrl;
            }
          });
        }
      } catch (e) {
        print("Error picking and uploading image: $e");
      }
    }
  }

@override
Widget build(BuildContext context) {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? user = _auth.currentUser; // للحصول على المستخدم الحالي

  if (user == null) {
    // إذا لم يكن المستخدم مسجلًا، يتم عرض صفحة تسجيل الدخول
    return const WelcomeScreen();
  }

  // إذا كان المستخدم مسجلًا
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
                _buildActionButtons(),
                const SizedBox(height: 20),
                _buildPostSection(),
              ],
            ),
          ),
  );
}


  // بناء الرأس (صورة الغلاف وصورة الملف الشخصي)
  Widget _buildProfileHeader() {
    return Stack(
      children: [
        // صورة الغلاف
        GestureDetector(
          onTap: () =>
              _pickAndUploadImage('cover'), // تغيير صورة الغلاف عند الضغط عليها
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(_coverImageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          top: 120,
          left: 20,
          child: GestureDetector(
            onTap: () => _pickAndUploadImage(
                'profile'), // اختيار صورة جديدة للملف الشخصي
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(_profileImageUrl),
            ),
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
          // تعديل الاسم
          GestureDetector(
            onTap: () {
              setState(() {
                _isEditingName = true;
              });
            },
            child: _isEditingName
                ? TextField(
                    controller: _nameController,
                    decoration:  InputDecoration(labelText: S.of(context).Modifyname),
                    onSubmitted: (_) => _updateUserInfo(),
                  )
                : Text(
                    _name.isEmpty ? S.of(context).Namenotavailable : _name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
          ),
          const SizedBox(height: 10),

          // تعديل السيرة الذاتية
          GestureDetector(
            onTap: () {
              setState(() {
                _isEditingBio = true;
              });
            },
            child: _isEditingBio
                ? TextField(
                    controller: _bioController,
                    decoration:  InputDecoration(
                        labelText:S.of(context).EditCV,
                        ),
                    onSubmitted: (_) => _updateUserInfo(),
                  )
                : Text(
                    _bio.isEmpty ? S.of(context).NoCV : _bio,
                    style: const TextStyle(fontSize: 16),
                  ),
          ),
          const SizedBox(height: 20),

          // إظهار زر حفظ التعديلات فقط إذا كانت هناك حالة تعديل
          (_isEditingName || _isEditingBio)
              ? ElevatedButton(
                  onPressed: _updateUserInfo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 216, 196, 9),
                  ),
                  child: Text(S.of(context).Saveedits)
                )
              : Container(), // إخفاء الزر إذا لم يكن هناك تعديل
        ],
      ),
    );
  }

  // زر "إضافة عضو"
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            // عند الضغط على الزر، تفتح صفحة إضافة العضو
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => _buildAddMemberPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 216, 196, 9),
          ),
          child:  Text(S.of(context).Addamember)
        ),
      ],
    );
  }

  // صفحة إضافة الأعضاء مع التأكد من عرض البيانات بشكل صحيح
  Widget _buildAddMemberPage() {
    return Scaffold(
      appBar: AppBar(title:  Text(S.of(context).MembersList)),
      body: _isLoadinguid
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _userList.length,
              itemBuilder: (context, index) {
                bool isAdded = _userList[index]['isAdded'] ?? false;
                return ListTile(
                  title: Text(_userList[index]['name']),
                  trailing: isAdded
                      ? Icon(
                          Icons.check,
                          color: Colors.blue, // علامة صح زرقاء
                        )
                      : IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            _addMember(_userList[index]['uid']);
                          },
                        ),
                );
              },
            ),
    );
  }

  Widget _buildActionButton(String label) {
    return ElevatedButton(
      onPressed: () {
        // الإجراء عند النقر على الزر
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 216, 196, 9),
      ),
      child: Text(label),
    );
  }

  Widget _buildPost(Map<String, dynamic> document) {
    // استخراج المحتوى والمعلومات الأخرى من المستند/*
    final content = document['content'] ?? S.of(context).Unavailablecontent;
    final times = document['times'] ?? Timestamp.now();
    final rule = document['rule'] ?? '';
    final location = document['location'] ?? '';
    final imageUrl = document['ImageUrl'];
    final timestamp = document['timestamp']?? '';
    // التأكد من أن del قيمة صحيحة وتحويلها إلى int
    final del = document["del"] != null
        ? int.tryParse(document["del"].toString()) ?? 1
        : 0;

    print("del: $document"); // اطبع القيمة للتحققق
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  // تحقق من قيمة del
                  _deletePost(document['id']);
                }
                // عند النقر على الزر، سيتم حذف المنشور
                ),
          ),
            Text(
                  document['content'] ?? S.of(context).Unavailablecontent,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),

                Text(
                  formatDate(document['times']),
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                
                const SizedBox(height: 5),
                Text(
                  document['rule'] ?? '',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 206, 156, 30), // اللون الأزرق للنص
                  ),
                ),
                const SizedBox(height: 5),

                // عرض الموقع إذا كان موجودًا
                if (document['location'] != null && document['location'].isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      // منطق فتح الموقع عند الضغط على الرابط (مثلاً باستخدام URL launcher)
                    },
                    child: Text(
                      document['location'],
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline, // لتحديد النص كرابط
                        fontSize: 15,
                      ),
                    ),
                  )
                else
                  Text(
                    '',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),

                const SizedBox(height: 5),
          // عرض الصورة إذا كانت موجودة
          const SizedBox(height: 5),
           if (document['ImageUrl'] != null) 
  Container(
    width: double.infinity,
    height: MediaQuery.of(context).size.width * 0.75, 
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8), 
      color: Colors.grey[200],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8), 
      child: _isVideo(document['ImageUrl'])
          ? VideoPlayerWidget(videoUrl: document['ImageUrl'])
          : Image.network(
              document['ImageUrl'],
              fit: BoxFit.cover, 
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.broken_image, color: Colors.grey); 
              },
            ),
    ),
  ),
        ],
      ),
    );
  }
bool _isVideo(String url) {
  final Uri uri = Uri.parse(url);
  return uri.path.endsWith('.mp4');
}
  String formatDate(dynamic timestamp) {
    try {
      // تأكد من أن timestamp هو من نوع Timestamp
      if (timestamp is Timestamp) {
        final DateTime dateTime =
            timestamp.toDate(); // تحويل الـ Timestamp إلى DateTime
        final DateFormat formatter = DateFormat('dd/MM/yyyy    (hh:mm a)');
        return formatter.format(dateTime); // إعادة تنسيق التاريخ
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

  Future<void> _deletePost(String id) async {
     
      try {
        // حذف المنشور من قاعدة البيانات
        await _firestore
            .collection('users')
            .doc(id)
            .delete(); // تحويل del إلى String لتحديد الـ doc
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).Thepostwasdeletedsuccessfully)),
        );
      } catch (e) {
        print("Error deleting post: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء الحذف')),
        );
      }
  
  }

  Widget _buildPostSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
           S.of(context).YourPosts,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _isLoadingPosts
              ? const Center(child: CircularProgressIndicator())
              : _userPosts.isEmpty
                  ?  Text(S.of(context).Noposts)
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _userPosts.length,
                      itemBuilder: (context, index) {
                        final post = _userPosts[index];
                        return _buildPost(
                            post); // تم تعديل السطر لاستخدام الكود المعدل
                      },
                    ),
        ],
      ),
    );
  }
}
