// Provider state: son tespit, TTS tetikleme(Bu kod, Flutter'da bir state management
// (durum yönetimi) yapısını kullanarak bir nesne algılama sistemi için yazılmıştır. Kodun amacı, bir etiket (label) ve
// güven skoru (confidence) ile gelen algılama sonuçlarını yönetmek ve bu sonuçlara göre bir metin okuma (text-to-speech) servisini tetiklemektir)

import 'package:flutter/foundation.dart';
import 'product_repository.dart';
import 'tts_service.dart';

class DetectionState with ChangeNotifier{
  final ProductRepository repo;
  final TtsService tts;

  String? lastLabel; //example -> nescafe_classic
  double? lastConfidence; // mock (algılamanın güven skoru)için %98 gibi

  DetectionState({required this.repo, required this.tts});

  Future<void> setDetection(String label,{double conf = 0.98}) async {
    lastLabel = label;
    lastConfidence = conf;
    final p = repo.get(label);
    if(p != null) {
      await tts.speak("${p.displayName}. ${p.content}");
    }
    notifyListeners();
  }

  void clear() {
    lastLabel = null;
    lastConfidence = null;
    notifyListeners();
  }

}