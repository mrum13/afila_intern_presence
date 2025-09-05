import 'dart:math' as math;
import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';

class FaceRecognitionService {
  late Interpreter _interpreter;

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset(
      'assets/mobile_face_net.tflite',
      options: InterpreterOptions()..threads = 4,
    );
  }

  /// Convert wajah menjadi embedding (192-dim vector)
  List<double> getEmbedding(Float32List input) {
    var output = List.filled(1 * 192, 0.0).reshape([1, 192]);
    _interpreter.run(input.reshape([1, 112, 112, 3]), output);
    return List<double>.from(output[0]);
  }

  /// Hitung cosine similarity
  double cosineSimilarity(List<double> a, List<double> b) {
    double dot = 0, normA = 0, normB = 0;
    for (int i = 0; i < a.length; i++) {
      dot += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }
    return dot / (math.sqrt(normA) * math.sqrt(normB));
  }
}
