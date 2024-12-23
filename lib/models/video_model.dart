class VideoModel {
  final String name;
  final String url;
  final String? localPath;

  VideoModel({
    required this.name,
    required this.url,
    this.localPath,
  });
}
