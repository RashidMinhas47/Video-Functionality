// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:video_player/video_player.dart';
// import '../viewmodels/video_viewmodel.dart';
//
// class VideoView extends ConsumerStatefulWidget {
//   const VideoView({super.key});
//
//   @override
//   ConsumerState<VideoView> createState() => _VideoViewState();
// }
//
// class _VideoViewState extends ConsumerState<VideoView> {
//   late VideoPlayerController _videoController;
//
//   @override
//   void dispose() {
//     _videoController.dispose();
//     super.dispose();
//   }
//
//   void initializeVideo(String path) {
//     // Dispose of any existing controller before initializing a new one
//     _videoController.dispose();
//     _videoController = VideoPlayerController.networkUrl(Uri.parse(uri))
//       ..initialize().then((_) {
//         setState(() {});
//       }).catchError((error) {
//         debugPrint("Error initializing video: $error");
//       });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final videoState = ref.watch(videoViewModelProvider);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Video Downloader'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (videoState.isLoading) ...[
//               const CircularProgressIndicator(),
//               const SizedBox(height: 16),
//               const Text("Downloading video..."),
//             ],
//             if (videoState.hasValue && videoState.value!.localPath != null) ...[
//               Text(
//                 "Downloaded: ${videoState.value!.name}",
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//               ),
//               const SizedBox(height: 16),
//               AspectRatio(
//                 aspectRatio: 16 / 9,
//                 child: _videoController != null &&
//                     _videoController!.value.isInitialized
//                     ? VideoPlayer(_videoController!)
//                     : const Center(child: Text("Initializing Video...")),
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_videoController != null) {
//                     if (_videoController!.value.isPlaying) {
//                       _videoController!.pause();
//                     } else {
//                       _videoController!.play();
//                     }
//                     setState(() {});
//                   }
//                 },
//                 child: Text(
//                   _videoController != null && _videoController!.value.isPlaying
//                       ? "Pause"
//                       : "Play",
//                 ),
//               ),
//             ] else if (videoState.hasError) ...[
//               const Text(
//                 "An error occurred while downloading the video.",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.red, fontSize: 16),
//               ),
//             ] else ...[
//               const Text(
//                 "Click the button below to download the video.",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 16),
//               ),
//             ],
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 const url =
//                     "https://drive.google.com/uc?export=download&id=1j-WbLJQCKki4nRiIXKDkBzctxVqP9Y-V";
//                 const name = "test_video.mp4";
//
//                 ref
//                     .read(videoViewModelProvider.notifier)
//                     .downloadVideo(url, name)
//                     .then((_) {
//                   final localPath =
//                       ref.read(videoViewModelProvider).value?.localPath;
//                   if (localPath != null) {
//                     initializeVideo(localPath);
//                   } else {
//                     debugPrint("Failed to retrieve the local path.");
//                   }
//                 }).catchError((error) {
//                   debugPrint("Error downloading video: $error");
//                 });
//               },
//               child: const Text("Download Video"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
