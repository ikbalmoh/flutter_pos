import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TakePicture extends StatefulWidget {
  const TakePicture({super.key, required this.camera});

  final CameraDescription camera;

  @override
  State<TakePicture> createState() => _TakePictureState();
}

class _TakePictureState extends State<TakePicture> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  XFile? picture;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onTakePicture() async {
    final XFile image = await _controller.takePicture();
    setState(() {
      picture = image;
    });
    _controller.pausePreview();
  }

  void onCancel() {
    if (picture == null) {
      context.pop();
    } else {
      setState(() {
        picture = null;
      });
      _controller.resumePreview();
    }
  }

  void onSubmit() {
    context.pop(picture);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final size = MediaQuery.of(context).size;
            var scale = size.aspectRatio * _controller.value.aspectRatio;
            if (scale < 1) scale = 1 / scale;
            // If the Future is complete, display the preview.
            return SizedBox(
              height: double.infinity,
              child: Stack(
                children: <Widget>[
                  CameraPreview(_controller),
                  Positioned(
                    bottom: 40,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          style: IconButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.2)),
                          padding: const EdgeInsets.all(10),
                          onPressed: onCancel,
                          icon: const Icon(
                            CupertinoIcons.xmark,
                            color: Colors.white,
                          ),
                        ),
                        picture == null
                            ? IconButton(
                                onPressed: onTakePicture,
                                padding: const EdgeInsets.all(10),
                                icon: const Icon(
                                  CupertinoIcons.circle,
                                  size: 80,
                                  color: Colors.white,
                                ),
                              )
                            : const SizedBox(
                                width: 80,
                                height: 80,
                              ),
                        picture == null
                            ? const SizedBox(
                                width: 45,
                                height: 45,
                              )
                            : IconButton(
                                style: IconButton.styleFrom(
                                    backgroundColor:
                                        Colors.white.withOpacity(0.2)),
                                padding: const EdgeInsets.all(10),
                                onPressed: onSubmit,
                                icon: const Icon(
                                  CupertinoIcons.checkmark_alt,
                                  color: Colors.white,
                                ),
                              ),
                      ],
                    ),
                  )
                ],
              ),
            );
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
