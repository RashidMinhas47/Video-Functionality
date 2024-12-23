import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../models/video_model.dart';

class VideoViewModel extends StateNotifier<AsyncValue<VideoModel?>> {
  VideoViewModel() : super(const AsyncValue.data(null));

  Future<void> downloadVideo(String url, String name) async {
    try {
      state = const AsyncValue.loading();

      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/$name';

      final dio = Dio();
      await dio.download(url, filePath);

      final downloadedVideo = VideoModel(name: name, url: url, localPath: filePath);
      state = AsyncValue.data(downloadedVideo);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final videoViewModelProvider =
StateNotifierProvider<VideoViewModel, AsyncValue<VideoModel?>>(
        (ref) => VideoViewModel());
