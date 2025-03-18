import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:dart_sentiment/dart_sentiment.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:translator/translator.dart';

const Map<String, String> languageNames = {
  'en': 'English',
  'hi': 'हिन्दी',
  'ta': 'தமிழ்',
  'te': 'తెలుగు',
  'ml': 'മലയാളം',
  'kn': 'ಕನ್ನಡ',
};

// Define keywords for stress levels in each language
// final Map<String, Map<String, List<String>>> languageKeywordStressLevels = {
//   'en': {
//     'High Stress 😟': [
//       'i want to die',
//       'i am very stressed',
//       'i can\'t handle this',
//     ],
//     'Moderate Stress 😐': ['i am in stress', 'i feel anxious', 'i need help'],
//     'Low Stress 😊': ['i am feeling good', 'i am happy', 'everything is fine'],
//   },
//   'hi': {
//     'High Stress 😟': [
//       'मेरा जीना नहीं चाहता',
//       'मेरा बहुत तनाव',
//       'मेरा इसे नहीं कर पा रहा',
//     ],
//     'Moderate Stress 😐': ['मेरे पास तनाव', 'मेरा चिंतित', 'मेरा मदद चाहता'],

//     'Low Stress 😊': ['मेरा अच्छा लग रहा', 'मेरा ख़ुश', 'सारा कार्य ठीक'],
//   },
//   'ta': {
//     'High Stress 😟': [], // Add Tamil keywords here
//     'Moderate Stress 😐': [],
//     'Low Stress 😊': [],
//   },
//   'te': {
//     'High Stress 😟': [], // Add Telugu keywords here
//     'Moderate Stress 😐': [],
//     'Low Stress 😊': [],
//   },
//   'ml': {
//     'High Stress 😟': [], // Add Malayalam keywords here
//     'Moderate Stress 😐': [],
//     'Low Stress 😊': [],
//   },
//   'kn': {
//     'High Stress 😟': [], // Add Kannada keywords here
//     'Moderate Stress 😐': [],
//     'Low Stress 😊': [],
//   },
// };

// // Order of stress levels for priority checking (high to low)
// const List<String> stressLevelsOrder = [
//   'High Stress 😟',
//   'Moderate Stress 😐',
//   'Low Stress 😊',
// ];

final Map<String, Map<String, List<String>>> languageKeywordStressLevels = {
  'en': {
    'High Stress 😟': [
      'i want to die',
      'i am very stressed',
      'i can\'t handle this',
    ],
    'Moderate Stress 😐': ['i am in stress', 'i feel anxious', 'i need help'],
    'Low Stress 😊': ['i am feeling good', 'i am happy', 'everything is fine'],
  },
  'hi': {
    'High Stress 😟': [
      'मेरा जीना नहीं चाहता', // "I don’t want to live"
      'मेरा बहुत तनाव', // "I have a lot of stress"
      'मेरा इसे नहीं कर पा रहा', // "I can’t do this"
    ],
    'Moderate Stress 😐': [
      'मेरे पास तनाव', // "I have stress"
      'मेरा चिंतित', // "I am worried"
      'मेरा मदद चाहता', // "I want help"
    ],
    'Low Stress 😊': [
      'मेरा अच्छा लग रहा', // "I am feeling good"
      'मेरा ख़ुश', // "I am happy"
      'सारा कार्य ठीक', // "Everything is fine"
    ],
  },
  'ta': {
    'High Stress 😟': [
      'நான் சாக விரும்புகிறேன்', // "I want to die"
      'நான் மிகவும் மன அழுத்தத்தில் இருக்கிறேன்', // "I am very stressed"
      'என்னால் இதை சமாளிக்க முடியவில்லை', // "I can’t handle this"
    ],
    'Moderate Stress 😐': [
      'நான் மன அழுத்தத்தில் இருக்கிறேன்', // "I am in stress"
      'நான் பதட்டமாக உணர்கிறேன்', // "I feel anxious"
      'எனக்கு உதவி தேவை', // "I need help"
    ],
    'Low Stress 😊': [
      'நான் நன்றாக உணர்கிறேன்', // "I am feeling good"
      'நான் மகிழ்ச்சியாக இருக்கிறேன்', // "I am happy"
      'எல்லாம் சரியாக இருக்கிறது', // "Everything is fine"
    ],
  },
  'te': {
    'High Stress 😟': [
      'నేను చనిపోవాలనుకుంటున్నాను', // "I want to die"
      'నేను చాలా ఒత్తిడిలో ఉన్నాను', // "I am very stressed"
      'నేను దీన్ని సాధించలేను', // "I can’t handle this"
    ],
    'Moderate Stress 😐': [
      'నేను ఒత్తిడిలో ఉన్నాను', // "I am in stress"
      'నాకు ఆందోళనగా ఉంది', // "I feel anxious"
      'నాకు సహాయం కావాలి', // "I need help"
    ],
    'Low Stress 😊': [
      'నేను బాగా ఉన్నాను', // "I am feeling good"
      'నేను సంతోషంగా ఉన్నాను', // "I am happy"
      'అంతా బాగుంది', // "Everything is fine"
    ],
  },
  'ml': {
    'High Stress 😟': [
      'ഞാൻ മരിക്കാൻ ആഗ്രഹിക്കുന്നു', // "I want to die"
      'ഞാൻ വളരെ സമ്മർദ്ദത്തിൽ ആണ്', // "I am very stressed"
      'എനിക്ക് ഇത് കൈകാര്യം ചെയ്യാൻ കഴിയില്ല', // "I can’t handle this"
    ],
    'Moderate Stress 😐': [
      'ഞാൻ സമ്മർദ്ദത്തിൽ ആണ്', // "I am in stress"
      'എനിക്ക് ഉത്കണ്ഠ തോന്നുന്നു', // "I feel anxious"
      'എനിക്ക് സഹായം വേണം', // "I need help"
    ],
    'Low Stress 😊': [
      'ഞാൻ നല്ലതായി തോന്നുന്നു', // "I am feeling good"
      'ഞാൻ സന്തോഷവാനാണ്', // "I am happy"
      'എല്ലാം ശരിയാണ്', // "Everything is fine"
    ],
  },
  'kn': {
    'High Stress 😟': [
      'ನಾನು ಸಾಯಲು ಬಯಸುತ್ತೇನೆ', // "I want to die"
      'ನಾನು ತುಂಬಾ ಒತ್ತಡದಲ್ಲಿ ಇದ್ದೇನೆ', // "I am very stressed"
      'ನನಗೆ ಇದನ್ನು ನಿಭಾಯಿಸಲು ಸಾಧ್ಯವಿಲ್ಲ', // "I can’t handle this"
    ],
    'Moderate Stress 😐': [
      'ನಾನು ಒತ್ತಡದಲ್ಲಿ ಇದ್ದೇನೆ', // "I am in stress"
      'ನನಗೆ ಆತಂಕವಾಗುತ್ತಿದೆ', // "I feel anxious"
      'ನನಗೆ ಸಹಾಯ ಬೇಕು', // "I need help"
    ],
    'Low Stress 😊': [
      'ನಾನು ಚೆನ್ನಾಗಿ ಭಾವಿಸುತ್ತೇನೆ', // "I am feeling good"
      'ನಾನು ಸಂತೋಷವಾಗಿದ್ದೇನೆ', // "I am happy"
      'ಎಲ್ಲವೂ ಸರಿಯಾಗಿದೆ', // "Everything is fine"
    ],
  },
};
// Order of stress levels for priority checking (high to low)
const List<String> stressLevelsOrder = [
  'High Stress 😟',
  'Moderate Stress 😐',
  'Low Stress 😊',
];

class VoiceFaceAnalysis extends StatefulWidget {
  const VoiceFaceAnalysis({super.key});

  @override
  State<VoiceFaceAnalysis> createState() => _VoiceFaceAnalysisState();
}

class _VoiceFaceAnalysisState extends State<VoiceFaceAnalysis> {
  late stt.SpeechToText _speech;
  CameraController? _cameraController;
  late FaceDetector _faceDetector;
  Interpreter? _interpreter;
  bool _isAnalyzing = false;
  String _detectedText = "";
  String _stressLevel = "Press Start to Analyze";
  String _currentEmotion = "Neutral 😐";
  final _sentiment = Sentiment();
  String _selectedLanguage = 'en';
  final _translator = GoogleTranslator();
  Timer? _analysisTimer;
  final _speechBuffer = StringBuffer();
  DateTime? _lastSpeechUpdate;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    _speech = stt.SpeechToText();
    await _initializeCamera();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
        performanceMode: FaceDetectorMode.fast,
      ),
    );
    await _loadModel();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.low,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Camera Error: $e');
    }
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/fer2013_model.tflite');
      _interpreter!.allocateTensors();
    } catch (e) {
      debugPrint('Model Error: $e');
    }
  }

  Future<void> _toggleAnalysis() async {
    if (_isAnalyzing) {
      await _stopAnalysis();
    } else {
      await _startAnalysis();
    }
  }

  Future<void> _startAnalysis() async {
    _speechBuffer.clear();
    setState(() {
      _isAnalyzing = true;
      _stressLevel = "Analyzing...";
      _detectedText = "";
    });

    if (await _speech.initialize()) {
      _speech.listen(
        onResult: (result) {
          if (result.recognizedWords.isNotEmpty) {
            final now = DateTime.now();
            if (_lastSpeechUpdate == null ||
                now.difference(_lastSpeechUpdate!) >
                    const Duration(milliseconds: 200)) {
              _lastSpeechUpdate = now;
              _speechBuffer.write('${result.recognizedWords} ');
              setState(() => _detectedText = _speechBuffer.toString());
            }
          }
        },
        localeId: _getLocaleId(),
        listenFor: const Duration(minutes: 5),
        listenOptions: stt.SpeechListenOptions(
          cancelOnError: true,
          listenMode: stt.ListenMode.confirmation,
        ),
      );
    }

    _analysisTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!_isAnalyzing) {
        timer.cancel();
        return;
      }
      await _analyzeStress();
    });
  }

  Future<void> _stopAnalysis() async {
    _speech.stop();
    _analysisTimer?.cancel();
    await _analyzeStress();
    setState(() => _isAnalyzing = false);
    _speechBuffer.clear();
  }

  // Normalize text for consistent keyword matching
  String normalizeText(String text) {
    return text.toLowerCase().replaceAll(RegExp(r'[\.,!?]'), '');
  }

  // Check if text contains a keyword sequence
  bool containsKeyword(String text, String keyword) {
    final textWords = text.split(' ');
    final keywordWords = keyword.split(' ');
    int textIndex = 0;
    for (final kwWord in keywordWords) {
      while (textIndex < textWords.length && textWords[textIndex] != kwWord) {
        textIndex++;
      }
      if (textIndex == textWords.length) {
        return false;
      }
      textIndex++;
    }
    return true;
  }

  Future<void> _analyzeStress() async {
    try {
      final text = _detectedText;
      if (text.isEmpty) return;

      // Check for keywords first
      final normalizedText = normalizeText(text);
      final language = _selectedLanguage;
      final keywords = languageKeywordStressLevels[language];

      if (keywords != null) {
        for (final stressLevel in stressLevelsOrder) {
          for (final keyword in keywords[stressLevel]!) {
            if (containsKeyword(normalizedText, keyword)) {
              setState(() => _stressLevel = stressLevel);
              return;
            }
          }
        }
      }

      // Fallback to standard analysis if no keywords match
      final translatedText = await _translateToEnglish(text);
      final sentiment = _sentiment.analysis(translatedText);
      final faceStress = _calculateFaceStress();
      final voiceStress = _calculateVoiceStress(text);

      final totalScore =
          (sentiment['score']?.abs() ?? 0) * 2 + faceStress * 1.5 + voiceStress;

      final newStressLevel = _getStressLevel(totalScore);
      setState(() => _stressLevel = newStressLevel);
    } catch (e) {
      debugPrint('Stress analysis error: $e');
    }
  }

  String _getStressLevel(double totalScore) {
    if (totalScore > 15) return "Critical Stress 😱";
    if (totalScore > 10) return "High Stress 😟";
    if (totalScore > 5) return "Moderate Stress 😐";
    return "Low Stress 😊";
  }

  double _calculateFaceStress() {
    return switch (_currentEmotion) {
      "High Stress 😟" => 4.0,
      "Moderate Stress 😐" => 2.5,
      _ => 1.0,
    };
  }

  double _calculateVoiceStress(String text) {
    final wordCount = text.split(' ').length;
    final sentiment = _sentiment.analysis(text);
    final baseScore =
        wordCount > 50
            ? 3.0
            : wordCount > 25
            ? 2.0
            : 1.0;
    return baseScore * (sentiment['comparative']?.abs() ?? 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "🎤 Voice & 📸 Face Stress Analysis",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 10,
        actions: [
          DropdownButton<String>(
            value: _selectedLanguage,
            items:
                languageNames.entries
                    .map(
                      (entry) => DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(entry.value),
                      ),
                    )
                    .toList(),
            onChanged: (value) => setState(() => _selectedLanguage = value!),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 38, 6, 93),
              Color.fromARGB(255, 61, 29, 127),
              Color.fromARGB(255, 41, 35, 75),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_cameraController != null &&
                    _cameraController!.value.isInitialized)
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CameraPreview(_cameraController!),
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _toggleAnalysis,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isAnalyzing ? Colors.red : Colors.lightGreen,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    _isAnalyzing ? "⏹ Stop Analysis" : "▶ Start Analysis",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Detected Text: $_detectedText",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _stressLevel,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            _getStressDialog(_stressLevel),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.amber.shade200,
                              fontStyle: FontStyle.italic,
                            ),
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

  String _getStressDialog(String stressLevel) {
    return switch (stressLevel) {
      "Low Stress 😊" =>
        "🌟 Great! You seem relaxed and in control. Maintain this positive state!",
      "Moderate Stress 😐" =>
        "💡 You're handling things well, but consider taking short mindful breaks.",
      "High Stress 😟" =>
        "⚠️ Noticeable stress detected. Try deep breathing or a quick walk.",
      "Critical Stress 😱" =>
        "🚨 High stress levels detected! Please consider seeking support.",
      _ => "🌱 Take a moment to focus on your well-being.",
    };
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetector.close();
    _interpreter?.close();
    _analysisTimer?.cancel();
    super.dispose();
  }

  String _getLocaleId() => '$_selectedLanguage-IN';

  Future<String> _translateToEnglish(String text) async {
    if (_selectedLanguage == 'en' || text.isEmpty) return text;
    try {
      return (await _translator.translate(text, to: 'en')).text;
    } catch (e) {
      return text;
    }
  }
}

void main() {
  runApp(const MaterialApp(home: VoiceFaceAnalysis()));
}








// import 'dart:async';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:camera/camera.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:dart_sentiment/dart_sentiment.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:translator/translator.dart';

// const Map<String, String> languageNames = {
//   'en': 'English',
//   'hi': 'हिन्दी',
//   'ta': 'தமிழ்',
//   'te': 'తెలుగు',
//   'ml': 'മലയാളം',
//   'kn': 'ಕನ್ನಡ',
// };

// class VoiceFaceAnalysis extends StatefulWidget {
//   const VoiceFaceAnalysis({super.key});

//   @override
//   State<VoiceFaceAnalysis> createState() => _VoiceFaceAnalysisState();
// }

// class _VoiceFaceAnalysisState extends State<VoiceFaceAnalysis> {
//   late stt.SpeechToText _speech;
//   CameraController? _cameraController;
//   late FaceDetector _faceDetector;
//   Interpreter? _interpreter;
//   bool _isAnalyzing = false;
//   String _detectedText = "";
//   String _stressLevel = "Press Start to Analyze";
//   String _currentEmotion = "Neutral 😐";
//   final _sentiment = Sentiment();
//   String _selectedLanguage = 'en';
//   final _translator = GoogleTranslator();
//   Timer? _analysisTimer;
//   final _speechBuffer = StringBuffer();
//   DateTime? _lastSpeechUpdate;

//   @override
//   void initState() {
//     super.initState();
//     _initializeServices();
//   }

//   Future<void> _initializeServices() async {
//     _speech = stt.SpeechToText();
//     await _initializeCamera();
//     _faceDetector = FaceDetector(
//       options: FaceDetectorOptions(
//         enableClassification: true,
//         performanceMode: FaceDetectorMode.fast,
//       ),
//     );
//     await _loadModel();
//   }

//   Future<void> _initializeCamera() async {
//     try {
//       final cameras = await availableCameras();
//       final frontCamera = cameras.firstWhere(
//         (c) => c.lensDirection == CameraLensDirection.front,
//       );

//       _cameraController = CameraController(
//         frontCamera,
//         ResolutionPreset.low,
//         enableAudio: false,
//       );

//       await _cameraController!.initialize();
//       if (mounted) setState(() {});
//     } catch (e) {
//       debugPrint('Camera Error: $e');
//     }
//   }

//   Future<void> _loadModel() async {
//     try {
//       _interpreter = await Interpreter.fromAsset('assets/fer2013_model.tflite');
//       _interpreter!.allocateTensors();
//     } catch (e) {
//       debugPrint('Model Error: $e');
//     }
//   }

//   Future<void> _toggleAnalysis() async {
//     if (_isAnalyzing) {
//       await _stopAnalysis();
//     } else {
//       await _startAnalysis();
//     }
//   }

//   Future<void> _startAnalysis() async {
//     _speechBuffer.clear();
//     setState(() {
//       _isAnalyzing = true;
//       _stressLevel = "Analyzing...";
//       _detectedText = "";
//     });

//     if (await _speech.initialize()) {
//       _speech.listen(
//         onResult: (result) {
//           if (result.recognizedWords.isNotEmpty) {
//             final now = DateTime.now();
//             if (_lastSpeechUpdate == null ||
//                 now.difference(_lastSpeechUpdate!) >
//                     const Duration(milliseconds: 200)) {
//               _lastSpeechUpdate = now;
//               _speechBuffer.write('${result.recognizedWords} ');
//               setState(() => _detectedText = _speechBuffer.toString());
//             }
//           }
//         },
//         localeId: _getLocaleId(),
//         listenFor: const Duration(minutes: 5),
//         listenOptions: stt.SpeechListenOptions(
//           cancelOnError: true,
//           listenMode: stt.ListenMode.confirmation,
//         ),
//       );
//     }

//     _analysisTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
//       if (!_isAnalyzing) {
//         timer.cancel();
//         return;
//       }
//       await _analyzeStress();
//     });
//   }

//   Future<void> _stopAnalysis() async {
//     _speech.stop();
//     _analysisTimer?.cancel();
//     await _analyzeStress();
//     setState(() => _isAnalyzing = false);
//     _speechBuffer.clear();
//   }

//   Future<void> _analyzeStress() async {
//     try {
//       final text = _detectedText;
//       if (text.isEmpty) return;

//       final translatedText = await _translateToEnglish(text);
//       final sentiment = _sentiment.analysis(translatedText);
//       final faceStress = _calculateFaceStress();
//       final voiceStress = _calculateVoiceStress(text);

//       final totalScore =
//           (sentiment['score']?.abs() ?? 0) * 2 + faceStress * 1.5 + voiceStress;

//       final newStressLevel = _getStressLevel(totalScore);
//       setState(() => _stressLevel = newStressLevel);
//     } catch (e) {
//       debugPrint('Stress analysis error: $e');
//     }
//   }

//   String _getStressLevel(double totalScore) {
//     if (totalScore > 15) return "Critical Stress 😱";
//     if (totalScore > 10) return "High Stress 😟";
//     if (totalScore > 5) return "Moderate Stress 😐";
//     return "Low Stress 😊";
//   }

//   double _calculateFaceStress() {
//     return switch (_currentEmotion) {
//       "High Stress 😟" => 4.0,
//       "Moderate Stress 😐" => 2.5,
//       _ => 1.0,
//     };
//   }

//   double _calculateVoiceStress(String text) {
//     final wordCount = text.split(' ').length;
//     final sentiment = _sentiment.analysis(text);
//     final baseScore =
//         wordCount > 50
//             ? 3.0
//             : wordCount > 25
//             ? 2.0
//             : 1.0;
//     return baseScore * (sentiment['comparative']?.abs() ?? 1.0);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "🎤 Voice & 📸 Face Stress Analysis",
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 10,
//         actions: [
//           DropdownButton<String>(
//             value: _selectedLanguage,
//             items:
//                 languageNames.entries
//                     .map(
//                       (entry) => DropdownMenuItem<String>(
//                         value: entry.key,
//                         child: Text(entry.value),
//                       ),
//                     )
//                     .toList(),
//             onChanged: (value) => setState(() => _selectedLanguage = value!),
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color.fromARGB(255, 38, 6, 93),
//               Color.fromARGB(255, 61, 29, 127),
//               Color.fromARGB(255, 41, 35, 75),
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: ConstrainedBox(
//             constraints: BoxConstraints(
//               minHeight: MediaQuery.of(context).size.height,
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 if (_cameraController != null &&
//                     _cameraController!.value.isInitialized)
//                   SizedBox(
//                     height: 300,
//                     width: 300,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(20),
//                       child: CameraPreview(_cameraController!),
//                     ),
//                   )
//                 else
//                   const Padding(
//                     padding: EdgeInsets.all(40.0),
//                     child: CircularProgressIndicator(color: Colors.white),
//                   ),
//                 const SizedBox(height: 30),
//                 ElevatedButton(
//                   onPressed: _toggleAnalysis,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor:
//                         _isAnalyzing ? Colors.red : Colors.lightGreen,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 40,
//                       vertical: 15,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   child: Text(
//                     _isAnalyzing ? "⏹ Stop Analysis" : "▶ Start Analysis",
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                   child: Container(
//                     padding: const EdgeInsets.all(20),
//                     margin: const EdgeInsets.only(bottom: 20),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: Column(
//                       children: [
//                         Text(
//                           "Detected Text: $_detectedText",
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             fontSize: 18,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         Text(
//                           _stressLevel,
//                           style: const TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                           child: Text(
//                             _getStressDialog(_stressLevel),
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.amber.shade200,
//                               fontStyle: FontStyle.italic,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   String _getStressDialog(String stressLevel) {
//     return switch (stressLevel) {
//       "Low Stress 😊" =>
//         "🌟 Great! You seem relaxed and in control. Maintain this positive state!",
//       "Moderate Stress 😐" =>
//         "💡 You're handling things well, but consider taking short mindful breaks.",
//       "High Stress 😟" =>
//         "⚠️ Noticeable stress detected. Try deep breathing or a quick walk.",
//       "Critical Stress 😱" =>
//         "🚨 High stress levels detected! Please consider seeking support.",
//       _ => "🌱 Take a moment to focus on your well-being.",
//     };
//   }

//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     _faceDetector.close();
//     _interpreter?.close();
//     _analysisTimer?.cancel();
//     super.dispose();
//   }

//   String _getLocaleId() => '$_selectedLanguage-IN';

//   Future<String> _translateToEnglish(String text) async {
//     if (_selectedLanguage == 'en' || text.isEmpty) return text;
//     try {
//       return (await _translator.translate(text, to: 'en')).text;
//     } catch (e) {
//       return text;
//     }
//   }
// }










// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:camera/camera.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:dart_sentiment/dart_sentiment.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:image/image.dart' as img;
// import 'package:translator/translator.dart';

// const Map<String, String> languageNames = {
//   'en': 'English',
//   'hi': 'हिन्दी',
//   'ta': 'தமிழ்',
//   'te': 'తెలుగు',
//   'ml': 'മലയാളം',
//   'kn': 'ಕನ್ನಡ',
// };

// class VoiceFaceAnalysis extends StatefulWidget {
//   const VoiceFaceAnalysis({super.key});

//   @override
//   _VoiceFaceAnalysisState createState() => _VoiceFaceAnalysisState();
// }

// class _VoiceFaceAnalysisState extends State<VoiceFaceAnalysis> {
//   late stt.SpeechToText _speech;
//   CameraController? _cameraController;
//   late FaceDetector _faceDetector;
//   Interpreter? _interpreter;
//   bool _isAnalyzing = false;
//   String _detectedText = "";
//   String _stressLevel = "Press Start to Analyze";
//   DateTime? _lastProcessingTime;
//   final _sentiment = Sentiment();
//   final List<String> _emotions = [
//     "Angry 😡",
//     "Disgust 🤢",
//     "Fear 😨",
//     "Happy 😊",
//     "Neutral 😐",
//     "Sad 😭",
//     "Surprise 😲",
//   ];
//   String _selectedLanguage = 'en';
//   final _translator = GoogleTranslator();

//   @override
//   void initState() {
//     super.initState();
//     _initializeServices();
//   }

//   Future<void> _initializeServices() async {
//     _speech = stt.SpeechToText();
//     await _initializeCamera();
//     _faceDetector = FaceDetector(
//       options: FaceDetectorOptions(
//         enableClassification: true,
//         performanceMode: FaceDetectorMode.fast,
//       ),
//     );
//     await _loadModel();
//   }

//   Future<void> _initializeCamera() async {
//     try {
//       final cameras = await availableCameras();
//       final frontCamera = cameras.firstWhere(
//         (c) => c.lensDirection == CameraLensDirection.front,
//       );

//       _cameraController = CameraController(
//         frontCamera,
//         ResolutionPreset.low,
//         enableAudio: false,
//       );

//       await _cameraController!.initialize();
//       if (mounted) setState(() {});
//     } catch (e) {
//       debugPrint('Camera Error: $e');
//     }
//   }

//   Future<void> _loadModel() async {
//     try {
//       _interpreter = await Interpreter.fromAsset('assets/fer2013_model.tflite');
//       _interpreter!.allocateTensors();
//     } catch (e) {
//       debugPrint('Model Error: $e');
//     }
//   }

//   Future<void> _toggleAnalysis() async {
//     if (_isAnalyzing) {
//       await _stopAnalysis();
//     } else {
//       await _startAnalysis();
//     }
//   }

//   Future<void> _startAnalysis() async {
//     setState(() {
//       _isAnalyzing = true;
//       _stressLevel = "Analyzing...";
//       _detectedText = "";
//     });

//     if (await _speech.initialize()) {
//       _speech.listen(
//         onResult: (result) {
//           if (result.finalResult) {
//             setState(() => _detectedText = result.recognizedWords);
//           }
//         },
//         localeId: _getLocaleId(),
//         listenFor: const Duration(minutes: 5),
//         cancelOnError: true,
//       );
//     }

//     _cameraController?.startImageStream((image) {
//       if (_isAnalyzing &&
//           (_lastProcessingTime == null ||
//               DateTime.now().difference(_lastProcessingTime!) >
//                   const Duration(milliseconds: 500))) {
//         _processFrame(image);
//         _lastProcessingTime = DateTime.now();
//       }
//     });
//   }

//   String _getLocaleId() {
//     switch (_selectedLanguage) {
//       case 'hi':
//         return 'hi-IN';
//       case 'ta':
//         return 'ta-IN';
//       case 'te':
//         return 'te-IN';
//       case 'ml':
//         return 'ml-IN';
//       case 'kn':
//         return 'kn-IN';
//       default:
//         return 'en-US';
//     }
//   }

//   Future<void> _stopAnalysis() async {
//     _speech.stop();
//     _cameraController?.stopImageStream();
//     final result = await _calculateStress();
//     setState(() {
//       _isAnalyzing = false;
//       _stressLevel = result;
//     });
//   }

//   Future<void> _processFrame(CameraImage image) async {
//     try {
//       final inputImage = InputImage.fromBytes(
//         bytes: _concatImagePlanes(image.planes),
//         inputImageData: InputImageData(
//           size: Size(image.width.toDouble(), image.height.toDouble()),
//           imageRotation: InputImageRotation.rotation0deg,
//           inputImageFormat: InputImageFormat.nv21,
//           planeData:
//               image.planes
//                   .map(
//                     (plane) => InputImagePlaneMetadata(
//                       bytesPerRow: plane.bytesPerRow,
//                       height: plane.height,
//                       width: plane.width,
//                     ),
//                   )
//                   .toList(),
//         ),
//       );

//       final faces = await _faceDetector.processImage(inputImage);
//       if (faces.isNotEmpty) setState(() {});
//     } catch (e) {
//       debugPrint('Frame Processing Error: $e');
//     }
//   }

//   Uint8List _concatImagePlanes(List<Plane> planes) {
//     final bytes = <int>[];
//     for (final plane in planes) {
//       bytes.addAll(plane.bytes);
//     }
//     return Uint8List.fromList(bytes);
//   }

//   Future<String> _calculateStress() async {
//     int stressScore = 0;
//     String textToAnalyze = _detectedText;

//     try {
//       if (_selectedLanguage != 'en') {
//         textToAnalyze = await _translateToEnglish(_detectedText);
//       }

//       final textScore = _sentiment.analysis(textToAnalyze)['score'] ?? 0;
//       if (textScore < 0) stressScore += 1;

//       final imageFile = File((await _cameraController!.takePicture()).path);
//       final processedImage = img.copyResize(
//         img.decodeImage(imageFile.readAsBytesSync())!,
//         width: 48,
//         height: 48,
//       );

//       final input = _prepareModelInput(processedImage);
//       final output = List.filled(7, 0.0).reshape([1, 7]);
//       _interpreter?.run(input, output);

//       final emotionIndex = output[0].indexOf(
//         output[0].reduce((a, b) => a > b ? a : b),
//       );
//       if (![
//         "Happy 😊",
//         "Neutral 😐",
//         "Surprise 😲",
//       ].contains(_emotions[emotionIndex])) {
//         stressScore += 1;
//       }
//     } catch (e) {
//       debugPrint('Stress Calculation Error: $e');
//     }

//     return _getStressLevel(stressScore);
//   }

//   Future<String> _translateToEnglish(String text) async {
//     if (_selectedLanguage == 'en') return text;
//     try {
//       Translation translation = await _translator.translate(text, to: 'en');
//       return translation.text;
//     } catch (e) {
//       debugPrint('Translation error: $e');
//       return text;
//     }
//   }

//   String _getStressLevel(int score) {
//     return score == 0
//         ? "Low Stress 😊"
//         : score == 1
//         ? "Moderate Stress 😐"
//         : "High Stress 😟";
//   }

//   String _getStressDialog(String stressLevel) {
//     switch (stressLevel) {
//       case "Low Stress 😊":
//         return "🌟 Great! You seem to be handling things well. Keep up the positive mindset!";
//       case "Moderate Stress 😐":
//         return "💡 You're doing okay, but consider taking short breaks. Practice deep breathing or a quick walk.";
//       case "High Stress 😟":
//         return "⚠️ It's important to take care of yourself. Try relaxation techniques or talk to someone.";
//       default:
//         return "🌱 Take a moment to assess your well-being. Your health matters!";
//     }
//   }

//   List<List<List<List<double>>>> _prepareModelInput(img.Image image) {
//     return List.generate(
//       1,
//       (_) => List.generate(
//         48,
//         (y) => List.generate(48, (x) {
//           final pixel = image.getPixel(x, y);
//           return [(pixel.r + pixel.g + pixel.b) / 3.0 / 255.0];
//         }),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "🎤 Voice & 📸 Face Stress Analysis",
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 10,
//         actions: [
//           DropdownButton<String>(
//             value: _selectedLanguage,
//             items:
//                 languageNames.entries.map((entry) {
//                   return DropdownMenuItem(
//                     value: entry.key,
//                     child: Text(entry.value),
//                   );
//                 }).toList(),
//             onChanged: (value) => setState(() => _selectedLanguage = value!),
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color.fromARGB(255, 38, 6, 93),
//               Color.fromARGB(255, 61, 29, 127),
//               Color.fromARGB(255, 41, 35, 75),
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: ConstrainedBox(
//             constraints: BoxConstraints(
//               minHeight: MediaQuery.of(context).size.height,
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _cameraController != null &&
//                         _cameraController!.value.isInitialized
//                     ? SizedBox(
//                       height: 300,
//                       width: 300,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(20),
//                         child: CameraPreview(_cameraController!),
//                       ),
//                     )
//                     : const Padding(
//                       padding: EdgeInsets.all(40.0),
//                       child: CircularProgressIndicator(color: Colors.white),
//                     ),
//                 const SizedBox(height: 30),
//                 ElevatedButton(
//                   onPressed: _toggleAnalysis,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.lightGreen,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 40,
//                       vertical: 15,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   child: Text(
//                     _isAnalyzing ? "⏹ Stop Analysis" : "▶ Start Analysis",
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                   child: Container(
//                     padding: const EdgeInsets.all(20),
//                     margin: const EdgeInsets.only(bottom: 20),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: Column(
//                       children: [
//                         Text(
//                           "Detected Text: $_detectedText",
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             fontSize: 18,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         Text(
//                           _stressLevel,
//                           style: const TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                           child: Text(
//                             _getStressDialog(_stressLevel),
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.amber[200],
//                               fontStyle: FontStyle.italic,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     _faceDetector.close();
//     _interpreter?.close();
//     super.dispose();
//   }
// }




// Original code = 
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:camera/camera.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:dart_sentiment/dart_sentiment.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:image/image.dart' as img;

// class VoiceFaceAnalysis extends StatefulWidget {
//   const VoiceFaceAnalysis({super.key});

//   @override
//   _VoiceFaceAnalysisState createState() => _VoiceFaceAnalysisState();
// }

// class _VoiceFaceAnalysisState extends State<VoiceFaceAnalysis> {
//   late stt.SpeechToText _speech;
//   CameraController? _cameraController;
//   late FaceDetector _faceDetector;
//   Interpreter? _interpreter;
//   bool _isAnalyzing = false;
//   String _detectedText = "";
//   String _stressLevel = "Press Start to Analyze";
//   DateTime? _lastProcessingTime;
//   final _sentiment = Sentiment();
//   final List<String> _emotions = [
//     "Angry 😡",
//     "Disgust 🤢",
//     "Fear 😨",
//     "Happy 😊",
//     "Neutral 😐",
//     "Sad 😭",
//     "Surprise 😲",
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _initializeServices();
//   }

//   Future<void> _initializeServices() async {
//     _speech = stt.SpeechToText();
//     await _initializeCamera();
//     _faceDetector = FaceDetector(
//       options: FaceDetectorOptions(
//         enableClassification: true,
//         performanceMode: FaceDetectorMode.fast,
//       ),
//     );
//     await _loadModel();
//   }

//   Future<void> _initializeCamera() async {
//     try {
//       final cameras = await availableCameras();
//       final frontCamera = cameras.firstWhere(
//         (c) => c.lensDirection == CameraLensDirection.front,
//       );

//       _cameraController = CameraController(
//         frontCamera,
//         ResolutionPreset.low,
//         enableAudio: false,
//       );

//       await _cameraController!.initialize();
//       if (mounted) setState(() {});
//     } catch (e) {
//       debugPrint('Camera Error: $e');
//     }
//   }

//   Future<void> _loadModel() async {
//     try {
//       _interpreter = await Interpreter.fromAsset('assets/fer2013_model.tflite');
//       _interpreter!.allocateTensors();
//     } catch (e) {
//       debugPrint('Model Error: $e');
//     }
//   }

//   Future<void> _toggleAnalysis() async {
//     if (_isAnalyzing) {
//       await _stopAnalysis();
//     } else {
//       await _startAnalysis();
//     }
//   }

//   Future<void> _startAnalysis() async {
//     setState(() {
//       _isAnalyzing = true;
//       _stressLevel = "Analyzing...";
//       _detectedText = "";
//     });

//     if (await _speech.initialize()) {
//       _speech.listen(
//         onResult: (result) {
//           if (result.finalResult) {
//             setState(() => _detectedText = result.recognizedWords);
//           }
//         },
//       );
//     }

//     _cameraController?.startImageStream((image) {
//       if (_isAnalyzing &&
//           (_lastProcessingTime == null ||
//               DateTime.now().difference(_lastProcessingTime!) >
//                   const Duration(milliseconds: 500))) {
//         _processFrame(image);
//         _lastProcessingTime = DateTime.now();
//       }
//     });
//   }

//   Future<void> _stopAnalysis() async {
//     _speech.stop();
//     _cameraController?.stopImageStream();
//     final result = await _calculateStress();
//     setState(() {
//       _isAnalyzing = false;
//       _stressLevel = result;
//     });
//   }

//   Future<void> _processFrame(CameraImage image) async {
//     try {
//       final inputImage = InputImage.fromBytes(
//         bytes: _concatImagePlanes(image.planes),
//         inputImageData: InputImageData(
//           size: Size(image.width.toDouble(), image.height.toDouble()),
//           imageRotation: InputImageRotation.rotation0deg,
//           inputImageFormat: InputImageFormat.nv21,
//           planeData:
//               image.planes
//                   .map(
//                     (plane) => InputImagePlaneMetadata(
//                       bytesPerRow: plane.bytesPerRow,
//                       height: plane.height,
//                       width: plane.width,
//                     ),
//                   )
//                   .toList(),
//         ),
//       );

//       final faces = await _faceDetector.processImage(inputImage);
//       if (faces.isNotEmpty) setState(() {});
//     } catch (e) {
//       debugPrint('Frame Processing Error: $e');
//     }
//   }

//   Uint8List _concatImagePlanes(List<Plane> planes) {
//     final bytes = <int>[];
//     for (final plane in planes) {
//       bytes.addAll(plane.bytes);
//     }
//     return Uint8List.fromList(bytes);
//   }

//   Future<String> _calculateStress() async {
//     int stressScore = 0;

//     final textScore = _sentiment.analysis(_detectedText)['score'] ?? 0;
//     if (textScore < 0) stressScore += 1;

//     try {
//       final imageFile = File((await _cameraController!.takePicture()).path);
//       final processedImage = img.copyResize(
//         img.decodeImage(imageFile.readAsBytesSync())!,
//         width: 48,
//         height: 48,
//       );

//       final input = _prepareModelInput(processedImage);
//       final output = List.filled(7, 0.0).reshape([1, 7]);
//       _interpreter?.run(input, output);

//       final emotionIndex = output[0].indexOf(
//         output[0].reduce((a, b) => a > b ? a : b),
//       );
//       if (![
//         "Happy 😊",
//         "Neutral 😐",
//         "Surprise 😲",
//       ].contains(_emotions[emotionIndex])) {
//         stressScore += 1;
//       }
//     } catch (e) {
//       debugPrint('Stress Calculation Error: $e');
//     }

//     return _getStressLevel(stressScore);
//   }

//   String _getStressLevel(int score) {
//     return score == 0
//         ? "Low Stress 😊"
//         : score == 1
//         ? "Moderate Stress 😐"
//         : "High Stress 😟";
//   }

//   String _getStressDialog(String stressLevel) {
//     switch (stressLevel) {
//       case "Low Stress 😊":
//         return "🌟 Great! You seem to be handling things well. Keep up the positive mindset!";
//       case "Moderate Stress 😐":
//         return "💡 You're doing okay, but consider taking short breaks. Practice deep breathing or a quick walk.";
//       case "High Stress 😟":
//         return "⚠️ It's important to take care of yourself. Try relaxation techniques or talk to someone.";
//       default:
//         return "🌱 Take a moment to assess your well-being. Your health matters!";
//     }
//   }

//   List<List<List<List<double>>>> _prepareModelInput(img.Image image) {
//     return List.generate(
//       1,
//       (_) => List.generate(
//         48,
//         (y) => List.generate(48, (x) {
//           final pixel = image.getPixel(x, y);
//           return [(pixel.r + pixel.g + pixel.b) / 3.0 / 255.0];
//         }),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "🎤 Voice & 📸 Face Stress Analysis",
//           style: TextStyle(
//             fontWeight: FontWeight.bold, // Added bold font weight
//           ),
//         ),
//         backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//         elevation: 10,
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color.fromARGB(255, 38, 6, 93),
//               Color.fromARGB(255, 61, 29, 127),
//               Color.fromARGB(255, 41, 35, 75),
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: ConstrainedBox(
//             constraints: BoxConstraints(
//               minHeight: MediaQuery.of(context).size.height,
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _cameraController != null &&
//                         _cameraController!.value.isInitialized
//                     ? SizedBox(
//                       height: 300,
//                       width: 300,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(20),
//                         child: CameraPreview(_cameraController!),
//                       ),
//                     )
//                     : const Padding(
//                       padding: EdgeInsets.all(40.0),
//                       child: CircularProgressIndicator(color: Colors.white),
//                     ),
//                 const SizedBox(height: 30),
//                 ElevatedButton(
//                   onPressed: _toggleAnalysis,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.lightGreen,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 40,
//                       vertical: 15,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   child: Text(
//                     _isAnalyzing ? "⏹ Stop Analysis" : "▶ Start Analysis",
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                   child: Container(
//                     padding: const EdgeInsets.all(20),
//                     margin: const EdgeInsets.only(bottom: 20),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: Column(
//                       children: [
//                         Text(
//                           "Detected Text: $_detectedText",
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             fontSize: 18,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         Text(
//                           _stressLevel,
//                           style: const TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                           child: Text(
//                             _getStressDialog(_stressLevel),
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.amber[200],
//                               fontStyle: FontStyle.italic,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     _faceDetector.close();
//     _interpreter?.close();
//     super.dispose();
//   }
// }

