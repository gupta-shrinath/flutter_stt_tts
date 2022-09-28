import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

/*
* Uses android.speech.SpeechRecognizer
* https://developer.android.com/reference/android/speech/SpeechRecognizer
* */

class SpeechToTextUtils {
  final SpeechToText _speechToText = SpeechToText();
  bool _isSTTEnabled = false;

  Future<void> initialize() async {
    try {
      _isSTTEnabled = await _speechToText.initialize();
    } catch (e) {
      print("STT Failed!");
    }
  }

  bool isListening() {
    return _speechToText.isListening;
  }

  Future<String?> startListening(
      Function(SpeechRecognitionResult) callback) async {
    bool isRequiredPermissionGranted = await _speechToText.hasPermission;
    if (!_isSTTEnabled) {
      return "Speech Detection Failed! Please restart the app !";
    } else if (isListening()) {
      await stopListening();
      return null;
    } else if (!isRequiredPermissionGranted) {
      await Permission.microphone.request();
    }
    await _speechToText.listen(onResult: callback);
    return null;
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
  }
}
