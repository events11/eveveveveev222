import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/generated/l10n.dart';
import 'package:flutter_application_1/screens/postdetail_screen.dart';
import 'dart:async';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static const String screenRoute = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final TextEditingController _messageController = TextEditingController();
Timer? _timer;
  String? selectedPostId;
  String? selectedReceiverId; 
  List<ChatUser> userList = [];
  late User loggedInUser;
  List postsList = [];
  final isReceiver = '';
  @override
  void initState() {
    super.initState();
    _checkUserLoggedIn();
    getCurrentUser();
    fetchUsers();
    _fetchPosts(); 
  _startAutoRefresh(); 
  }
@override
void dispose() {
  _timer?.cancel(); 
  super.dispose();
}
  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }


void _startAutoRefresh() {
  _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
    _fetchPosts(); 
    fetchUsers(); 
  });
}



  Future<void> _checkUserLoggedIn() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
     
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, 'WelcomeScreen');
      });
    }
  }

  Future<void> _fetchPosts() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      print("لم يتم تسجيل الدخول.");
      return;
    }
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users') 
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (snapshot.docs.isEmpty) {
        print("لا توجد منشورات.");
      }
      print("date khaled");
      postsList = snapshot.docs.map((doc) {
        print(doc.id + "hello2");
        print(doc['content'] + "hello2");
        return {
          'content': doc['content'] ?? '',
          'id': doc.id,
          // 'times': times,
          //  'location': location,
          'title': doc["title"]
        };
      }).toList();
      setState(() {});
    } catch (e) {
      print("Error fetching posts: $e");
    }
  }

  /*Future<void> fetchPosts() async {
    final postsSnapshot = await _firestore.collection('users')
        .where('userId', isEqualTo: loggedInUser.uid) // فقط منشورات المستخدم الحالي
        .get();

    setState(() {
      postsList = postsSnapshot.docs.map((doc) {
        return Post(
          id: doc.id,
          content: doc['content'], title: '',
         // title: doc['title'],
        );
      }).toList();
      print('Posts loaded: $postsList');  // إ
    });
  }
*/
  void fetchUsers() async {
    final usersSnapshot =
        await _firestore.collection('uid').get(); 
    setState(() {
      userList = usersSnapshot.docs.map((doc) {
        return ChatUser(
          id: doc.id, 
          name: doc['name'],
        );
      }).toList();
    });
  }

  Future<String> getUsername(String userId) async {
    try {
      final userDoc = await _firestore.collection('uid').doc(userId).get();
      return userDoc.data()?['name'] ?? 'Unknown User';
    } catch (e) {
      print('Error fetching username: $e');
      return 'Unknown User';
    }
  }

  void sendMessage(String receiverId) async {
    if (_messageController.text.isNotEmpty) {
      final senderName = await getUsername(loggedInUser.uid);

      _firestore.collection('messages').add({
        'text': _messageController.text,
        'sender': senderName,
        'senderId': loggedInUser.uid,
        'receiverId': receiverId,
        'timestamp': FieldValue.serverTimestamp(),
        'postid': selectedPostId ?? '',
      });
      _messageController.clear();
    }
  }

  void sendPostInvitation(String receiverId) async {
    if (selectedPostId != null) {
      final senderName = await getUsername(loggedInUser.uid);
      final selectedPost =
          postsList.firstWhere((post) => post['id'] == selectedPostId);

      final postLink =
          'https://yourapp.com/posts/${selectedPost['id']}'; // الرابط إلى المنشور

      _firestore.collection('messages').add({
        'text':
            'دعوة لقراءة منشوري: ${selectedPost['title']}. يمكنك قراءته هنا: $postLink',
        'sender': senderName,
        'senderId': loggedInUser.uid,
        'receiverId': receiverId,
        'timestamp': FieldValue.serverTimestamp(),
        'postid': selectedPost['id'],
      });

      _messageController.clear();
    }
  }

  void sendMessageToAllUsers() async {
    if (_messageController.text.isNotEmpty) {
      final senderName = await getUsername(loggedInUser.uid);

      WriteBatch batch = _firestore.batch();

      for (var user in userList) {
        final messageRef = _firestore.collection('messages').doc();
        batch.set(messageRef, {
          'text': _messageController.text,
          'sender': senderName,
          'senderId': loggedInUser.uid,
          'receiverId': user.id,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 253, 251),
        title: Row(
          children: [
            Image.asset('images/event1.webp', width: 120, height: 50),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            selectedReceiverId == null
                ? SizedBox.shrink()
                : Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('messages')
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.yellow,
                            ),
                          );
                        }
                        final messages = snapshot.data!.docs;
                        List<MessageBubble> messageWidgets = [];
                        for (var message in messages) {
                          print(message['senderId'] + 'hello');
                          print(message['receiverId'] + 'hello');
                          print(selectedReceiverId.toString() + 'hello');
                          print(loggedInUser.uid + 'hello');
                          if ((message['senderId'] == loggedInUser.uid &&
                                  message['receiverId'] ==
                                      selectedReceiverId) ||
                              (message['receiverId'] == loggedInUser.uid &&
                                  message['senderId'] == selectedReceiverId)) {
                            final messageText = message['text'];
                            final messageSender = message['sender'];

                            final messageWidget = MessageBubble(
                              sender: messageSender,
                              text: messageText,
                              isMe: loggedInUser.uid == message['senderId'],
                              link: message['postid'],
                            );
                            messageWidgets.add(messageWidget);
                          } else {
                            continue;
                          }
                        }
                        return ListView(
                          reverse: true,
                          children: messageWidgets,
                        );
                      },
                    ),
                  ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color.fromARGB(255, 230, 229, 228),
                    width: 2,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: DropdownButton<String>(
                      hint:  Text(S.of(context).SelectReceiver),////////////////////
                      value: selectedReceiverId,
                      onChanged: (newValue) {
                        setState(() {
                          selectedReceiverId = newValue;
                        });
                      },
                      items: userList
                          .map<DropdownMenuItem<String>>((ChatUser uid) {
                        return DropdownMenuItem<String>(
                          value: uid.id,
                          child: Text(uid.name),
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: DropdownButton<String>(
                        hint:  Text(S.of(context).SelectPost),/////////////////////
                        value: selectedPostId,
                        onChanged: (newValue) {
                          setState(() {
                            selectedPostId = newValue;
                          });
                          print(
                              'Selected Post ID: $selectedPostId'); // تحقق من القيمة المختارة
                        },
                        items: postsList.map<DropdownMenuItem<String>>((post) {
                          return DropdownMenuItem<String>(
                            value: post["id"],
                            child: Text(post["title"]),
                          );
                        }).toList(),
                      )),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration:  InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            hintText: S.of(context).Writeyourmessagehere,////////////////////////
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: selectedReceiverId != null
                            ? () => sendMessage(selectedReceiverId!)
                            : null,
                        child: Text(
                          S.of(context).Send,/////////////////////////////
                          style: TextStyle(
                            color: selectedReceiverId != null
                                ? Colors.blue[800]
                                : Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: sendMessageToAllUsers,
                    child: Text(
                      S.of(context).SendtoAll ,///////////////////////////////////
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed:
                        selectedReceiverId != null && selectedPostId != null
                            ? () => sendPostInvitation(selectedReceiverId!)
                            : null,
                    child: Text(
                      S.of(context).SendInvitation,
                      style: TextStyle(
                        color: (selectedReceiverId != null &&
                                selectedPostId != null)
                            ? Colors.blue[800]
                            : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Post {
  final String id;
  final String content;
  final String title;

  Post({required this.id, required this.content, required this.title});
}

class ChatUser {
  final String id;
  final String name;

  ChatUser({required this.id, required this.name});
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;
  final String link;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  MessageBubble({
    required this.sender,
    required this.text,
    required this.isMe,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: link.isEmpty
            ? null
            : () async {
                final snapshot = await _firestore
                    .collection('users') 
                    .doc(link)

                    // تصفية المنشورات بناءً على uid
                    //.orderBy('times', descending: true)

                    .get();
                //print('${snapshot.docs[0].data()}hello4');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailPage(
                        post: snapshot.data() as Map<String, dynamic>),
                  ),
                );
              },
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              sender,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            Material(
              borderRadius: isMe
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    )
                  : const BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
              elevation: 5,
              color: isMe ? Colors.yellow[900] : Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  text,
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black54,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
