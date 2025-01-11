import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: () {
        // عند الضغط على الفيديو، سيتم الانتقال إلى شاشة جديدة
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullScreenVideoPlayer(
              videoUrl: widget.videoUrl,
            ),
          ),
        );
      },
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class FullScreenVideoPlayer extends StatelessWidget {
  final String videoUrl;

  FullScreenVideoPlayer({required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    VideoPlayerController _controller = VideoPlayerController.network(videoUrl);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: FutureBuilder(
          future: _controller.initialize(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              _controller.play();
              return GestureDetector(
                onTap: () {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                },
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
 




/*import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'pagewa_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'post_screen.dart';

pickVideo() async {
  final picker = ImagePicker();
  XFile? videoFile;
  try {
    videoFile = await picker.pickVideo(source: ImageSource.gallery);

    return videoFile!.path;
  } catch (e) {
    print('error video:$e');
  }
}
/*
  void _pickVideo() async {
    _videoURL = pickVideo();
    _
  }

  void _initializeVideoplayer() {
    _controller = VideoPlayerController.file(File(_videoURL!))
      ..initialize().then((_) {
        setState(() {});

        _controller!.play();
      });
  }

  Widget _VideoPreviewWidget() {
    if (_controller != null) {
      return AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: VideoPlayer(_controller!),
      );
    }
    else{
      return const CircularProgressIndicator();
    }
  }
String? _videoURL;
  VideoPlayerController? _controller;
  DateTime? _selectedDateTime; // لتخزين التاريخ والوقت المختار
  // دالة لاختيار التاريخ والوقت
  @override
  bool operator ==(Object other) {
    // TODO: implement ==
    void dispose() {
      _controller?.dispose();
    }

    return super == other;
  }*/*/