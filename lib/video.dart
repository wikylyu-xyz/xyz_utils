import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class XyzVideoPlayer extends StatefulWidget {
  final String url;
  final double aspectRatio;
  const XyzVideoPlayer(
      {super.key, required this.url, this.aspectRatio = 16 / 9.0});

  @override
  State<StatefulWidget> createState() => _XyzVideoPlayerState();
}

class _XyzVideoPlayerState extends State<XyzVideoPlayer> {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(
        widget.url,
      ),
    );
    videoPlayerController.initialize().then((value) {
      chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        aspectRatio: 16 / 9,
        autoPlay: true,
        looping: false,
        showControlsOnInitialize: false,
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();

    videoPlayerController.dispose();
    chewieController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: chewieController != null
          ? Chewie(
              controller: chewieController!,
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
