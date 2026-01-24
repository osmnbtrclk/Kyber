import 'dart:typed_data';

class ByteReader {
  final ByteData byteData;

  ByteReader(this.byteData);

  int offset = 0;

  int readUint64() {
    int value = byteData.getUint64(offset, Endian.little);
    offset += 8;
    return value;
  }

  int readInt() {
    int value = byteData.getInt32(offset, Endian.little);
    offset += 4;
    return value;
  }

  int readUint32() {
    int value = byteData.getUint32(offset, Endian.little);
    offset += 4;
    return value;
  }

  String readTerminatedString() {
    int nullTerminatorIndex = offset;
    while (byteData.getUint8(nullTerminatorIndex) != 0) {
      nullTerminatorIndex++;
    }

    int strSize = nullTerminatorIndex - offset + 1;

    Uint8List strBytes = byteData.buffer.asUint8List(offset, strSize - 1);
    String str = String.fromCharCodes(strBytes);

    offset += strSize;

    return str;
  }

  String readSizedString() {
    int strSize = byteData.getUint8(offset);
    offset += 1;

    Uint8List strBytes = byteData.buffer.asUint8List(offset, strSize);
    String str = String.fromCharCodes(strBytes);
    offset += strSize;

    return str;
  }
}
