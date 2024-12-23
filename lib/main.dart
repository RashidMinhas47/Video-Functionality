import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(VideoDownloadApp());
}

class VideoDownloadApp extends StatelessWidget {
  const VideoDownloadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Download Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: VideoDownloadScreen(),
    );
  }
}

class VideoDownloadScreen extends StatefulWidget {
  @override
  _VideoDownloadScreenState createState() => _VideoDownloadScreenState();
}

class _VideoDownloadScreenState extends State<VideoDownloadScreen> {
  String videoUrl =
  "https://drive.google.com/uc?export=download&id=1j-WbLJQCKki4nRiIXKDkBzctxVqP9Y-V";
      // "https://drive.google.com/file/d/1j-WbLJQCKki4nRiIXKDkBzctxVqP9Y-V/view?usp=sharing"; // Replace with your Google Drive file ID
  String? downloadedFilePath;
  bool isDownloading = false;
  int videoLength = 0;
  int totalLength = 0;
  late VideoPlayerController _controller;
  bool isVideoReady = false;

  Future<void> downloadVideo() async {
    setState(() {
      isDownloading = true;
    });

    try {
      // Get the app's cache directory
      final directory = await getTemporaryDirectory();
      String filePath = '${directory.path}/video.mp4';

      // Download the file using Dio
      Dio dio = Dio();
      await dio.download(videoUrl, filePath, onReceiveProgress: (received, total) {
        if (total != -1) {
         setState(() {
           videoLength = received;
           totalLength = total;
           print("Downloading: ${(received / total * 100).toStringAsFixed(0)}%");

         });
        }
      });

      setState(() {
        downloadedFilePath = filePath;
        isDownloading = false;
        isVideoReady = true;
      });

      // Initialize the video player
      _controller = VideoPlayerController.file(File(filePath))
        ..initialize().then((_) {
          setState(() {});
        });
    } catch (e) {
      setState(() {
        isDownloading = false;
      });
      print("Error downloading video: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Download Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isDownloading) ...[
              CircularProgressIndicator(),
              Text(
                totalLength > 0
                    ? "Downloading: ${(videoLength / totalLength * 100).toStringAsFixed(1)}%"
                    : "Downloading: 0.0%",
                style: const TextStyle(fontSize: 16),
              ),SizedBox(height: 20),
              Text('Downloading video...'),
            ] else if (isVideoReady) ...[
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                  });
                },
                child: Text(_controller.value.isPlaying ? 'Pause' : 'Play'),
              ),
            ] else ...[
              ElevatedButton(
                onPressed: downloadVideo,
                child: Text('Download Video'),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'views/video_view.dart';
//
// void main() {
//   runApp(const ProviderScope(child: MyApp()));
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Video Downloader',
//       theme: ThemeData(
//         textTheme: GoogleFonts.poppinsTextTheme(),
//       ),
//       home: const VideoView(),
//     );
//   }
// }
