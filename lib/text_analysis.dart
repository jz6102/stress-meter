// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:dart_sentiment/dart_sentiment.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:animate_do/animate_do.dart';

// class TextAnalysisScreen extends StatefulWidget {
//   const TextAnalysisScreen({super.key});

//   @override
//   _TextAnalysisScreenState createState() => _TextAnalysisScreenState();
// }

// class _TextAnalysisScreenState extends State<TextAnalysisScreen> {
//   final TextEditingController _controller = TextEditingController();
//   String _result = "";
//   String _quote = "🌿 Breathe in, breathe out. Everything will be okay.";

//   final List<String> quotes = [
//     "🌻 Stay strong, things will get better.",
//     "🌊 One step at a time, one breath at a time.",
//     "💙 You are enough. More than enough.",
//     "☀️ The sun will rise, and so will you.",
//     "🌈 Keep going, you are doing amazing.",
//     "☔ Every storm runs out of rain.",
//     "🌸 Be gentle with yourself. You're growing.",
//     "✨ Your mind deserves peace. Choose calmness.",
//   ];

//   void analyzeStressLevel() {
//     String inputText = _controller.text.trim();
//     if (inputText.isEmpty) {
//       setState(() {
//         _result = "✨ Please enter some text to analyze.";
//       });
//       return;
//     }

//     final sentiment = Sentiment();
//     final analysis = sentiment.analysis(inputText, emoji: true);
//     final score = analysis['score'];

//     String stressLevel;
//     String emoji;
//     Color bgColor;

//     if (score < -3) {
//       emoji = "🔴"; // Red emoji for High Stress
//       stressLevel = "High Stress 😨\n💙 Take time for yourself.";
//       bgColor = Colors.red.shade800;
//     } else if (score < 0) {
//       emoji = "🟠"; // Orange emoji for Moderate Stress
//       stressLevel = "Moderate Stress 😟\n🌊 Try to relax and breathe.";
//       bgColor = Colors.orange.shade700;
//     } else {
//       emoji = "🟢"; // Green emoji for Low Stress
//       stressLevel = "Low Stress 😊\n✨ You're doing great!";
//       bgColor = Colors.green.shade700;
//     }

//     setState(() {
//       _result = "$emoji Stress Level: $stressLevel\n(Score: $score)";
//       _quote = quotes[Random().nextInt(quotes.length)];
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: Text(
//           "✨ Stress Detector",
//           style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               const Color.fromARGB(255, 20, 3, 79),
//               const Color.fromARGB(255, 18, 7, 98),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               FadeIn(
//                 duration: const Duration(milliseconds: 800),
//                 child: const Text(
//                   "💙 Enter your thoughts below to analyze your stress level:",
//                   style: TextStyle(fontSize: 18, color: Colors.white70),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Floating Card for Input Field
//               SlideInUp(
//                 duration: const Duration(milliseconds: 800),
//                 child: Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 10,
//                         spreadRadius: 3,
//                       ),
//                     ],
//                   ),
//                   child: TextField(
//                     controller: _controller,
//                     maxLines: 5,
//                     style: const TextStyle(color: Colors.white),
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       hintText: "Type your thoughts here...",
//                       hintStyle: TextStyle(color: Colors.white54),
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 20),

//               // Animated Analyze Button
//               Bounce(
//                 duration: const Duration(milliseconds: 700),
//                 child: ElevatedButton.icon(
//                   onPressed: analyzeStressLevel,
//                   icon: const Icon(Icons.favorite, color: Colors.white),
//                   label: const Text(
//                     "Analyze Stress",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.tealAccent.shade700,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 30,
//                       vertical: 12,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 20),

//               // Floating Card for Result
//               if (_result.isNotEmpty)
//                 FadeIn(
//                   duration: const Duration(milliseconds: 500),
//                   child: Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           blurRadius: 8,
//                           spreadRadius: 2,
//                         ),
//                       ],
//                     ),
//                     child: Text(
//                       _result,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),

//               const SizedBox(height: 20),

//               // Animated Motivational Quote
//               FadeInUp(
//                 duration: const Duration(milliseconds: 700),
//                 child: Text(
//                   _quote,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontStyle: FontStyle.italic,
//                     color: Colors.white70,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // text_analysis.dart
// import 'package:flutter/material.dart';
// import 'package:dart_sentiment/dart_sentiment.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:animate_do/animate_do.dart';
// import 'package:translator/translator.dart';
// import 'dart:math';

// const Map<String, Map<String, String>> textTranslations = {
//   'en': {'title': 'English', 'hint': 'Type your thoughts here...'},
//   'hi': {'title': 'हिंदी', 'hint': 'अपने विचार यहाँ लिखें...'},
//   'ta': {'title': 'தமிழ்', 'hint': 'உங்கள் எண்ணங்களை இங்கே உள்ளிடவும்...'},
//   'te': {'title': 'తెలుగు', 'hint': 'మీ ఆలోచనలను ఇక్కడ టైప్ చేయండి...'},
//   'ml': {
//     'title': 'മലയാളം',
//     'hint': 'നിങ്ങളുടെ ചിന്തകൾ ഇവിടെ ടൈപ്പ് ചെയ്യുക...',
//   },
//   'kn': {'title': 'ಕನ್ನಡ', 'hint': 'ನಿಮ್ಮ ಯೋಚನೆಗಳನ್ನು ಇಲ್ಲಿ ಟೈಪ್ ಮಾಡಿ...'},
// };

// class TextAnalysisScreen extends StatefulWidget {
//   const TextAnalysisScreen({super.key});

//   @override
//   _TextAnalysisScreenState createState() => _TextAnalysisScreenState();
// }

// class _TextAnalysisScreenState extends State<TextAnalysisScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final _sentiment = Sentiment();
//   final _translator = GoogleTranslator();
//   String _result = "";
//   String _quote = "🌿 Breathe in, breathe out. Everything will be okay.";
//   String _selectedLanguage = 'en';

//   final List<String> quotes = [
//     "🌻 Stay strong, things will get better.",
//     "🌊 One step at a time, one breath at a time.",
//     "💙 You are enough. More than enough.",
//     "☀️ The sun will rise, and so will you.",
//     "🌈 Keep going, you are doing amazing.",
//     "☔ Every storm runs out of rain.",
//     "🌸 Be gentle with yourself. You're growing.",
//     "✨ Your mind deserves peace. Choose calmness.",
//   ];

//   void analyzeStressLevel() async {
//     String inputText = _controller.text.trim();
//     if (inputText.isEmpty) {
//       setState(() => _result = "Please enter some text to analyze");
//       return;
//     }

//     String textToAnalyze = inputText;
//     if (_selectedLanguage != 'en') {
//       textToAnalyze = (await _translator.translate(inputText, to: 'en')).text;
//     }

//     final analysis = _sentiment.analysis(textToAnalyze, emoji: true);
//     final score = analysis['score'];

//     String stressLevel;
//     String emoji;

//     if (score < -3) {
//       emoji = "🔴";
//       stressLevel = "High Stress\n💙 Take time for yourself.";
//     } else if (score < 0) {
//       emoji = "🟠";
//       stressLevel = "Moderate Stress\n🌊 Try to relax and breathe.";
//     } else {
//       emoji = "🟢";
//       stressLevel = "Low Stress\n✨ You're doing great!";
//     }

//     setState(() {
//       _result = "$emoji Stress Level: $stressLevel\n(Score: $score)";
//       _quote = quotes[Random().nextInt(quotes.length)];
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final hintText = textTranslations[_selectedLanguage]!['hint']!;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           '✨ Stress Detector',
//           style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 15.0),
//             child: DropdownButton<String>(
//               value: _selectedLanguage,
//               underline: const SizedBox(),
//               icon: const Icon(Icons.language, color: Colors.deepPurple),
//               items:
//                   textTranslations.keys.map((lang) {
//                     return DropdownMenuItem(
//                       value: lang,
//                       child: Text(
//                         textTranslations[lang]!['title']!,
//                         style: GoogleFonts.poppins(),
//                       ),
//                     );
//                   }).toList(),
//               onChanged: (value) => setState(() => _selectedLanguage = value!),
//             ),
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Color(0xFFF8F9FF), Color(0xFFE9E4F0)],
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               ElasticIn(
//                 child: Card(
//                   elevation: 5,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15.0),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: TextField(
//                       controller: _controller,
//                       maxLines: 5,
//                       style: GoogleFonts.poppins(),
//                       decoration: InputDecoration(
//                         border: InputBorder.none,
//                         hintText: hintText,
//                         hintStyle: GoogleFonts.poppins(color: Colors.grey),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               FadeInUp(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
//                     ),
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: ElevatedButton(
//                     onPressed: analyzeStressLevel,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.transparent,
//                       shadowColor: Colors.transparent,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 40,
//                         vertical: 15,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                     ),
//                     child: Text(
//                       'Analyze Stress',
//                       style: GoogleFonts.poppins(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               if (_result.isNotEmpty)
//                 FadeIn(
//                   child: Card(
//                     elevation: 5,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15.0),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: Column(
//                         children: [
//                           Text(
//                             _result,
//                             style: GoogleFonts.poppins(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           const SizedBox(height: 15),
//                           Text(
//                             _quote,
//                             textAlign: TextAlign.center,
//                             style: GoogleFonts.poppins(
//                               color: Colors.deepPurple,
//                               fontStyle: FontStyle.italic,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// text_analysis.dart
import 'package:flutter/material.dart';
import 'package:dart_sentiment/dart_sentiment.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:translator/translator.dart';
import 'dart:math';

const Map<String, Map<String, String>> textTranslations = {
  'en': {'title': 'English', 'hint': 'Type your thoughts here...'},
  'hi': {'title': 'हिंदी', 'hint': 'अपने विचार यहाँ लिखें...'},
  'ta': {'title': 'தமிழ்', 'hint': 'உங்கள் எண்ணங்களை இங்கே உள்ளிடவும்...'},
  'te': {'title': 'తెలుగు', 'hint': 'మీ ఆలోచనలను ఇక్కడ టైప్ చేయండి...'},
  'ml': {
    'title': 'മലയാളം',
    'hint': 'നിങ്ങളുടെ ചിന്തകൾ ഇവിടെ ടൈപ്പ് ചെയ്യുക...',
  },
  'kn': {'title': 'ಕನ್ನಡ', 'hint': 'ನಿಮ್ಮ ಯೋಚನೆಗಳನ್ನು ಇಲ್ಲಿ ಟೈಪ್ ಮಾಡಿ...'},
};

class TextAnalysisScreen extends StatefulWidget {
  const TextAnalysisScreen({super.key});

  @override
  _TextAnalysisScreenState createState() => _TextAnalysisScreenState();
}

class _TextAnalysisScreenState extends State<TextAnalysisScreen> {
  final TextEditingController _controller = TextEditingController();
  final _sentiment = Sentiment();
  final _translator = GoogleTranslator();
  String _result = "";
  String _quote = "🌿 Breathe in, breathe out. Everything will be okay.";
  String _selectedLanguage = 'en';

  final List<String> quotes = [
    "🌻 Stay strong, things will get better.",
    "🌊 One step at a time, one breath at a time.",
    "💙 You are enough. More than enough.",
    "☀️ The sun will rise, and so will you.",
    "🌈 Keep going, you are doing amazing.",
    "☔ Every storm runs out of rain.",
    "🌸 Be gentle with yourself. You're growing.",
    "✨ Your mind deserves peace. Choose calmness.",
  ];

  void analyzeStressLevel() async {
    String inputText = _controller.text.trim();
    if (inputText.isEmpty) {
      setState(() => _result = "Please enter some text to analyze");
      return;
    }

    String textToAnalyze = inputText;
    if (_selectedLanguage != 'en') {
      textToAnalyze = (await _translator.translate(inputText, to: 'en')).text;
    }

    final analysis = _sentiment.analysis(textToAnalyze, emoji: true);
    final score = analysis['score'];

    String stressLevel;
    String emoji;

    if (score < -3) {
      emoji = "🔴";
      stressLevel = "High Stress\n💙 Take time for yourself.";
    } else if (score < 0) {
      emoji = "🟠";
      stressLevel = "Moderate Stress\n🌊 Try to relax and breathe.";
    } else {
      emoji = "🟢";
      stressLevel = "Low Stress\n✨ You're doing great!";
    }

    setState(() {
      _result = "$emoji Stress Level: $stressLevel\n(Score: $score)";
      _quote = quotes[Random().nextInt(quotes.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    final hintText = textTranslations[_selectedLanguage]!['hint']!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '✨ Stress Detector',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color.fromARGB(0, 155, 86, 86),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: DropdownButton<String>(
              value: _selectedLanguage,
              underline: const SizedBox(),
              icon: const Icon(Icons.language, color: Colors.white),
              items:
                  textTranslations.keys.map((lang) {
                    return DropdownMenuItem(
                      value: lang,
                      child: Text(
                        textTranslations[lang]!['title']!,
                        style: GoogleFonts.poppins(),
                      ),
                    );
                  }).toList(),
              onChanged: (value) => setState(() => _selectedLanguage = value!),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A237E), Color(0xFF4A148C), Color(0xFF6A1B9A)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              ElasticIn(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ), // Fixed: Added closing bracket here
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: _controller,
                      maxLines: 5,
                      style: GoogleFonts.poppins(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: hintText,
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FadeInUp(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 51, 168, 22),
                        Color.fromARGB(255, 33, 198, 47),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ElevatedButton(
                    onPressed: analyzeStressLevel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      ' Analyze Stress ',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25), // Fixed: Removed extra comma here
              if (_result.isNotEmpty) ...[
                FadeIn(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _result.split('\n')[0],
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _result.split('\n')[1],
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          _quote,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
