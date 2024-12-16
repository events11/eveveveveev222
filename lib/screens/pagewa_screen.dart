import 'dart:ffi';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/l10n.dart';
import 'package:flutter_application_1/screens/ProfilePage_screen.dart';
import 'package:flutter_application_1/screens/welcome_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'language_screen.dart';
import 'post_screen.dart';
import 'package:intl/intl.dart';

class PagewaScreen extends StatefulWidget {
  static const String screenRoute = 'pagewa_screen';
  const PagewaScreen({super.key});

  @override
  State<PagewaScreen> createState() => _PagewaScreenState();
}

class _PagewaScreenState extends State<PagewaScreen> {
  Timer? _refreshTimer; // لتخزين المؤقت
  int _selectedIndex = 0;
  final TextEditingController _postController = TextEditingController();
  List<Map<String, dynamic>> _filteredPosts = [];
  List<Map<String, dynamic>> _allPosts = [];
  int? _currentFilter;
@override
void initState() {
  super.initState();
  _loadAllPosts(); // استدعاء دالة تحميل جميع المنشورات
 // تشغيل التحديث التلقائي كل 10 ثوانٍ
    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _loadAllPosts();
    });
}
 @override
  void dispose() {
    _refreshTimer?.cancel(); // إيقاف المؤقت عند التخلص من الصفحة
    super.dispose();
  }
Future<void> _loadAllPosts() async {
  try {
    // جلب جميع المنشورات من Firebase Firestore
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('times', descending: true)
        .get();

    setState(() {
      // تحويل المستندات إلى قائمة من الخرائط
      _allPosts = querySnapshot.docs.map((doc) {
        final data = doc.data();
        // التأكد من أن البيانات هي من النوع الصحيح
        if (data is Map<String, dynamic>) {
          return data;
        } else {
          return <String, dynamic>{};
        }
      }).toList();

      // عند بدء التشغيل، نعرض جميع المنشورات بدون فلترة
        if (_currentFilter == null) {
          _filteredPosts = List.from(_allPosts);
        }
      });
    } catch (e) {
      print("Error loading posts: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء تحميل المنشورات: $e')),
      );
  }
}

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 2) {
        _showNotificationsDialog();
      }
    });
  }




















  void _showNotificationsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.notifications, color: Colors.blue),
              SizedBox(width: 8),
              Text(S.of(context).notifications)
            ],
          ),
          content: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('notifications')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final notifications = snapshot.data!.docs;
              if (notifications.isEmpty) {
                return Text(S.of(context).Noewnotifications);
              }

              return SizedBox(
                height: 20,
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: notifications.map((doc) {
                    final notification = doc.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(notification['message']),
                      subtitle:
                          Text('في ${notification['timestamp'].toDate()}'),
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إغلاق'),
            ),
          ],
        );
      },
    );
  }

  File? _mediaFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).homePage),
        backgroundColor: const Color.fromARGB(255, 148, 21, 133),
        actions: [
          IconButton(
            iconSize: 35,
            color: Colors.black,
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context),
          ),
          IconButton(
            iconSize: 35,
            color: Colors.black,
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                WelcomeScreen.screenRoute,
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          LanguageScreen(),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: S.of(context).Writeyourpost,
                            border: InputBorder.none,
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                                context, CreatePostPage.screenRoute);
                          },
                        ),
                      ),
                      IconButton(
                        icon: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://firebasestorage.googleapis.com/v0/b/event999-83c8c.firebasestorage.app/o/OIP.jpg?alt=media&token=f911e404-b4ba-45f0-a077-b3bb7a721b87'), // استبدل هذا بالرابط الفعلي للصورة
                          radius: 22, // لتحديد حجم الصورة
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(child: buildPosts()),
            ],
          ),
          Container(), // فارغ لأنه يتم عرض الإشعارات في نافذة منبثقة
          ProfilePage(), //الفحة الاخيرة
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        unselectedItemColor: const Color.fromARGB(255, 148, 21, 133),
        selectedItemColor: const Color.fromARGB(255, 58, 103, 65),
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            label: S.of(context).language,
            icon: const Icon(Icons.language),
          ),
          BottomNavigationBarItem(
            label: S.of(context).home,
            icon: const Icon(Icons.house),
          ),
          BottomNavigationBarItem(
            label: S.of(context).notifications,
            icon: const Icon(Icons.notifications),
          ),
          BottomNavigationBarItem(
            label: S.of(context).person,
            icon: const Icon(Icons.person),
          ),
        ],
      ),
    );
  }

  // فلتر المنشورات بناءً على التصنيف المحدد
  // تصحيح الفلترة بناءً على الفئات
  void _filterByCategory(int category, BuildContext context) async {
    Navigator.pop(context); // إغلاق ورقة السحب

    try {
      Query query;
      switch (category) {
        case 1:
        case 2:
        case 3:
        case 4:
          query = FirebaseFirestore.instance
              .collection('users')
              .where('category', isEqualTo: category);

          break;
        default:
          query = FirebaseFirestore.instance
              .collection('users')
              .orderBy('times', descending: true);
          break;
      }

      // تنفيذ الاستعلام وجلب البيانات
      QuerySnapshot querySnapshot = await query.get();

      // التعامل مع النتائج
      setState(() {
        if (querySnapshot.docs.isNotEmpty) {
          // تحويل المستندات إلى قائمة من الخرائط بشكل صحيح
          _filteredPosts = querySnapshot.docs.map((doc) {
            final data = doc.data();
            // التأكد من أن البيانات هي من النوع الصحيح
            if (data is Map<String, dynamic>) {
              return data; // لا حاجة للتحويل لأن البيانات بالفعل من النوع المطلوب
            } else {
              return <String,
                  dynamic>{}; // إرجاع خريطة فارغة في حالة عدم التوافق
            }
          }).toList();
          _currentFilter = category; // حفظ التصنيف الحالي
        } else {
          _filteredPosts = [];
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('لا توجد منشورات لهذا التصنيف')),
          );
        }
      });
    } catch (e) {
      print("Error filtering posts: $e");
      setState(() {
        _filteredPosts = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء تحميل المنشورات: $e')),
      );
    }
  }

// عرض ورقة الفلتر مع التصنيفات الصحيحة
  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Personal Events'),
              onTap: () => _filterByCategory(1, context), // تصحيح القيمة هنا
            ),
            ListTile(
              title: const Text('Public Events'),
              onTap: () => _filterByCategory(2, context),
            ),
            ListTile(
              title: const Text('Organizational Events'),
              onTap: () => _filterByCategory(3, context),
            ),
            ListTile(
              title: const Text('Recreational Events'),
              onTap: () => _filterByCategory(4, context),
            ),
            ListTile(
              title: const Text('All Events'),
              onTap: () => _filterByCategory(
                  5, context), // التصنيف 5 لعرض جميع المنشورات
            ),
          ],
        );
      },
    );
  }

  // بناء واجهة المنشورات
 Widget buildPosts() {
  final posts = _filteredPosts; // استخدام المنشورات المفلترة أو جميعها

  if (posts.isEmpty) {
    return const Center(child: Text('لا توجد منشورات حالياً.'));
  }

  return ListView(
    children: posts.map((document) {
      return ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              document['content'] ?? 'محتوى غير متوفر',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),

            Text(
              formatDate(document['timestamp']),
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),

          const SizedBox(height: 5),
Text(
  document['rule'] ??'',
  style: const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 206, 156, 30), // اللون الأزرق للنص
  ),
),

const SizedBox(height: 5),


if (document['location'] != null &&
                      document['location'].isNotEmpty) ...[
                    GestureDetector(
                      onTap: () {
                        // منطق فتح الموقع عند الضغط على الرابط (مثلاً باستخدام URL launcher)
                      },
                      child: Text(
                        document['location'],
                        style: TextStyle(
                          color: Colors.blue,
                          decoration:
                              TextDecoration.underline, // لتحديد النص كرابط
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ] else ...[
                    // عرض نص بديل في حال لم يكن الموقع متوفرًا
                    Text(
                  '',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                  





            const SizedBox(height: 5),
            if (document['ImageUrl'] != null)
              SizedBox(
                width: double.infinity,
                height: 200,
                child: Image.network(
                  document['ImageUrl'],
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.broken_image, color: Colors.grey);
                  },
                ),
              ),
          ],
        ),
      );
    }).toList(),
  );
}

  // دالة تنسيق التاريخ
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

  // تحميل صورة/فيديو إلى Firebase Storage
  Future<String> uploadMedia(File file) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}');
    UploadTask uploadTask = storageReference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }
}
