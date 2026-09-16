import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../models/lecture.dart';

/// Full-screen playback for a single lecture's video.
class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key, required this.lecture});

  final Lecture lecture;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final VideoPlayerController _videoController;
  ChewieController? _chewieController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.lecture.videoUrl),
    );
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _videoController.initialize();
      if (!mounted) return;
      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: _videoController,
          autoPlay: true,
          looping: false,
        );
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Could not load this video. Check your connection and try again.';
      });
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text(widget.lecture.title)),
      body: Center(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          _errorMessage!,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      );
    }
    final chewieController = _chewieController;
    if (chewieController == null) {
      return const CircularProgressIndicator();
    }
    return AspectRatio(
      aspectRatio: _videoController.value.aspectRatio,
      child: Chewie(controller: chewieController),
    );
  }
}
