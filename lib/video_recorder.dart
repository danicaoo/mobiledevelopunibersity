import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoRecorderPage extends StatefulWidget {
  const VideoRecorderPage({super.key});

  @override
  State<VideoRecorderPage> createState() => _VideoRecorderPageState();
}

class _VideoRecorderPageState extends State<VideoRecorderPage> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  final ImagePicker _picker = ImagePicker();

  Future<void> _recordVideo() async {
    final XFile? video = await _picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(seconds: 30),
    );

    if (video != null) {
      _initializeVideoPlayer(File(video.path));
    }
  }

  Future<void> _pickVideoFromGallery() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      _initializeVideoPlayer(File(video.path));
    }
  }

  void _initializeVideoPlayer(File videoFile) {
    _videoController = VideoPlayerController.file(videoFile)
      ..initialize().then((_) {
        setState(() {});
        _chewieController = ChewieController(
          videoPlayerController: _videoController!,
          autoPlay: true,
          looping: false,
        );
        setState(() {});
      });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Запись видео')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_chewieController != null && _videoController != null && _videoController!.value.isInitialized)
              Expanded(
                child: Chewie(controller: _chewieController!),
              )
            else
              const Expanded(
                child: Center(
                  child: Text('Видео не записано'),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: _recordVideo,
                    icon: const Icon(Icons.videocam),
                    label: const Text('Записать'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _pickVideoFromGallery,
                    icon: const Icon(Icons.video_library),
                    label: const Text('Из галереи'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}