import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:simple_image_and_video_saver/simple_image_and_video_saver.dart';
import 'package:simple_image_and_video_saver_example/display_picture_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakeMediaScreen(camera: firstCamera),
    ),
  );
}

class TakeMediaScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakeMediaScreen({super.key, required this.camera});

  @override
  State<TakeMediaScreen> createState() => _TakeMediaScreenState();
}

class _TakeMediaScreenState extends State<TakeMediaScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera, 
      ResolutionPreset.ultraHigh,
      // enableAudio: true,fps: 30
    );
    // _controller = CameraController(widget.camera, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;

      final image = await _controller.takePicture();

      if (!mounted) return;

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            filePath: image.path,
            mediaType: MediaType.image,
          ),
        ),
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _toggleVideoRecording() async {
    try {
      await _initializeControllerFuture;

      if (!_isRecording) {
        // await _controller.getMaxExposureOffset();
        // await _controller.setExposureMode(ExposureMode.locked);
        // await _controller.setFlashMode(FlashMode.auto); // o FlashMode.auto si quieres
        await _controller.setFocusMode(FocusMode.locked);
        await _controller.setExposureMode(ExposureMode.locked);
        
        // await _controller.setExposurePoint(Offset(0.5, 0.5)); // Centro
        // await _controller.setFocusPoint(Offset(0.5, 0.5));

        await _controller.prepareForVideoRecording();
        await _controller.startVideoRecording();
        setState(() {
          _isRecording = true;
        });
      } else {
        final video = await _controller.stopVideoRecording();
        setState(() {
          _isRecording = false;
        });

        if (!mounted) return;

        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DisplayPictureScreen(
              filePath: video.path,
              mediaType: MediaType.video,
            ),
          ),
        );
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Captura foto y video')),
      body: FutureBuilder(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'photo',
            onPressed: _takePicture,
            child: const Icon(Icons.camera_alt),
          ),
          const SizedBox(height: 20),
          FloatingActionButton(
            heroTag: 'video',
            backgroundColor: _isRecording ? Colors.red : null,
            onPressed: _toggleVideoRecording,
            child: Icon(_isRecording ? Icons.stop : Icons.videocam),
          ),
        ],
      ),
    );
  }
}