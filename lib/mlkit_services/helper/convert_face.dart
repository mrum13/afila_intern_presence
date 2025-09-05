import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ConvertFace {
    Float32List imageToByteListFloat32(img.Image image) {
    // Resize ke 112x112 (input MobileFaceNet)
    final resized = img.copyResize(image, width: 112, height: 112);

    var convertedBytes = Float32List(1 * 112 * 112 * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (var y = 0; y < 112; y++) {
      for (var x = 0; x < 112; x++) {
        final pixel = resized.getPixel(x, y);

        int r = pixel.r.toInt();
        int g = pixel.g.toInt();
        int b = pixel.b.toInt();

        // Normalisasi ke [-1, 1]
        buffer[pixelIndex++] = (r - 128) / 128.0;
        buffer[pixelIndex++] = (g - 128) / 128.0;
        buffer[pixelIndex++] = (b - 128) / 128.0;
      }
    }

    return convertedBytes.buffer.asFloat32List();
  }
}