import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class ImageAnalysis extends StatefulWidget {
  const ImageAnalysis({super.key});

  @override
  State<ImageAnalysis> createState() => _ImageAnalysisState();
}

class _ImageAnalysisState extends State<ImageAnalysis> {
  late Interpreter _interpreter;
  File? _image;
  final ValueNotifier<String> _stressLevel = ValueNotifier(
    "📤 Upload an image to analyze",
  );
  bool _isLoading = false;

  final List<String> _emotions = [
    "Angry 😡",
    "Disgust 🤢",
    "Fear 😨",
    "Happy 😊",
    "Neutral 😐",
    "Sad 😭",
    "Surprise 😲",
  ];

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/fer2013_model.tflite');
    } catch (e) {
      debugPrint('Error loading model: $e');
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 48,
      maxHeight: 48,
    );
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
      _analyzeImage(File(pickedFile.path));
    }
  }

  Future<void> _analyzeImage(File imageFile) async {
    setState(() => _isLoading = true);
    Uint8List imageBytes = await imageFile.readAsBytes();
    img.Image? image = img.decodeImage(imageBytes);

    if (image != null) {
      List<List<List<List<double>>>> input = _normalizeImage(image);
      List<List<double>> output = List.generate(1, (_) => List.filled(7, 0.0));

      _interpreter.run(input, output);

      final int maxIndex = output[0].indexWhere(
        (score) => score == output[0].reduce((a, b) => a > b ? a : b),
      );

      _stressLevel.value = _getStressLevel(_emotions[maxIndex]);
    }

    setState(() => _isLoading = false);
  }

  List<List<List<List<double>>>> _normalizeImage(img.Image image) {
    List<List<List<List<double>>>> input = List.generate(
      1,
      (_) => List.generate(
        48,
        (_) => List.generate(48, (_) => List.generate(1, (_) => 0.0)),
      ),
    );

    for (int y = 0; y < 48; y++) {
      for (int x = 0; x < 48; x++) {
        final pixel = image.getPixel(x, y);
        final red = pixel.r.toInt();
        final green = pixel.g.toInt();
        final blue = pixel.b.toInt();
        input[0][y][x][0] = (red + green + blue) / (3.0 * 255.0);
      }
    }
    return input;
  }

  String _getStressLevel(String detectedEmotion) {
    if (["Happy 😊", "Neutral 😐", "Surprise 😲"].contains(detectedEmotion)) {
      return "Low Stress 😊";
    } else if (["Angry 😡", "Sad 😭"].contains(detectedEmotion)) {
      return "High Stress 😟";
    }
    return "Moderate Stress 😐";
  }

  String _getStressMessage(String level) {
    switch (level) {
      case "Low Stress 😊":
        return "Great! You seem relaxed and positive! 🌟";
      case "Moderate Stress 😐":
        return "You're managing well, but consider taking breaks 🧘♀️";
      case "High Stress 😟":
        return "Time for self-care and relaxation techniques 💆♂️";
      default:
        return "Stay mindful of your well-being 💖";
    }
  }

  Color _getStressColor(String level) {
    switch (level) {
      case "Low Stress 😊":
        return Colors.green.shade400;
      case "Moderate Stress 😐":
        return Colors.amber.shade600;
      case "High Stress 😟":
        return Colors.red.shade400;
      default:
        return Colors.deepPurple.shade300;
    }
  }

  @override
  void dispose() {
    _interpreter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '😌 Stress Lens Analysis 📸',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 10,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A237E), Color(0xFF4A148C), Color(0xFF6A1B9A)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image Preview
                _image == null
                    ? const Text(
                      '🖼️ No image selected',
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    )
                    : ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.file(
                        _image!,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                const SizedBox(height: 30),

                // Upload Button
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    shadowColor: Colors.black.withOpacity(0.3),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.upload, color: Colors.deepPurple),
                      SizedBox(width: 10),
                      Text(
                        'Upload Image',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Analysis Results Box
                _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : ValueListenableBuilder<String>(
                      valueListenable: _stressLevel,
                      builder:
                          (context, value, child) => Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _getStressColor(value).withOpacity(0.3),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Stress Level Indicator
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStressColor(value),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),

                                // Stress Message
                                Text(
                                  _getStressMessage(value),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.9),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Decorative Line
                                Container(
                                  height: 2,
                                  width: 100,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStressColor(
                                      value,
                                    ).withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
