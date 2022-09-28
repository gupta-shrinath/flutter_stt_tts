import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

import '../speech_to_text_utils.dart';
import '../text_to_speech_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter STT TTS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Assistant(title: 'Flutter STT TTS'),
    );
  }
}

class Assistant extends StatefulWidget {
  const Assistant({super.key, required this.title});

  final String title;

  @override
  State<Assistant> createState() => _AssistantState();
}

class _AssistantState extends State<Assistant> {
  String displayText = "Press Mic button";
  SpeechToTextUtils speechToTextUtils = SpeechToTextUtils();
  TextToSpeechUtils textToSpeechUtils = TextToSpeechUtils();

  void recogniseSpeech(SpeechRecognitionResult result) {
    setState(() {
      displayText = result.recognizedWords;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await speechToTextUtils.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  displayText,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              onPressed: () async {
                String? text =
                    await speechToTextUtils.startListening(recogniseSpeech);
                setState(() {
                  displayText = text ?? 'Press Mic Button';
                });
              },
              tooltip: 'MIC',
              child: speechToTextUtils.isListening()
                  ? const Icon(Icons.mic)
                  : const Icon(Icons.mic_off),
            ),
            const SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              onPressed: () async {
                setState(() {});
                await textToSpeechUtils.speak(displayText);
                setState(() {});
              },
              child: textToSpeechUtils.isSpeaking()
                  ? const Icon(Icons.pause)
                  : const Icon(Icons.play_arrow),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    speechToTextUtils.stopListening();
    textToSpeechUtils.stop();
    super.dispose();
  }
}
