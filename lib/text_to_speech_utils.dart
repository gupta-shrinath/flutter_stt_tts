import 'package:flutter_tts/flutter_tts.dart';

/*
* Uses android.speech.tts.TextToSpeech
* https://developer.android.com/reference/android/speech/tts/TextToSpeech
* */
class TextToSpeechUtils {
  FlutterTts textToSpeech = FlutterTts();
  bool _isSpeaking = false;

  Future<void> speak(String inputText) async {
    if (_isSpeaking) {
      await stop();
      return;
    }
    _isSpeaking = true;
    await textToSpeech.awaitSpeakCompletion(true);
    int speech = await textToSpeech.speak(inputText);
    if (speech == 1) {
      _isSpeaking = false;
    }
  }

  bool isSpeaking() {
    return _isSpeaking;
  }

  Future<void> stop() async {
    await textToSpeech.stop();
    _isSpeaking = !_isSpeaking;
  }
}
