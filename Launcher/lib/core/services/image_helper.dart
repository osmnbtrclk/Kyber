import 'dart:typed_data';

import 'package:crypto/crypto.dart';

class ImageHelper {
  static String generateHash(Uint8List data) {
    final cnv = md5.convert(data).bytes;
    return cnv.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }
}
