import 'package:flutter/widgets.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

// const NOT_LISTENING = 'notListening';

class SpeechRecognizer with ChangeNotifier {
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _recognizedText;
  Function _onResult;
  bool _isAvailable = false;
  bool _partialResults = false;
  bool _isStatusListening = true;

  String get recognizedText {
    return _recognizedText;
  }

  bool get isListening {
    return _isListening;
  }

  bool get isStatusListening {
    // print('Changing listening status getter method');
    return _isStatusListening;
  }

  setIsStatusListening(String status) {
    // print('Changing listening status action ' + '' + status);
    if (status == 'listening') {
      _isStatusListening = true;
      notifyListeners();
    } else if (status == 'notListening') {
      _isStatusListening = false;
      notifyListeners();
    } else if (status == 'done') {
      _isStatusListening = false;
      notifyListeners();
    }

    // notifyListeners();
  }

  setRecognizedText(String rt) {
    // print('Set result function');
    _recognizedText = rt;
    _onResult(rt);
    notifyListeners();
  }

  SpeechRecognizer() {
    _speech = stt.SpeechToText();
  }

  void initialize(Function resultHandler) {
    _onResult = resultHandler;
    _isListening = false;
    notifyListeners();
  }

  void listen() async {
    // print('Listen method');
    // print('Before if $_isListening');
    if (!_isAvailable) {
      _isAvailable = await _speech.initialize(
        onStatus: (val) => {
          setIsStatusListening(val),
        },
        onError: (val) => {
          // print('on Error  $val')
        },
      );
    }
    if (!_isListening) {
      // print('islistening $_isListening');
      _isListening = true;
      _speech.listen(
          onResult: (val) => {
                if (val.recognizedWords.length > 0)
                  {setRecognizedText(val.recognizedWords)}
              },
          partialResults: _partialResults);
    } else {
      _isListening = false;
      _speech.stop();
      notifyListeners();
      // print('else');
    }
    notifyListeners();
  }

  // void stop() {
  //   _isListening = false;
  //   _speech.stop();
  // }
}
