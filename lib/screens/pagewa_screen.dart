import 'dart:ffi';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/l10n.dart';
import 'package:flutter_application_1/screens/ProfilePage_screen.dart';
import 'package:flutter_application_1/screens/messegePage_screen.dart';
import 'package:flutter_application_1/screens/postdetail_screen.dart';
import 'package:flutter_application_1/screens/welcome_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'language_screen.dart';
import 'post_screen.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'Video_screen.dart';
import 'profile2_screen.dart';

class PagewaScreen extends StatefulWidget {
  static const String screenRoute = 'pagewa_screen';
  const PagewaScreen({super.key});

  @override
  State<PagewaScreen> createState() => _PagewaScreenState();
}

class _PagewaScreenState extends State<PagewaScreen> {
  Timer? _refreshTimer; 
  int _selectedIndex = 0;
  final TextEditingController _postController = TextEditingController();
  List<Map<String, dynamic>> _filteredPosts = [];
  List<Map<String, dynamic>> _allPosts = [];
  int? _currentFilter;
  String? _profileImageUrl;
  void initState() {
    super.initState();
    _loadAllPosts(); 
    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _loadAllPosts();
      _loadProfileImage();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel(); 
    super.dispose();
  }

  Future<String> _getUsername(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('uid') 
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return userDoc['name'] ?? 'مستخدم غير معروف'; 
      } else {
        return 'مستخدم غير معروف';
      }
    } catch (e) {
      print('Error fetching username: $e');
      return 'مستخدم غير معروف';
    }
  }

  Future<void> _loadProfileImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('uid')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            _profileImageUrl = userDoc['profileImage'];
          });
        }
      } catch (e) {
        print("Error loading profile image: $e");
      }
    }
  }

  Future<void> _loadAllPosts() async {
    try {
      // جلب جميع المنشورات من Firebase Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .orderBy('times', descending: true)
          .get();

      setState(() {
        
        _allPosts = querySnapshot.docs.map((doc) {
          final data = doc.data();
          
          if (data is Map<String, dynamic>) {
            return data;
          } else {
            return <String, dynamic>{};
          }
        }).toList();

        
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
        ChatScreen;
      }
    });
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
                          backgroundImage: _profileImageUrl != null
                              ? NetworkImage(_profileImageUrl!)
                              : AssetImage('assets/default_profile.png')
                                  as ImageProvider, 
                          radius: 22,
                        ),
                        onPressed: () {
                         
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(child: buildPosts()),
            ],
          ),
          ChatScreen(),
          //Container(), // فارغ لأنه يتم عرض الإشعارات في نافذة منبثقة
          ProfilePage(),
          //الفحة الاخيرة
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
            label: S.of(context).messagebox,
            icon: const Icon(Icons.message),
          ),
          BottomNavigationBarItem(
            label: S.of(context).person,
            icon: const Icon(Icons.person),
          ),
        ],
      ),
    );
  }

  
  void _filterByCategory(int category, BuildContext context) async {
    Navigator.pop(context); 

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
          
          _filteredPosts = querySnapshot.docs.map((doc) {
            final data = doc.data();
          
            if (data is Map<String, dynamic>) {
              return data; 
            } else {
              return <String,
                  dynamic>{}; 
            }
          }).toList();
          _currentFilter = category; 
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


  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(S.of(context).PersonalEvents), //////////////////////
              onTap: () => _filterByCategory(1, context),
            ),
            ListTile(
              title: Text(S.of(context).PublicEvents), //////////////////////
              onTap: () => _filterByCategory(2, context),
            ),
            ListTile(
              title: Text(
                  S.of(context).OrganizationalEvents), //////////////////////
              onTap: () => _filterByCategory(3, context),
            ),
            ListTile(
              title:
                  Text(S.of(context).RecreationalEvents), //////////////////////
              onTap: () => _filterByCategory(4, context),
            ),
            ListTile(
              title: Text(S.of(context).AllEvents), //////////////////////
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
    final posts = _filteredPosts; 

    if (posts.isEmpty) {
      return Center(
        child: Text(S.of(context).Noposts), //////////////////////
      );
    }

    return ListView(
      children: posts.map((document) {
        String userId =
            document['userId']; 

        return FutureBuilder<String>(
          future: _getUsername(userId), 
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            String username = snapshot.data ?? 'مستخدم غير معروف';
            return GestureDetector(
              onTap: () {
               
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailPage(post: document),
                  ),
                );
              },
              child: ListTile(
                  title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage2(
                                  userId:
                                      userId), 
                            ),
                          );
                        },
                        child: Text(
                          username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color.fromARGB(255, 34, 190,
                                86), 
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  /*  // عرض اسم المستخدم قبل المحتوى
                Text(
                  username, 
                  style: const TextStyle(
                    fontSize: 14, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.blue, 
                ),
                const SizedBox(height: 5),
                */
                  Text(
                    document['content'] ?? 'محتوى غير متوفر',
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),

                  Text(
                    formatDate(document['timestamp']),
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),

                  const SizedBox(height: 5),
                  Text(
                    document['rule'] ?? '',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(
                          255, 206, 156, 30), 
                    ),
                  ),
                  const SizedBox(height: 5),

                  // عرض الموقع إذا كان موجودًا
                  if (document['location'] != null &&
                      document['location'].isNotEmpty)
                    GestureDetector(
                      onTap: () {
                       
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
                                  return Icon(Icons.broken_image,
                                      color: Colors.grey);
                                },
                              ),
                      ),
                    ),
                ],
              )),
            );
          },
        );
      }).toList(),
    );
  }

  bool _isVideo(String url) {
    final Uri uri = Uri.parse(url);
    return uri.path.endsWith('.mp4');
  }

  // د تنسيق التاريخ
  String formatDate(dynamic timestamp) {
    try {
     
      if (timestamp is Timestamp) {
        final DateTime dateTime =
            timestamp.toDate(); // تحويل الـ Timestamp إلى DateTime
        final DateFormat formatter = DateFormat('dd/MM/yyyy    (hh:mm a)');
        return formatter.format(dateTime); 
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

 
  Future<String> uploadMedia(File file) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}');
    UploadTask uploadTask = storageReference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }
}
