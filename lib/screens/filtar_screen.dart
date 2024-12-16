 /*Widget buildPosts() {
    final posts = _filteredPosts.isNotEmpty ? _filteredPosts : _filteredPosts;

    if (posts.isEmpty) {
      return const Center(child: Text('لا توجد منشورات حالياً.'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .orderBy('times', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.amber,
          ));
        }
        final posts = snapshot.data!.docs;
        print(" object$posts");
        if (posts.isEmpty) {
          return const Center(child: Text('لا توجد منشورات حالياً.'));
        }
        return ListView(
          children: _filteredPosts.map((document) {
            return ListTile(
              title: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // محاذاة النص والصورة من البداية
                children: [
                  
                  // النص (content)
                  Text(
                    document['content'] ?? 'محتوى غير متوفر',
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5), // مسافة صغيرة بين TEXT والرابط
                  // عرض التاريخ والوقت
                  Text(
                    formatDate(
                        document['timestamp']), // استدعاء دالة تنسيق التاريخ
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
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
Text(
  document['rule'] ??'',
  style: const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 206, 156, 30), // اللون الأزرق للنص
  ),
),

            
                  // الصورة
                  SizedBox(
                    width: double.infinity, // عرض كامل للصورة
                    height: 200, // تحديد ارتفاع الصورة
                    child: Image.network(
                      "${document['ImageUrl']}",
                      fit: BoxFit.contain, // لتغطية المساحة بشكل مناسب
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.broken_image,
                            color: const Color.fromARGB(255, 58, 53,
                                53)); // عند وجود خطأ في تحميل الصورة
                      },
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

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
      }*/
