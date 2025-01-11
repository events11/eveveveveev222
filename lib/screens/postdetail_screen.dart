import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/l10n.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

class PostDetailPage extends StatefulWidget {
  final Map<String, dynamic> post;

  const PostDetailPage({Key? key, required this.post}) : super(key: key);
  static const String screenRoute = 'postd_screen';

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    // إذا كان هناك رابط للفيديو في المنشور، قم بتحميله
    if (_isVideo(widget.post['ImageUrl'])) {
      _videoController = VideoPlayerController.network(widget.post['ImageUrl'])
        ..initialize().then((_) {
          setState(() {}); // تحديث الواجهة عندما يتم تحميل الفيديو
        });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _videoController?.dispose(); // تأكد من التخلص من الموارد بعد استخدام الفيديو
  }

  bool _isVideo(String? url) {
    if (url == null) return false;
    final Uri uri = Uri.parse(url);
    return uri.path.endsWith('.mp4');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).PostDetails),
        backgroundColor: const Color.fromARGB(255, 148, 21, 133),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Text(
              widget.post['userName'] ?? 'مستخدم غير معروف',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
           
            Text(widget.post['content'] ?? 'محتوى غير متوفر'),
            const SizedBox(height: 10),
          
            Text(formatDate(widget.post['timestamp'])),
            const SizedBox(height: 10),
            
            Text(widget.post['rule'] ?? ''),
            const SizedBox(height: 10),
            
            if (widget.post['ImageUrl'] != null && !_isVideo(widget.post['ImageUrl']))
              Image.network(
                widget.post['ImageUrl'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.broken_image, color: Colors.grey);
                },
              ),
           
            if (_isVideo(widget.post['ImageUrl']))
              _videoController != null && _videoController!.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    )
                  : const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  // د تنسيق التاريخ
  String formatDate(dynamic timestamp) {
    try {
      if (timestamp is Timestamp) {
        final DateTime dateTime = timestamp.toDate();
        final DateFormat formatter = DateFormat('dd/MM/yyyy    (hh:mm a)');
        return formatter.format(dateTime);
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }
}
