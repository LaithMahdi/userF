import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class TestColorsScreen extends StatefulWidget {
  @override
  _TestColorsScreenState createState() => _TestColorsScreenState();
}

class _TestColorsScreenState extends State<TestColorsScreen> {
  late List<CameraDescription> cameras;
  late CameraController controller;
  Color selectedColor = Colors.white;
  Color cameraBackgroundColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    await controller.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Colors'),
      ),
      body: Column(
        children: [
          Expanded(
  child: Stack(
    children: [
      AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: controller.value.isInitialized
            ? CameraPreview(controller)
            : Center(child: CircularProgressIndicator()),
      ),
      Positioned.fill(
        child: Container(
          color: cameraBackgroundColor,
        ),
      ),
    ],
  ),
),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                setState(() {
                  selectedColor = color;
                  cameraBackgroundColor = color.withOpacity(0.8);
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Utilisez la couleur sélectionnée pour effectuer des actions, comme changer la couleur de fond de la caméra.
          // Par exemple, vous pouvez appeler une méthode qui met à jour la couleur de fond de la caméra.
        },
        child: Icon(Icons.check),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
